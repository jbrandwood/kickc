package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
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

/** Convert all unwinding struct values into variables representing each member */
public class Pass1UnwindStructValues extends Pass1Base {

   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      if(getProgram().getStructUnwinding() == null) {
         getProgram().setStructUnwinding(new StructUnwinding());
      }
      boolean modified = false;
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
                        RValue structMemberVariable = memberVariables.getMemberUnwinding(structMemberRef.getMemberName(), getScope());
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
            unwoundMembers.add(lValueUnwinding.getMemberUnwinding(memberName, getScope()));
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
               unwoundParameters.add(parameterUnwinding.getMemberUnwinding(memberName, getScope()));
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
            unwoundMembers.add(returnVarUnwinding.getMemberUnwinding(memberName, getScope()));
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
                  SymbolVariableRef memberUnwinding = (SymbolVariableRef) parameterUnwinding.getMemberUnwinding(memberName, getScope());
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
               LValue memberVarRef = (LValue) memberUnwinding.getMemberUnwinding(memberName, getScope());
               membersUnwound.add(memberVarRef);
               StatementSource statementSource = assignment.getSource();
               SymbolType memberType = memberUnwinding.getMemberType(memberName);
               RValue initValue = Initializers.createZeroValue(memberType, statementSource);
               Statement initStmt = new StatementAssignment(memberVarRef, initValue, assignment.isInitialAssignment(), statementSource, Comment.NO_COMMENTS);
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
               LValue memberLvalue = (LValue) memberUnwinding.getMemberUnwinding(memberName, getScope());
               membersUnwound.add(memberLvalue);
               Statement initStmt = new StatementAssignment(memberLvalue, valueList.getList().get(idx++), assignment.isInitialAssignment(), assignment.getSource(), Comment.NO_COMMENTS);
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
                     LValue assignedMemberVarRef = (LValue) memberUnwinding.getMemberUnwinding(memberName, getScope());
                     RValue sourceMemberVarRef = sourceMemberUnwinding.getMemberUnwinding(memberName, getScope());
                     membersUnwound.add(assignedMemberVarRef);
                     Statement copyStmt = new StatementAssignment(assignedMemberVarRef, sourceMemberVarRef, assignment.isInitialAssignment(), assignment.getSource(), Comment.NO_COMMENTS);
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
         SymbolType valueType = SymbolTypeInference.inferType(getScope(), value);
         if(valueType instanceof SymbolTypeStruct) {
            SymbolTypeStruct structType = (SymbolTypeStruct) valueType;
            if(value instanceof VariableRef) {
               Variable variable = getScope().getVariable((VariableRef) value);
               if(variable.isStructUnwind()) {
                  StructUnwinding structUnwinding = getProgram().getStructUnwinding();
                  return structUnwinding.getVariableUnwinding((VariableRef) value);
               } else if(variable.isStructClassic()) {
                  return new StructVariableMemberUnwinding(variable, structType.getStructDefinition(getScope()), currentBlock, stmtIt, currentStmt);
               }
            } else if(value instanceof StructMemberRef && ((StructMemberRef) value).getStruct() instanceof VariableRef) {
               return POSTPONE_UNWINDING;
            } else if(value instanceof PointerDereferenceSimple) {
               return new StructMemberUnwindingPointerDerefSimple((PointerDereferenceSimple) value, structType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
            } else if(value instanceof PointerDereferenceIndexed) {
               return new StructMemberUnwindingPointerDerefIndexed((PointerDereferenceIndexed) value, structType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
            } else if(value instanceof ConstantStructValue) {
               return new StructMemberUnwindingConstantValue((ConstantStructValue) value, structType.getStructDefinition(getScope()));
            } else if(value instanceof StructZero) {
               return new StructMemberUnwindingZero((StructZero) value, structType.getStructDefinition(getScope()));
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
      public LValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         return null;
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return null;
      }
   };

   /** Unwinding for a simple pointer deref to a struct. */
   private static class StructMemberUnwindingPointerDerefSimple implements StructUnwinding.StructMemberUnwinding {
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
      public LValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
         Variable member = structDefinition.getMember(memberName);
         Scope scope = programScope.getScope(currentBlock.getScope());
         Variable memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER)
         return new PointerDereferenceSimple(memberAddress.getRef());
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return structDefinition.getMember(memberName).getType();
      }
   }

   /** Unwinding for a indexed pointer deref to a struct. */
   private static class StructMemberUnwindingPointerDerefIndexed implements StructUnwinding.StructMemberUnwinding {
      private final PointerDereferenceIndexed pointerDeref;
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
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
      public LValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
         Variable member = structDefinition.getMember(memberName);
         Scope scope = programScope.getScope(currentBlock.getScope());
         Variable memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
         return new PointerDereferenceIndexed(memberAddress.getRef(), pointerDeref.getIndex());
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return structDefinition.getMember(memberName).getType();
      }

   }

   /** Unwinding for constant struct value. */
   private static class StructMemberUnwindingConstantValue implements StructUnwinding.StructMemberUnwinding {
      private final ConstantStructValue constantStructValue;
      private final StructDefinition structDefinition;

      StructMemberUnwindingConstantValue(ConstantStructValue constantStructValue, StructDefinition structDefinition) {
         this.constantStructValue = constantStructValue;
         this.structDefinition = structDefinition;
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
      public RValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         Variable member = structDefinition.getMember(memberName);
         return constantStructValue.getValue(member.getRef());
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return structDefinition.getMember(memberName).getType();
      }

   }

   /** Unwinding for a struct value with C-classic memory layout. */
   private static class StructVariableMemberUnwinding implements StructUnwinding.StructMemberUnwinding {
      private Variable variable;
      private StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final Statement currentStmt;

      public StructVariableMemberUnwinding(Variable variable, StructDefinition structDefinition, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt, Statement currentStmt) {
         this.variable = variable;
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
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
      public RValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
         Variable member = structDefinition.getMember(memberName);
         Scope scope = programScope.getScope(currentBlock.getScope());
         Variable memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), structPointer);
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER)
         return new PointerDereferenceSimple(memberAddress.getRef());

      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return structDefinition.getMember(memberName).getType();
      }

   }

   /** Unwinding for StructZero */
   private static class StructMemberUnwindingZero implements StructUnwinding.StructMemberUnwinding {
      private StructZero structZero;
      private StructDefinition structDefinition;

      public StructMemberUnwindingZero(StructZero structZero, StructDefinition structDefinition) {
         this.structZero = structZero;
         this.structDefinition = structDefinition;
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
      public RValue getMemberUnwinding(String memberName, ProgramScope programScope) {
         return ZeroConstantValues.zeroValue(getMemberType(memberName), programScope);
      }

      @Override
      public SymbolType getMemberType(String memberName) {
         return structDefinition.getMember(memberName).getType();
      }
   }
}
