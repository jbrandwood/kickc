package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.StructMemberRef;
import dk.camelot64.kickc.model.values.StructZero;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/** Convert all struct values that are not used as pointers (address-of used or declared volatile) into variables representing each member */
public class Pass1UnwindStructValues extends Pass1Base {

   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;

      // Maps struct variable to map from member name to the variable
      StructUnwinding structUnwinding = new StructUnwinding();

      // Iterate through all scopes generating member-variables for each struct
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.getType() instanceof SymbolTypeStruct) {
            if(!variable.isDeclaredVolatile() && !Pass2ConstantIdentification.isAddressOfUsed(variable.getRef(), getProgram())) {
               // A non-volatile struct variable
               Scope scope = variable.getScope();
               StructDefinition structDefinition = ((SymbolTypeStruct) variable.getType()).getStructDefinition(getProgram().getScope());
               StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.createVariableUnwinding(variable.getRef());
               for(Variable member : structDefinition.getAllVariables(false)) {
                  Variable memberVariable;
                  if(variable.getRef().isIntermediate()) {
                     memberVariable = scope.add(new VariableIntermediate(scope.allocateIntermediateVariableName() + "_" + member.getLocalName(), scope, member.getType()));
                  } else {
                     memberVariable = scope.addVariable(variable.getLocalName() + "_" + member.getLocalName(), member.getType());
                  }
                  variableUnwinding.setMemberUnwinding(member.getLocalName(), memberVariable.getRef());
                  getLog().append("Created struct value member variable " + memberVariable.toString(getProgram()));
               }
               getLog().append("Converted struct value to member variables " + variable.toString(getProgram()));
            }
         }
      }
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
         }
      }


      // Unwind all references to full structs
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue() instanceof VariableRef) {
                  Variable assignedVar = getScope().getVariable((VariableRef) assignment.getlValue());
                  if(assignedVar.getType() instanceof SymbolTypeStruct) {
                     // Assigning a struct!
                     if(assignment.getOperator() == null && assignment.getrValue2() instanceof StructZero) {
                        // Initializing a struct - unwind to assigning zero to each member!
                        StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.getVariableUnwinding(assignedVar.getRef());
                        if(variableUnwinding != null) {
                           stmtIt.previous();
                           for(String memberName : variableUnwinding.getMemberNames()) {
                              VariableRef memberVarRef = variableUnwinding.getMemberUnwinding(memberName);
                              Variable memberVar = getScope().getVariable(memberVarRef);
                              Statement initStmt = Pass0GenerateStatementSequence.createDefaultInitializationStatement(memberVarRef, memberVar.getType(), statement.getSource(), Comment.NO_COMMENTS);
                              stmtIt.add(initStmt);
                              getLog().append("Adding struct value member variable default initializer " + initStmt.toString(getProgram(), false));
                           }
                           stmtIt.next();
                           stmtIt.remove();
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
                                 Statement copyStmt = new StatementAssignment(assignedMemberVarRef, sourceMemberVarRef, statement.getSource(), Comment.NO_COMMENTS);
                                 stmtIt.add(copyStmt);
                                 getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
                              }
                              stmtIt.next();
                              stmtIt.remove();
                           }
                        } else {
                           throw new RuntimeException("Struct assignment not implemented yet " + statement.toString(getProgram(), false));
                        }
                     }
                  }
               }
            } else if(statement instanceof StatementCall) {
               StatementCall statementCall = (StatementCall) statement;
               Procedure procedure = getScope().getProcedure(statementCall.getProcedure());
               ArrayList<RValue> unwoundParameters = new ArrayList<>();
               boolean anyUnwound = false;
               for(RValue parameter : statementCall.getParameters()) {
                  boolean unwound = false;
                  if(parameter instanceof VariableRef) {
                     Variable variable = getScope().getVariable((VariableRef) parameter);
                     if(variable.getType() instanceof SymbolTypeStruct) {
                        // Passing a struct variable - convert it to member variables
                        StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.getVariableUnwinding((VariableRef) parameter);
                        if(variableUnwinding!=null) {
                           for(String memberName : variableUnwinding.getMemberNames()) {
                              unwoundParameters.add(variableUnwinding.getMemberUnwinding(memberName));
                           }
                           unwound = true;
                           anyUnwound = true;
                        }
                     }
                  }
                  if(!unwound) {
                     unwoundParameters.add(parameter);
                  }
               }

               if(anyUnwound) {
                  statementCall.setParameters(unwoundParameters);
                  getLog().append("Converted procedure struct value parameter to member variables in call " + statementCall.toString(getProgram(), false));
               }
            }
         }
      }

      // Change all usages of members inside statements
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
                     }
                  }
               }
            });


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
      public VariableUnwinding getVariableUnwinding(VariableRef ref) {
         return structVariables.get(ref);
      }

      /**
       * Add information about how a struct variable was unwound into member variables
       *
       * @param ref The variable to add information for
       * @return The new information about the unwinding.
       */
      public VariableUnwinding createVariableUnwinding(VariableRef ref) {
         VariableUnwinding existing = structVariables.put(ref, new VariableUnwinding());
         if(existing != null) {
            throw new InternalError("ERROR! Struct unwinding was already created once! " + ref.toString());
         }
         return structVariables.get(ref);
      }


      /** Information about how a single struct variable was unwound. */
      public static class VariableUnwinding {

         /** Maps member names to the unwound variables. */
         Map<String, VariableRef> memberUnwinding = new LinkedHashMap<>();

         /** Set how a member variable was unwound to a specific (new) variable. */
         public void setMemberUnwinding(String memberName, VariableRef memberVariableUnwound) {
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
         public VariableRef getMemberUnwinding(String memberName) {
            return this.memberUnwinding.get(memberName);
         }
      }

   }


}
