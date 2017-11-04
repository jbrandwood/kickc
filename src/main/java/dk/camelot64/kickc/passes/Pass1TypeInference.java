package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Stack;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class Pass1TypeInference {

   private ProgramScope programScope;

   public Pass1TypeInference(ProgramScope programScope) {
      this.programScope = programScope;
   }

   public ProgramScope getProgramScope() {
      return programScope;
   }

   public void inferTypes(StatementSequence sequence) {
      Stack<Scope> scopes = new Stack<>();
      scopes.add(programScope);
      for (Statement statement : sequence.getStatements()) {
         if(statement instanceof StatementProcedureBegin) {
                StatementProcedureBegin procedureBegin = (StatementProcedureBegin) statement;
            ProcedureRef procedureRef = procedureBegin.getProcedure();
            Procedure procedure = programScope.getProcedure(procedureRef);
            scopes.push(procedure);
         }  else if(statement instanceof StatementProcedureEnd) {
            scopes.pop();
         } else if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            if (lValue instanceof VariableRef) {
               Variable symbol = programScope.getVariable((VariableRef) lValue);
               if (SymbolTypeBasic.VAR.equals(symbol.getType())) {
                  // Unresolved symbol - perform inference
                  Operator operator = assignment.getOperator();
                  if (operator == null || assignment.getrValue1() == null) {
                     // Copy operation or Unary operation
                     RValue rValue = assignment.getrValue2();
                     SymbolType subType = SymbolTypeInference.inferType(programScope, rValue);
                     SymbolType type = SymbolTypeInference.inferType(operator, subType);
                     symbol.setTypeInferred(type);
                  } else {
                     // Binary operation
                     SymbolType type1 = SymbolTypeInference.inferType(programScope, assignment.getrValue1());
                     SymbolType type2 = SymbolTypeInference.inferType(programScope, assignment.getrValue2());
                     SymbolType type = SymbolTypeInference.inferType(type1, operator, type2);
                     symbol.setTypeInferred(type);
                  }
               }
            }
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            LValue lValue = call.getlValue();
            String procedureName = call.getProcedureName();
            Procedure procedure = scopes.peek().getProcedure(procedureName);
            call.setProcedure(procedure.getRef());
            if(procedure.getParameters().size()!=call.getParameters().size()) {
               throw new RuntimeException("Wrong number of parameters in call. Expected " +procedure.getParameters().size()+". "+statement.toString());
            }
            if(lValue instanceof VariableRef) {
               Variable lValueVar = programScope.getVariable((VariableRef) lValue);
               lValueVar.setTypeInferred(procedure.getReturnType());
            }
         }
      }
   }

}
