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

import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;

/** Convert all struct values that are not used as pointers (address-of used or declared volatile) into variables representing each member */
public class Pass1UnwindStructValues extends Pass1Base {

   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      StructUnwinding structUnwinding = getProgram().getStructUnwinding();
      if(structUnwinding == null) {
         structUnwinding = new StructUnwinding();
         getProgram().setStructUnwinding(structUnwinding);
      }

      // Iterate through all scopes generating member-variables for each struct
      modified |= unwindStructVariables(structUnwinding);
      // Unwind all procedure declaration parameters
      modified |= unwindStructParameters(structUnwinding);
      // Unwind all usages of struct values
      modified |= unwindStructReferences(structUnwinding);
      // Change all usages of members of struct values
      modified |= unwindStructMemberReferences(structUnwinding);
      return modified;
   }

   /**
    * Unwinds all usages of struct value references (in statements such as assignments.)
    *
    * @param structUnwinding Information about all unwound struct variables
    */
   private boolean unwindStructReferences(StructUnwinding structUnwinding) {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               SymbolType lValueType = SymbolTypeInference.inferType(getScope(), assignment.getlValue());
               if(lValueType instanceof SymbolTypeStruct) {
                  modified |= unwindAssignment(assignment, (SymbolTypeStruct) lValueType, stmtIt, block, structUnwinding);
               }
            } else if(statement instanceof StatementCall) {
               modified |= unwindCall((StatementCall) statement, structUnwinding);
            } else if(statement instanceof StatementReturn) {
               modified |= unwindReturn((StatementReturn) statement, structUnwinding);
            }
         }
      }
      return modified;
   }

   /**
    * Change all usages of members inside statements to the unwound member variables
    *
    * @param structUnwinding Information about all unwound struct variables
    */
   private boolean unwindStructMemberReferences(StructUnwinding structUnwinding) {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(
            getProgram(), (programValue, currentStmt, stmtIt, currentBlock) ->
            {
               if(programValue.get() instanceof StructMemberRef) {
                  StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                  if(structMemberRef.getStruct() instanceof VariableRef) {
                     Variable structVariable = getScope().getVariable((VariableRef) structMemberRef.getStruct());
                     StructUnwinding.VariableUnwinding memberVariables = structUnwinding.getVariableUnwinding(structVariable.getRef());
                     if(memberVariables != null) {
                        VariableRef structMemberVariable = (VariableRef) memberVariables.getMemberUnwinding(structMemberRef.getMemberName());
                        getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member variable reference " + structMemberVariable.toString(getProgram()));
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
    * @param structUnwinding Information about all unwound struct variables
    */
   private boolean unwindCall(StatementCall call, StructUnwinding structUnwinding) {

      // Unwind struct value return value
      boolean lvalUnwound = false;
      if(call.getlValue() instanceof VariableRef) {
         Variable lvalueVar = getScope().getVariable((VariableRef) call.getlValue());
         if(lvalueVar.getType() instanceof SymbolTypeStruct) {
            StructUnwinding.VariableUnwinding lValueVarUnwinding = structUnwinding.getVariableUnwinding(lvalueVar.getRef());
            if(lValueVarUnwinding != null) {
               ArrayList<RValue> unwoundMembers = new ArrayList<>();
               for(String memberName : lValueVarUnwinding.getMemberNames()) {
                  unwoundMembers.add(lValueVarUnwinding.getMemberUnwinding(memberName));
               }
               ValueList unwoundLValue = new ValueList(unwoundMembers);
               call.setlValue(unwoundLValue);
               getLog().append("Converted procedure call LValue to member variables " + call.toString(getProgram(), false));
               lvalUnwound = true;
            }
         }
      }

      // Unwind any struct value parameters
      ArrayList<RValue> unwoundParameters = new ArrayList<>();
      boolean anyParameterUnwound = false;
      for(RValue parameter : call.getParameters()) {
         boolean unwound = false;
         if(parameter instanceof VariableRef) {
            Variable variable = getScope().getVariable((VariableRef) parameter);
            if(variable.getType() instanceof SymbolTypeStruct) {
               // Passing a struct variable - convert it to member variables
               StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.getVariableUnwinding((VariableRef) parameter);
               if(variableUnwinding != null) {
                  for(String memberName : variableUnwinding.getMemberNames()) {
                     unwoundParameters.add(variableUnwinding.getMemberUnwinding(memberName));
                  }
                  unwound = true;
                  anyParameterUnwound = true;
               }
            }
         }
         if(!unwound) {
            unwoundParameters.add(parameter);
         }
      }

      if(anyParameterUnwound) {
         call.setParameters(unwoundParameters);
         getLog().append("Converted procedure struct value parameter to member variables in call " + call.toString(getProgram(), false));
      }
      return (anyParameterUnwound || lvalUnwound);
   }

   /**
    * Unwind any return value that is a struct value into the member values
    *
    * @param statementReturn The return to unwind
    * @param structUnwinding Information about all unwound struct variables
    */

   private boolean unwindReturn(StatementReturn statementReturn, StructUnwinding structUnwinding) {
      boolean modified = false;
      // Unwind struct value return value
      if(statementReturn.getValue() instanceof VariableRef) {
         Variable returnValueVar = getScope().getVariable((VariableRef) statementReturn.getValue());
         if(returnValueVar.getType() instanceof SymbolTypeStruct) {
            StructUnwinding.VariableUnwinding returnVarUnwinding = structUnwinding.getVariableUnwinding(returnValueVar.getRef());
            if(returnVarUnwinding != null) {
               ArrayList<RValue> unwoundMembers = new ArrayList<>();
               for(String memberName : returnVarUnwinding.getMemberNames()) {
                  unwoundMembers.add(returnVarUnwinding.getMemberUnwinding(memberName));
               }
               ValueList unwoundReturnValue = new ValueList(unwoundMembers);
               statementReturn.setValue(unwoundReturnValue);
               getLog().append("Converted procedure struct return value to member variables " + statementReturn.toString(getProgram(), false));
               modified = true;
            }
         }
      }
      return modified;
   }


   /**
    * Iterate through all procedures changing parameter lists by unwinding each struct value parameter to the unwound member variables
    *
    * @param structUnwinding Information about all unwound struct variables (including procedure parameters)
    */
   private boolean unwindStructParameters(StructUnwinding structUnwinding) {
      boolean modified = false;
      // Iterate through all procedures changing parameter lists by unwinding each struct value parameter
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         ArrayList<String> unwoundParameterNames = new ArrayList<>();
         boolean procedureUnwound = false;
         for(Variable parameter : procedure.getParameters()) {
            if(parameter.getType() instanceof SymbolTypeStruct) {
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
            getLog().append("Converted procedure struct value parameter to member variables " + procedure.toString(getProgram()));
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
   private boolean unwindStructVariables(StructUnwinding structUnwinding) {
      boolean modified = false;
      // Iterate through all scopes generating member-variables for each struct
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.getType() instanceof SymbolTypeStruct) {
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
                        memberVariable = scope.add(new VariableIntermediate(variable.getLocalName() + "_" + member.getLocalName(), scope, member.getType()));
                     } else {
                        memberVariable = scope.addVariable(variable.getLocalName() + "_" + member.getLocalName(), member.getType());
                     }
                     memberVariable.setDeclaredVolatile(variable.isDeclaredVolatile());
                     memberVariable.setDeclaredConstant(variable.isDeclaredConstant());
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
    * @param structType The struct type being unwound
    * @param stmtIt The statement iterator used for adding/removing statements
    * @param currentBlock The current code block
    * @param structUnwinding Information about unwound struct value variables
    */
   private boolean unwindAssignment(StatementAssignment assignment, SymbolTypeStruct structType, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, StructUnwinding structUnwinding) {
      boolean modified = false;

      StructMemberUnwinding memberUnwinding = getStructMemberUnwinding(assignment.getlValue(), structType, structUnwinding, assignment, stmtIt, currentBlock);
      if(memberUnwinding == null) {
         throw new CompileError("Cannot unwind struct assignment " + assignment.toString(getProgram(), false), assignment);
      }

      if(assignment.getOperator() == null && assignment.getrValue2() instanceof StructZero && assignment.getlValue() instanceof VariableRef) {
         // Zero-initializing a struct - unwind to assigning zero to each member!
         stmtIt.previous();
         for(String memberName : memberUnwinding.getMemberNames()) {
            VariableRef memberVarRef = (VariableRef) memberUnwinding.getMemberUnwinding(memberName);
            Variable memberVar = getScope().getVariable(memberVarRef);
            Statement initStmt = Pass0GenerateStatementSequence.createDefaultInitializationStatement(memberVarRef, memberVar.getType(), assignment.getSource(), Comment.NO_COMMENTS);
            stmtIt.add(initStmt);
            getLog().append("Adding struct value member variable default initializer " + initStmt.toString(getProgram(), false));
         }
         stmtIt.next();
         if(assignment.getlValue() instanceof VariableRef) {
            assignment.setrValue2(new StructUnwoundPlaceholder(structType));
         } else {
            stmtIt.remove();
         }
         modified = true;
      } else if(assignment.getOperator() == null && assignment.getrValue2() instanceof ValueList) {
         // Initializing struct with a value list - unwind to assigning each member with a value from the list
         ValueList valueList = (ValueList) assignment.getrValue2();
         if(memberUnwinding.getMemberNames().size() != valueList.getList().size()) {
            throw new CompileError("Struct initialization list has wrong size. Need  " + memberUnwinding.getMemberNames().size() + " got " + valueList.getList().size(), assignment);
         }
         stmtIt.previous();
         int idx = 0;
         for(String memberName : memberUnwinding.getMemberNames()) {
            LValue memberLvalue = memberUnwinding.getMemberUnwinding(memberName);
            Statement initStmt = new StatementAssignment(memberLvalue, valueList.getList().get(idx++), assignment.getSource(), Comment.NO_COMMENTS);
            stmtIt.add(initStmt);
            getLog().append("Adding struct value list initializer " + initStmt.toString(getProgram(), false));
         }
         stmtIt.next();
         if(assignment.getlValue() instanceof VariableRef) {
            assignment.setrValue2(new StructUnwoundPlaceholder(structType));
         } else {
            stmtIt.remove();
         }
         modified = true;
      } else if(assignment.getOperator() == null) {
         if(assignment.getrValue2() instanceof StructUnwoundPlaceholder)
            return false;
         SymbolType sourceType = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
         if(sourceType.equals(structType)) {
            // Copying a struct - unwind to assigning each member!
            StructMemberUnwinding sourceMemberUnwinding = getStructMemberUnwinding((LValue) assignment.getrValue2(), structType, structUnwinding, assignment, stmtIt, currentBlock);
            if(sourceMemberUnwinding != null) {
               stmtIt.previous();
               for(String memberName : memberUnwinding.getMemberNames()) {
                  LValue assignedMemberVarRef = memberUnwinding.getMemberUnwinding(memberName);
                  LValue sourceMemberVarRef = sourceMemberUnwinding.getMemberUnwinding(memberName);
                  Statement copyStmt = new StatementAssignment(assignedMemberVarRef, sourceMemberVarRef, assignment.getSource(), Comment.NO_COMMENTS);
                  stmtIt.add(copyStmt);
                  getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
               }
               stmtIt.next();
               if(assignment.getlValue() instanceof VariableRef) {
                  assignment.setrValue2(new StructUnwoundPlaceholder(structType));
               } else {
                  stmtIt.remove();
               }
               modified = true;
            }
         } else {
            throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
         }
      } else {
         throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
      }
      return modified;
   }

   private StructMemberUnwinding getStructMemberUnwinding(LValue lValue, SymbolTypeStruct lValueType, StructUnwinding structUnwinding, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(lValue instanceof VariableRef) {
         return structUnwinding.getVariableUnwinding((VariableRef) lValue);
      } else if(lValue instanceof PointerDereferenceSimple) {
         return new StructMemberUnwindingPointerDerefSimple((PointerDereferenceSimple) lValue, lValueType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
      } else if(lValue instanceof PointerDereferenceIndexed) {
         return new StructMemberUnwindingPointerDerefIndexed((PointerDereferenceIndexed) lValue, lValueType.getStructDefinition(getScope()), stmtIt, currentBlock, currentStmt);
      } else {
         throw new InternalError("Struct unwinding not implemented for " + lValue.toString(getProgram()));
      }
   }


   /** Information about how members of an struct Lvalue is unwound. */
   interface StructMemberUnwinding {

      /**
       * Get the names of the members of the struct
       *
       * @return the names
       */
      List<String> getMemberNames();

      /**
       * Get the LValue that a specific member was unwound to
       *
       * @param memberName The member name
       * @return The unwinding of the member
       */
      LValue getMemberUnwinding(String memberName);
   }


   /**
    * Keeps track of all structs that have been unwound into member variables.
    */
   public static class StructUnwinding {

      /** Maps struct variables to unwinding of each member. */
      Map<VariableRef, VariableUnwinding> structVariables = new LinkedHashMap<>();

      /**
       * Get information about how a struct variable was unwound into member variables
       *
       * @param ref The variable to look for
       * @return Information about the unwinding. Null if not unwound
       */
      VariableUnwinding getVariableUnwinding(VariableRef ref) {
         return structVariables.get(ref);
      }

      /**
       * Add information about how a struct variable was unwound into member variables
       *
       * @param ref The variable to add information for
       * @return The new information about the unwinding.
       */
      VariableUnwinding createVariableUnwinding(VariableRef ref) {
         VariableUnwinding existing = structVariables.put(ref, new VariableUnwinding());
         if(existing != null) {
            throw new InternalError("ERROR! Struct unwinding was already created once! " + ref.toString());
         }
         return structVariables.get(ref);
      }

      /**
       * Find the struct variable that the passed symbol was unwound from.
       *
       * @param symbolRef The symbol to look for
       * @return The struct variable containing it. null if the passed symbol is not an unwound variable.
       */
      public VariableRef getContainingStructVariable(SymbolRef symbolRef) {
         for(VariableRef structVarRef : structVariables.keySet()) {
            VariableUnwinding variableUnwinding = getVariableUnwinding(structVarRef);
            for(String memberName : variableUnwinding.getMemberNames()) {
               LValue memberUnwinding = variableUnwinding.getMemberUnwinding(memberName);
               if(memberUnwinding instanceof VariableRef && memberUnwinding.equals(symbolRef)) {
                  return structVarRef;
               }
            }
         }
         return null;
      }


      /** Information about how a single struct variable was unwound. */
      static class VariableUnwinding implements StructMemberUnwinding {

         /** Maps member names to the unwound variables. */
         Map<String, VariableRef> memberUnwinding = new LinkedHashMap<>();

         /** Set how a member variable was unwound to a specific (new) variable. */
         void setMemberUnwinding(String memberName, VariableRef memberVariableUnwound) {
            this.memberUnwinding.put(memberName, memberVariableUnwound);
         }

         /**
          * Get the names of the members of the struct
          *
          * @return the names
          */
         public List<String> getMemberNames() {
            return new ArrayList<>(memberUnwinding.keySet());
         }

         /**
          * Get the (new) variable that a specific member was unwound to
          *
          * @param memberName The member name
          * @return The new variable
          */
         public LValue getMemberUnwinding(String memberName) {
            return this.memberUnwinding.get(memberName);
         }
      }

   }

   /** Unwinding for a simple pointer deref to a struct. */
   private class StructMemberUnwindingPointerDerefSimple implements StructMemberUnwinding {
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final PointerDereferenceSimple pointerDeref;
      private final Statement currentStmt;

      public StructMemberUnwindingPointerDerefSimple(PointerDereferenceSimple pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
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
         VariableIntermediate memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment(memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER)
         return new PointerDereferenceSimple(memberAddress.getRef());
      }
   }

   /** Unwinding for a indexed pointer deref to a struct. */
   private class StructMemberUnwindingPointerDerefIndexed implements StructMemberUnwinding {
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final PointerDereferenceIndexed pointerDeref;
      private final Statement currentStmt;

      public StructMemberUnwindingPointerDerefIndexed(PointerDereferenceIndexed pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
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
         VariableIntermediate memberAddress = scope.addVariableIntermediate();
         memberAddress.setType(new SymbolTypePointer(member.getType()));
         CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
         // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
         stmtIt.add(new StatementAssignment(memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
         // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
         return new PointerDereferenceIndexed(memberAddress.getRef(), pointerDeref.getIndex());
      }
   }

}
