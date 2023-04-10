package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.ProcedureRef;

/**
 * Contains information relevant for compiling a single procedure.
 * TODO: Currently under construction! Many data structures related to compiling procedures are still in {@link Program}
 */
public class ProcedureCompilation {

   /** The procedure being compiled. */
   private ProcedureRef procedureRef;

   /** The statements of the procedure. */
   private StatementSequence statementSequence;

   /** The control flow graph of the procedure. */
   private ControlFlowGraph graph;

   public ProcedureCompilation(ProcedureRef procedureRef) {
      this.procedureRef = procedureRef;
      this.statementSequence = new StatementSequence();
   }

   public ProcedureRef getProcedureRef() {
      return procedureRef;
   }

   public StatementSequence getStatementSequence() {
      return statementSequence;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   public void setGraph(ControlFlowGraph graph) {
      this.graph = graph;
   }

}
