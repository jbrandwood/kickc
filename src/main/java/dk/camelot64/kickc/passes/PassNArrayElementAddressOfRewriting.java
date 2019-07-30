package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.PointerDereferenceIndexed;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Rewrite array element address-of &array[n] to the pointer to the n'th element array+n
 */
public class PassNArrayElementAddressOfRewriting extends Pass2SsaOptimization {

   public PassNArrayElementAddressOfRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      // Examine all statements
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator()) ) {
                  RValue rValue = assignment.getrValue2();
                  if(rValue instanceof PointerDereferenceIndexed) {
                     PointerDereferenceIndexed dereferenceIndexed = (PointerDereferenceIndexed) rValue;
                     assignment.setrValue1(dereferenceIndexed.getPointer());
                     assignment.setOperator(Operators.PLUS);
                     assignment.setrValue2(dereferenceIndexed.getIndex());
                     getLog().append("Rewriting array member address-of to pointer addition "+assignment.toString(getProgram(), false));
                     modified.set(true);
                  }
               }
            }
         }
      }
      return modified.get();
   }

}
