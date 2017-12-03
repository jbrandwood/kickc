package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.Stack;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class Pass1TypeInference extends Pass1Base {

   public Pass1TypeInference(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      Stack<Scope> scopes = new Stack<>();
      ProgramScope programScope = getScope();
      scopes.add(programScope);
      for (Statement statement : getProgram().getStatementSequence().getStatements()) {
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
               if (SymbolType.VAR.equals(symbol.getType())) {
                  // Unresolved symbol - perform inference
                  Operator operator = assignment.getOperator();
                  if (operator == null || assignment.getrValue1() == null) {
                     // Copy operation or Unary operation
                     RValue rValue = assignment.getrValue2();
                     SymbolType type = SymbolTypeInference.inferType(programScope, operator, rValue);
                     symbol.setTypeInferred(type);
                  } else {
                     // Binary operation
                     SymbolType type = SymbolTypeInference.inferType(programScope, assignment.getrValue1(), assignment.getOperator(), assignment.getrValue2());
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
               throw new CompileError("Wrong number of parameters in call. Expected " +procedure.getParameters().size()+". "+statement.toString());
            }
            if(lValue instanceof VariableRef) {
               Variable lValueVar = programScope.getVariable((VariableRef) lValue);
               lValueVar.setTypeInferred(procedure.getReturnType());
            }
         }
      }
      return false;
   }

}
