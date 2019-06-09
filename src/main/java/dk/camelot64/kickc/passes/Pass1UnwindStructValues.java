package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.*;
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
               if(assignment.getlValue() instanceof VariableRef) {
                  Variable assignedVar = getScope().getVariable((VariableRef) assignment.getlValue());
                  if(assignedVar.getType() instanceof SymbolTypeStruct) {
                     modified |= unwindAssignment(assignment, assignedVar, stmtIt, structUnwinding);
                  }
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
                        VariableRef structMemberVariable = memberVariables.getMemberUnwinding(structMemberRef.getMemberName());
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
                  unwoundParameterNames.add(parameterUnwinding.getMemberUnwinding(memberName).getLocalName());
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
               if(!variable.isDeclaredVolatile() && !Pass2ConstantIdentification.isAddressOfUsed(variable.getRef(), getProgram())) {
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
                        variableUnwinding.setMemberUnwinding(member.getLocalName(), memberVariable.getRef());
                        getLog().append("Created struct value member variable " + memberVariable.toString(getProgram()));
                     }
                     getLog().append("Converted struct value to member variables " + variable.toString(getProgram()));
                     modified = true;
                  }
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
    * @param assignedVar The struct value variable being assigned to (the LValue)
    * @param stmtIt The statement iterator used for adding/removing statements
    * @param structUnwinding Information about unwound struct value variables
    */
   private boolean unwindAssignment(StatementAssignment assignment, Variable assignedVar, ListIterator<Statement> stmtIt, StructUnwinding structUnwinding) {
      boolean modified = false;
      // Assigning a struct!
      if(assignment.getOperator() == null && assignment.getrValue2() instanceof StructZero) {
         // Initializing a struct - unwind to assigning zero to each member!
         StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.getVariableUnwinding(assignedVar.getRef());
         if(variableUnwinding != null) {
            stmtIt.previous();
            for(String memberName : variableUnwinding.getMemberNames()) {
               VariableRef memberVarRef = variableUnwinding.getMemberUnwinding(memberName);
               Variable memberVar = getScope().getVariable(memberVarRef);
               Statement initStmt = Pass0GenerateStatementSequence.createDefaultInitializationStatement(memberVarRef, memberVar.getType(), assignment.getSource(), Comment.NO_COMMENTS);
               stmtIt.add(initStmt);
               getLog().append("Adding struct value member variable default initializer " + initStmt.toString(getProgram(), false));
            }
            stmtIt.next();
            stmtIt.remove();
            modified = true;
         }
      } else if(assignment.getOperator() == null && assignment.getrValue2() instanceof VariableRef) {
         Variable sourceVar = getScope().getVariable((VariableRef) assignment.getrValue2());
         if(sourceVar.getType().equals(assignedVar.getType())) {
            // Copying a struct - unwind to assigning each member!
            StructUnwinding.VariableUnwinding assignedMemberVariables = structUnwinding.getVariableUnwinding(assignedVar.getRef());
            StructUnwinding.VariableUnwinding sourceMemberVariables = structUnwinding.getVariableUnwinding(sourceVar.getRef());
            if(assignedMemberVariables != null && sourceMemberVariables != null) {
               stmtIt.previous();
               for(String memberName : assignedMemberVariables.getMemberNames()) {
                  VariableRef assignedMemberVarRef = assignedMemberVariables.getMemberUnwinding(memberName);
                  VariableRef sourceMemberVarRef = sourceMemberVariables.getMemberUnwinding(memberName);
                  Statement copyStmt = new StatementAssignment(assignedMemberVarRef, sourceMemberVarRef, assignment.getSource(), Comment.NO_COMMENTS);
                  stmtIt.add(copyStmt);
                  getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
               }
               stmtIt.next();
               stmtIt.remove();
               modified = true;
            }
         } else {
            throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
         }
      } else if(assignment.getOperator() == null && assignment.getrValue2() instanceof ValueList) {
         // Initializing struct with individual values - unwind to assigning each member with a value from the list
         StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.getVariableUnwinding(assignedVar.getRef());
         if(variableUnwinding != null) {
            ValueList valueList = (ValueList) assignment.getrValue2();
            if(variableUnwinding.getMemberNames().size() != valueList.getList().size()) {
               throw new CompileError("Struct initialization list has wrong size. Need  " + variableUnwinding.getMemberNames().size() + " got " + valueList.getList().size(), assignment);
            }
            stmtIt.previous();
            int idx = 0;
            for(String memberName : variableUnwinding.getMemberNames()) {
               VariableRef memberVarRef = variableUnwinding.getMemberUnwinding(memberName);
               Statement initStmt = new StatementAssignment(memberVarRef, valueList.getList().get(idx++), assignment.getSource(), Comment.NO_COMMENTS);
               stmtIt.add(initStmt);
               getLog().append("Adding struct value list initializer " + initStmt.toString(getProgram(), false));
            }
            stmtIt.next();
            stmtIt.remove();
            modified = true;
         }
      } else {
         throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
      }
      return modified;
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


      /** Information about how a single struct variable was unwound. */
      static class VariableUnwinding {

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
         List<String> getMemberNames() {
            return new ArrayList<>(memberUnwinding.keySet());
         }

         /**
          * Get the (new) variable that a specific member was unwound to
          *
          * @param memberName The member name
          * @return The new variable
          */
         VariableRef getMemberUnwinding(String memberName) {
            return this.memberUnwinding.get(memberName);
         }
      }

   }


}
