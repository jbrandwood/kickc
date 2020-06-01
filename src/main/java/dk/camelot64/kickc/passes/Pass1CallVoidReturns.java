package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;

/** Remove temporary variables assigned any void return value */
public class Pass1CallVoidReturns extends Pass2SsaOptimization {

   public Pass1CallVoidReturns(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      new PassNStatementIndices(getProgram()).execute();
      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      VariableReferenceInfos referenceInfos = getProgram().getVariableReferenceInfos();

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               final ProcedureRef procedureRef = ((StatementCall) statement).getProcedure();
               final Procedure procedure = getScope().getProcedure(procedureRef);
               if(SymbolType.VOID.equals(procedure.getReturnType())) {
                  // Found a call to a VOID returning procedure
                  final LValue lValue = ((StatementCall) statement).getlValue();
                  if(lValue instanceof VariableRef) {
                     VariableRef tmpVar = (VariableRef) lValue;
                     final Collection<Integer> usages = referenceInfos.getVarUseStatements(tmpVar);
                     if(usages.size() > 0) {
                        final Integer usageIdx = usages.iterator().next();
                        final Statement usage = getProgram().getStatementInfos().getStatement(usageIdx);
                        throw new CompileError("Error! Function " + procedure.getLocalName() + " does not return a value! ", usage);
                     } else {
                        // Delete the temporary variable
                        final Variable var = getScope().getVar(tmpVar);
                        var.getScope().remove(var);
                        // And remove the lValue
                        ((StatementCall) statement).setlValue(null);
                        if(getLog().isVerbosePass1CreateSsa())
                           getLog().append("Removing LValue from call to function returning void");
                     }
                  }
               }
            }
         }
      }
      getProgram().clearStatementIndices();
      getProgram().clearVariableReferenceInfos();
      getProgram().clearControlFlowBlockSuccessorClosure();
      return false;
   }

}
