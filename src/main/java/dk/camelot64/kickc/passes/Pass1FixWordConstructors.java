package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

/**
 * The syntax for word constructors <code>word w = { b1, b2 };</code>
 * is turned into a binary operator <code>word w = b1 _toword_ b2 ;</code>
 */
public class Pass1FixWordConstructors extends Pass1Base {

   public Pass1FixWordConstructors(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      ProgramScope programScope = getProgram().getScope();
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1()==null && assignment.getOperator()==null) {
                  if(assignment.getrValue2() instanceof ValueList) {
                     ValueList list = (ValueList) assignment.getrValue2();
                     if(list.getList().size()==2) {
                        // We have a simple assignment of a length 2 value list to a variable
                        SymbolType lType = SymbolTypeInference.inferType(programScope, assignment.getlValue());
                        SymbolType elmType1 = SymbolTypeInference.inferType(programScope, list.getList().get(0));
                        SymbolType elmType2 = SymbolTypeInference.inferType(programScope, list.getList().get(1));
                        if(SymbolType.isWord(lType) && SymbolType.isByte(elmType1) && SymbolType.isByte(elmType2)) {
                           // Types are word = { byte, byte } - perform the modification
                           assignment.setrValue1(list.getList().get(0));
                           assignment.setOperator(Operator.WORD);
                           assignment.setrValue2(list.getList().get(1));
                           getLog().append("Fixing word constructor with " + assignment.toString());
                        }
                     }
                  }
               }
            }
         }
      }
      return false;
   }

}
