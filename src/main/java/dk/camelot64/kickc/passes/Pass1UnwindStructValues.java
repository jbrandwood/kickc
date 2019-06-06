package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.StructMemberRef;
import dk.camelot64.kickc.model.values.StructZero;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashMap;
import java.util.ListIterator;
import java.util.Map;

/** Convert all struct values that are not used as pointers (address-of used or declared volatile) */
public class Pass1UnwindStructValues extends Pass1Base {

   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;

      // Maps struct variable to map from member name to the variable
      Map<VariableRef, Map<String, VariableRef>> structMemberVariableMap = new LinkedHashMap<>();

      // Iterate through all scopes generating member-variables for each struct
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.getType() instanceof SymbolTypeStruct) {
            if(!variable.isDeclaredVolatile() && !Pass2ConstantIdentification.isAddressOfUsed(variable.getRef(), getProgram())) {
               // A non-volatile struct variable
               Scope scope = variable.getScope();
               StructDefinition structDefinition = ((SymbolTypeStruct) variable.getType()).getStructDefinition(getProgram().getScope());
               LinkedHashMap<String, VariableRef> memberVariables = new LinkedHashMap<>();
               for(Variable member : structDefinition.getAllVariables(false)) {
                  Variable memberVariable;
                  if(variable.getRef().isIntermediate()) {
                     memberVariable = scope.add(new VariableIntermediate(scope.allocateIntermediateVariableName() + "_" + member.getLocalName(), scope, member.getType()));
                  } else {
                     memberVariable = scope.addVariable(variable.getLocalName() + "_" + member.getLocalName(), member.getType());
                  }
                  memberVariables.put(member.getLocalName(), memberVariable.getRef());
                  getLog().append("Created struct value member variable " + memberVariable.toString(getProgram()));
               }
               structMemberVariableMap.put(variable.getRef(), memberVariables);
               getLog().append("Converted struct value to member variables " + variable.toString(getProgram()));
            }
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
                        Map<String, VariableRef> memberVariables = structMemberVariableMap.get(assignedVar.getRef());
                        if(memberVariables != null) {
                           stmtIt.previous();
                           for(String memberName : memberVariables.keySet()) {
                              VariableRef memberVarRef = memberVariables.get(memberName);
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
                           Map<String, VariableRef> assignedMemberVariables = structMemberVariableMap.get(assignedVar.getRef());
                           Map<String, VariableRef> sourceMemberVariables = structMemberVariableMap.get(sourceVar.getRef());
                           if(assignedMemberVariables != null && sourceMemberVariables!=null) {
                              stmtIt.previous();
                              for(String memberName : assignedMemberVariables.keySet()) {
                                 VariableRef assignedMemberVarRef = assignedMemberVariables.get(memberName);
                                 VariableRef sourceMemberVarRef = sourceMemberVariables.get(memberName);
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
         }
      }
   }

   // Change all usages of members in statements
      ProgramValueIterator.execute(

   getProgram(), (programValue,currentStmt,stmtIt,currentBlock)->

   {
      if(programValue.get() instanceof StructMemberRef) {
         StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
         if(structMemberRef.getStruct() instanceof VariableRef) {
            Variable structVariable = getScope().getVariable((VariableRef) structMemberRef.getStruct());
            Map<String, VariableRef> memberVariables = structMemberVariableMap.get(structVariable.getRef());
            if(memberVariables != null) {
               VariableRef structMemberVariable = memberVariables.get(structMemberRef.getMemberName());
               getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member variable reference " + structMemberVariable.toString(getProgram()));
               programValue.set(structMemberVariable);
            }
         }
      }
   });


      return modified;
}

}
