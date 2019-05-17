package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorCast;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.CastValue;

/** Identify unary casts */
public class Pass2InlineCast extends Pass2SsaOptimization {

   public Pass2InlineCast(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean optimized = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1()==null && assignment.getOperator() instanceof OperatorCast) {
                  SymbolType toType = ((OperatorCast) assignment.getOperator()).getToType();
                  assignment.setrValue2(new CastValue(toType, assignment.getrValue2()));
                  assignment.setOperator(null);
                  getLog().append("Inlining cast "+assignment.toString(getProgram(), false));
                  optimized = true;
               }
            }
         }
      }
      return optimized;
   }


}
