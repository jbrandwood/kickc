package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StatementInfos;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.SymbolVariableRef;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.ListIterator;

/** Eliminates procedures that have empty bodies. Also removes any calls to the empty procedures. */
public class PassNEliminateEmptyProcedure extends Pass2SsaOptimization {

   public PassNEliminateEmptyProcedure(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final Collection<Procedure> allProcedures = getScope().getAllProcedures(true);
      boolean optimized = false;
      for(Procedure procedure : allProcedures) {
         if(hasEmptyBody(procedure.getRef())) {
            if(!hasExternalUsages(procedure.getRef(), getProgram()) && !SymbolRef.MAIN_PROC_NAME.equals(procedure.getLabel().getLocalName())) {
               // TODO: Entry point procedures include isAddressOfUsed!
               // Remove all calls
               removeAllCalls(procedure.getRef(), getGraph().getAllBlocks(), getLog());
               // Remove the procedure
               Pass2EliminateUnusedBlocks.removeProcedure(procedure.getRef(), new HashSet<>(), getProgram());
               optimized = true;
            }
         }
      }
      return optimized;
   }

   /**
    * Examines whether there are any constants inside a procedure with external usages
    *
    * @param procedureRef
    * @return
    */
   protected static boolean hasExternalUsages(ProcedureRef procedureRef, Program program) {
      program.clearVariableReferenceInfos();
      program.clearStatementInfos();
      new PassNStatementIndices(program).execute();
      final VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      final StatementInfos statementInfos = program.getStatementInfos();

      final Procedure startProc = program.getScope().getProcedure(procedureRef);
      final Collection<Variable> startConsts = startProc.getAllConstants(true);
      for(Variable startConst : startConsts) {
         final Collection<VariableReferenceInfos.ReferenceToSymbolVar> uses = variableReferenceInfos.getConstRefAllUses(startConst.getConstantRef());
         for(VariableReferenceInfos.ReferenceToSymbolVar use : uses) {
            if(use instanceof VariableReferenceInfos.ReferenceInStatement) {
               final Integer statementIdx = ((VariableReferenceInfos.ReferenceInStatement) use).getStatementIdx();
               final ControlFlowBlock block = statementInfos.getBlock(statementIdx);
               final Procedure useProcedure = block.getProcedure(program);
               if(!procedureRef.equals(useProcedure.getRef())) {
                  // Usage in a another procedure
                  return true;
               }
            } else if(use instanceof VariableReferenceInfos.ReferenceInSymbol) {
               final SymbolVariableRef referencingSymbolRef = ((VariableReferenceInfos.ReferenceInSymbol) use).getReferencingSymbol();
               final Symbol referencingSymbol = program.getScope().getSymbol(referencingSymbolRef);
               final Scope referencingScope = referencingSymbol.getScope();
               if(!procedureRef.equals(referencingScope.getRef())) {
                  // Usage in a another constant
                  return true;
               }
            }
         }
      }
      return false;
   }


   /**
    * Looks through a procedure to determine if it has an empty body.
    *
    * @param procedureRef The procedure to look through
    * @return true if the procedure body is empty.
    */
   private boolean hasEmptyBody(ProcedureRef procedureRef) {
      final List<ControlFlowBlock> procedureBlocks = getGraph().getScopeBlocks(procedureRef);
      // The single no-args no-return call of the procedure (if found)
      for(ControlFlowBlock block : procedureBlocks) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementReturn && ((StatementReturn) statement).getValue() == null) {
               // An empty return is OK
            } else
               // Any other statement is not an empty body
               return false;
         }
      }
      // If we get this far we have an empty body
      return true;
   }

   /**
    * Remove all calls to a procedure from a number of control flow graph blocks
    *
    * @param removeProcRef The procedure to remove calls for
    * @param blocks The blocks to remove the calls from
    */
   public static void removeAllCalls(ProcedureRef removeProcRef, List<ControlFlowBlock> blocks, CompileLog log) {
      for(ControlFlowBlock block : blocks) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCalling && ((StatementCalling) statement).getProcedure().equals(removeProcRef)) {
               log.append("Removing call to empty/unused procedure " + statement.toString());
               stmtIt.remove();
            } else if(statement instanceof StatementCallPrepare && ((StatementCallPrepare) statement).getProcedure().equals(removeProcRef)) {
               log.append("Removing call to empty/unused procedure " + statement.toString());
               stmtIt.remove();
            } else if(statement instanceof StatementCallFinalize && ((StatementCallFinalize) statement).getProcedure().equals(removeProcRef)) {
               log.append("Removing call to empty/unused procedure " + statement.toString());
               stmtIt.remove();
            }
         }
         if(removeProcRef.getLabelRef().equals(block.getCallSuccessor())) {
            block.setCallSuccessor(null);
         }
      }
   }

}
