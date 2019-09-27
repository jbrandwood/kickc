package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;
import java.util.concurrent.atomic.AtomicBoolean;

/** Convert all struct values that are not used as pointers (address-of used or declared volatile) into variables representing each member */
public class Pass1UnwindStructValues extends Pass1Base {


   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      if(getProgram().getStructUnwinding() == null) {
         getProgram().setStructUnwinding(new StructUnwinding());
      }
      // Iterate through all scopes generating member-variables for each struct
      boolean modified = false;
      modified |= unwindStructVariables();
      // Unwind all procedure declaration parameters
      modified |= unwindStructParameters();
      // Unwind all usages of struct values
      modified |= unwindStructReferences();
      // Change all usages of members of struct values
      modified |= unwindStructMemberReferences();
      return modified;
   }

   /**
    * Unwinds all usages of struct value references (in statements such as assignments.)
    */
   private boolean unwindStructReferences() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               modified |= unwindAssignment((StatementAssignment) statement, stmtIt, block);
            } else if(statement instanceof StatementCall) {
               modified |= unwindCall((StatementCall) statement, stmtIt, block);
            } else if(statement instanceof StatementReturn) {
               modified |= unwindReturn((StatementReturn) statement, stmtIt, block);
            }
         }
      }
      return modified;
   }

   /**
    * Change all usages of members inside statements to the unwound member variables
    */
   private boolean unwindStructMemberReferences() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(
            getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof StructMemberRef) {
                  StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                  if(structMemberRef.getStruct() instanceof VariableRef) {
                     StructUnwinding.StructMemberUnwinding memberVariables = getStructMemberUnwinding(structMemberRef.getStruct(), currentStmt, stmtIt, currentBlock);
                     if(memberVariables != null && memberVariables != POSTPONE_UNWINDING) {
                        LValue structMemberVariable = memberVariables.getMemberUnwinding(structMemberRef.getMemberName());
                        getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member unwinding reference " + structMemberVariable.toString(getProgram()));
                        programValue.set(structMemberVariable);
                        modified.set(true);
                     }
                  }
               }
            });
      return modified.get();
   }

   /**
    * Unwind any call parameter that is a struct value into the member values
    *
    * @param call The call to unwind
    */
   private boolean unwindCall(StatementCall call, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      // Unwind struct value return value
      boolean lvalUnwound = false;
      StructUnwinding.StructMemberUnwinding lValueUnwinding = getStructMemberUnwinding(call.getlValue(), call, stmtIt, currentBlock);
      if(lValueUnwinding != null && lValueUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueUnwinding.getMemberNames()) {
            unwoundMembers.add(lValueUnwinding.getMemberUnwinding(memberName));
         }
         ValueList unwoundLValue = new ValueList(unwoundMembers);
         call.setlValue(unwoundLValue);
         getLog().append("Converted procedure call LValue to member unwinding " + call.toString(getProgram(), false));
         lvalUnwound = true;
      }

      // Unwind any struct value parameters
      ArrayList<RValue> unwoundParameters = new ArrayList<>();
      boolean anyParameterUnwound = false;
      for(RValue parameter : call.getParameters()) {
         boolean unwound = false;
         StructUnwinding.StructMemberUnwinding parameterUnwinding = getStructMemberUnwinding(parameter, call, stmtIt, currentBlock);
         if(parameterUnwinding != null && parameterUnwinding != POSTPONE_UNWINDING) {
            // Passing a struct variable - convert it to member variables
            for(String memberName : parameterUnwinding.getMemberNames()) {
               unwoundParameters.add(parameterUnwinding.getMemberUnwinding(memberName));
            }
            unwound = true;
            anyParameterUnwound = true;
         }
         if(!unwound) {
            unwoundParameters.add(parameter);
         }
      }

      if(anyParameterUnwound) {
         call.setParameters(unwoundParameters);
         getLog().append("Converted procedure struct value parameter to member unwinding in call " + call.toString(getProgram(), false));
      }
      return (anyParameterUnwound || lvalUnwound);
   }

   /**
    * Unwind any return value that is a struct value into the member values
    *
    * @param statementReturn The return to unwind
    */

   private boolean unwindReturn(StatementReturn statementReturn, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      boolean modified = false;
      // Unwind struct value return value
      StructUnwinding.StructMemberUnwinding returnVarUnwinding = getStructMemberUnwinding(statementReturn.getValue(), statementReturn, stmtIt, currentBlock);
      if(returnVarUnwinding != null && returnVarUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : returnVarUnwinding.getMemberNames()) {
            unwoundMembers.add(returnVarUnwinding.getMemberUnwinding(memberName));
         }
         ValueList unwoundReturnValue = new ValueList(unwoundMembers);
         statementReturn.setValue(unwoundReturnValue);
         getLog().append("Converted procedure struct return value to member unwinding " + statementReturn.toString(getProgram(), false));
         modified = true;

      }
      return modified;
   }

   /**
    * Iterate through all procedures changing parameter lists by unwinding each struct value parameter to the unwound member variables
    */
   private boolean unwindStructParameters() {
      boolean modified = false;
      // Iterate through all procedures changing parameter lists by unwinding each struct value parameter
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         ArrayList<String> unwoundParameterNames = new ArrayList<>();
         boolean procedureUnwound = false;
         for(Variable parameter : procedure.getParameters()) {
            if(parameter.getType() instanceof SymbolTypeStruct) {
               StructUnwinding structUnwinding = getProgram().getStructUnwinding();
               StructUnwinding.VariableUnwinding parameterUnwinding = structUnwinding.getVariableUnwinding(parameter.getRef());
               for(String memberName : parameterUnwinding.getMemberNames()) {
                  VariableRef memberUnwinding = (VariableRef) parameterUnwinding.getMemberUnwinding(memberName);
                  unwoundParameterNames.add(memberUnwinding.getLocalName());
                  procedureUnwound = true;
               }
            } else {
               unwoundParameterNames.add(parameter.getLocalName());
            }
         }
         if(procedureUnwound) {
            procedure.setParameterNames(unwoundParameterNames);
            getLog().append("Converted procedure struct value parameter to member unwinding " + procedure.toString(getProgram()));
            modified = true;
         }
      }
      return modified;
   }

   /**
    * Iterate through all scopes generating member-variables for each struct variable
    *
    * @return Information about all unwound struct variables
    */
   private boolean unwindStructVariables() {
      boolean modified = false;
      // Iterate through all scopes generating member-variables for each struct
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.getType() instanceof SymbolTypeStruct) {
            StructUnwinding structUnwinding = getProgram().getStructUnwinding();
            if(structUnwinding.getVariableUnwinding(variable.getRef()) == null) {
               // A non-volatile struct variable
               Scope scope = variable.getScope();
               if(!(scope instanceof StructDefinition)) {
                  // Not inside another struct
                  StructDefinition structDefinition = ((SymbolTypeStruct) variable.getType()).getStructDefinition(getProgram().getScope());
                  StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.createVariableUnwinding(variable.getRef());
                  for(Variable member : structDefinition.getAllVariables(false)) {
                     Variable memberVariable;
                     if(variable.getRef().isIntermediate()) {
                        memberVariable = scope.add(new Variable(variable.getLocalName() + "_" + member.getLocalName(), scope, member.getType(), variable.getDataSegment(), true, false));
                     } else {
                        memberVariable = scope.addVariable(variable.getLocalName() + "_" + member.getLocalName(), member.getType(), variable.getDataSegment());
                     }
                     memberVariable.setDeclaredVolatile(variable.isDeclaredVolatile());
                     memberVariable.setInferedVolatile(variable.isInferedVolatile());
                     memberVariable.setDeclaredConstant(variable.isDeclaredConstant());
                     memberVariable.setDeclaredExport(variable.isDeclaredExport());
                     variableUnwinding.setMemberUnwinding(member.getLocalName(), memberVariable.getRef());
                     getLog().append("Created struct value member variable " + memberVariable.toString(getProgram()));
                  }
                  getLog().append("Converted struct value to member variables " + variable.toString(getProgram()));
                  modified = true;
               }
            }
         }
      }
      return modified;
   }

   /**
    * Unwind an assignment to a struct value variable into assignment of each member
    *
    * @param assignment The assignment statement
    * @param stmtIt The statement iterator used for adding/removing statements
    * @param currentBlock The current code block
    */
   private boolean unwindAssignment(StatementAssignment assignment, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      StructUnwinding.StructMemberUnwinding memberUnwinding = getStructMemberUnwinding(assignment.getlValue(), assignment, stmtIt, currentBlock);

      if(memberUnwinding == null) {
         return false;
      } else if(memberUnwinding == POSTPONE_UNWINDING) {
         return true;
      }

      if(assignment.getOperator() == null) {
         if(assignment.getrValue2() instanceof StructZero && assignment.getlValue() instanceof VariableRef) {
            // Zero-initializing a struct - unwind to assigning zero to each member!
            List<RValue> membersUnwound = new ArrayList<>();
            stmtIt.previous();
            for(String memberName : memberUnwinding.getMemberNames()) {
               VariableRef memberVarRef = (VariableRef) memberUnwinding.getMemberUnwinding(memberName);
               membersUnwound.add(memberVarRef);
               Variable memberVar = getScope().getVariable(memberVarRef);
               Statement initStmt = Pass0GenerateStatementSequence.createDefaultInitializationStatement(memberVarRef, memberVar.getType(), assignment.getSource(), Comment.NO_COMMENTS);
               stmtIt.add(initStmt);
               getLog().append("Adding struct value member variable default initializer " + initStmt.toString(getProgram(), false));
            }
            stmtIt.next();
            if(assignment.getlValue() instanceof VariableRef) {
               SymbolTypeStruct structType = (SymbolTypeStruct) SymbolTypeInference.inferType(getScope(), assignment.getlValue());
               assignment.setrValue2(new StructUnwoundPlaceholder(structType, membersUnwound));
            } else {
               stmtIt.remove();
            }
            return true;
         } else if(assignment.getrValue2() instanceof ValueList) {
            // Initializing struct with a value list - unwind to assigning each member with a value from the list
            ValueList valueList = (ValueList) assignment.getrValue2();
            if(memberUnwinding.getMemberNames().size() != valueList.getList().size()) {
               throw new CompileError("Struct initialization list has wrong size. Need  " + memberUnwinding.getMemberNames().size() + " got " + valueList.getList().size(), assignment);
            }
            stmtIt.previous();
            List<RValue> membersUnwound = new ArrayList<>();
            int idx = 0;
            for(String memberName : memberUnwinding.getMemberNames()) {
               LValue memberLvalue = memberUnwinding.getMemberUnwinding(memberName);
               membersUnwound.add(memberLvalue);
               Statement initStmt = new StatementAssignment(memberLvalue, valueList.getList().get(idx++), assignment.getSource(), Comment.NO_COMMENTS);
               stmtIt.add(initStmt);
               getLog().append("Adding struct value list initializer " + initStmt.toString(getProgram(), false));
            }
            stmtIt.next();
            if(assignment.getlValue() instanceof VariableRef) {
               SymbolTypeStruct structType = (SymbolTypeStruct) SymbolTypeInference.inferType(getScope(), assignment.getlValue());
               assignment.setrValue2(new StructUnwoundPlaceholder(structType, membersUnwound));
            } else {
               stmtIt.remove();
            }
            return true;
         } else {
            if(assignment.getrValue2() instanceof StructUnwoundPlaceholder)
               return false;
            SymbolTypeStruct structType = (SymbolTypeStruct) SymbolTypeInference.inferType(getScope(), assignment.getlValue());
            SymbolType sourceType = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
            if(sourceType.equals(structType)) {
               // Copying a struct - unwind to assigning each member!
               StructUnwinding.StructMemberUnwinding sourceMemberUnwinding = getStructMemberUnwinding(assignment.getrValue2(), assignment, stmtIt, currentBlock);
               if(sourceMemberUnwinding == null) {
                  throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
               } else if(sourceMemberUnwinding == POSTPONE_UNWINDING) {
                  return true;
               } else {
                  List<RValue> membersUnwound = new ArrayList<>();
                  stmtIt.previous();
                  for(String memberName : memberUnwinding.getMemberNames()) {
                     LValue assignedMemberVarRef = memberUnwinding.getMemberUnwinding(memberName);
                     LValue sourceMemberVarRef = sourceMemberUnwinding.getMemberUnwinding(memberName);
                     membersUnwound.add(assignedMemberVarRef);
                     Statement copyStmt = new StatementAssignment(assignedMemberVarRef, sourceMemberVarRef, assignment.getSource(), Comment.NO_COMMENTS);
                     stmtIt.add(copyStmt);
                     getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
                  }
                  stmtIt.next();
                  if(assignment.getlValue() instanceof VariableRef) {
                     assignment.setrValue2(new StructUnwoundPlaceholder(structType, membersUnwound));
                  } else {
                     stmtIt.remove();
                  }
                  return true;
               }
            } else {
               throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
            }
         }
      }
      throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
   }

   /**
    * Examine a value - and if it represents a struct get the unwinding information for the struct members
    *
    * @param value The struct value
    * @param currentStmt Program Context information. Current statement.
    * @param stmtIt Program Context information. Statement list iterator.
    * @param currentBlock Program Context information. Current block
    * @return null if the value is not a struct. Unwinding for the passed value if it is a struct. {@link #POSTPONE_UNWINDING} if the struct is not ready for unwinding yet.
    */
   private StructUnwinding.StructMemberUnwinding getStructMemberUnwinding(RValue value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(value != null) {
         SymbolType lValueType = SymbolTypeInference.inferType(getScope(), value);
         if(lValueType instanceof SymbolTypeStruct) {
            SymbolTypeStruct structType = (SymbolTypeStruct) lValueType;
            if(value instanceof VariableRef) {
               StructUnwinding structUnwinding = getProgram().getStructUnwinding();
               return structUnwinding.getVariableUnwinding((VariableRef) value);
            } else if(value instanceof StructMemberRef && ((StructMemberRef) value).getStruct() instanceof VariableRef) {
               return POSTPONE_UNWINDING;
            } else if(value instanceof PointerDereferenceSimple) {
               return new StructMemberUnwindingPointerDerefSimple((PointerDereferenceSimple) value, structType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
            } else if(value instanceof PointerDereferenceIndexed) {
               return new StructMemberUnwindingPointerDerefIndexed((PointerDereferenceIndexed) value, structType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
            } else {
               throw new InternalError("Struct unwinding not implemented for " + value.toString(getProgram()));
            }
         }
      }
      return null;
   }

   /** Singleton signaling that unwinding should be postponed. */
   private static final StructUnwinding.StructMemberUnwinding POSTPONE_UNWINDING = new StructUnwinding.StructMemberUnwinding() {
      @Override
      public List<String> getMemberNames() {
         return null;
      }

      @Override
      public LValue getMemberUnwinding(String memberName) {
         return null;
      }
   };

   /** Unwinding for a simple pointer deref to a struct. */
   private class StructMemberUnwindingPointerDerefSimple implements StructUnwinding.StructMemberUnwinding {
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final PointerDereferenceSimple pointerDeref;
      private final Statement currentStmt;

      StructMemberUnwindingPointerDerefSimple(PointerDereferenceSimple pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
         this.pointerDeref = pointerDeref;
         this.currentStmt = currentStmt;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public LValue getMemberUnwinding(String memberName) {
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(getScope(), structDefinition, memberName);
         Variable member = structDefinition.getMember(memberName);
         Scope scope = getScope().getScope(currentBlock.getScope());
         Variable memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment(memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER)
         return new PointerDereferenceSimple(memberAddress.getRef());
      }
   }

   /** Unwinding for a indexed pointer deref to a struct. */
   private class StructMemberUnwindingPointerDerefIndexed implements StructUnwinding.StructMemberUnwinding {
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final PointerDereferenceIndexed pointerDeref;
      private final Statement currentStmt;

      StructMemberUnwindingPointerDerefIndexed(PointerDereferenceIndexed pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
         this.pointerDeref = pointerDeref;
         this.currentStmt = currentStmt;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public LValue getMemberUnwinding(String memberName) {
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(getScope(), structDefinition, memberName);
         Variable member = structDefinition.getMember(memberName);
         Scope scope = getScope().getScope(currentBlock.getScope());
         Variable memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment(memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
         return new PointerDereferenceIndexed(memberAddress.getRef(), pointerDeref.getIndex());
      }
   }

}
