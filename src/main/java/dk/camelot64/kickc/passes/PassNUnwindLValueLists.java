package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;

import java.util.ListIterator;

/** If both LValue and RValue is a list then unwind them */
public class PassNUnwindLValueLists extends Pass2SsaOptimization {

   public PassNUnwindLValueLists(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue() instanceof ValueList && assignment.getOperator()==null && assignment.getrValue2() instanceof ValueList) {
                  // Value-list to value list copy - unwind it
                  ValueList lValueList = (ValueList) assignment.getlValue();
                  ValueList rValueList = (ValueList) assignment.getrValue2();
                  if(lValueList.getList().size()!=rValueList.getList().size()) {
                     throw new CompileError("Assignment value lists have different sizes ", statement);
                  }
                  stmtIt.remove();
                  for(int i = 0; i < lValueList.getList().size(); i++) {
                     LValue lValue = (LValue) lValueList.getList().get(i);
                     RValue rValue = (RValue) rValueList.getList().get(i);
                     stmtIt.add(new StatementAssignment(lValue, rValue, assignment.isInitialAssignment(), assignment.getSource(), Comment.NO_COMMENTS));
                  }
                  getLog().append("Unwinding list assignment "+assignment.toString(getProgram(), false));
                  modified = true;
               }
            }
         }
      }
      return modified;
   }


}
