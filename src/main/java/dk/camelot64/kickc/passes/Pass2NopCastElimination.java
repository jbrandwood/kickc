package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.LinkedHashMap;
import java.util.ListIterator;

/**
 * Compiler Pass eliminating cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
 */
public class Pass2NopCastElimination extends Pass2SsaOptimization {

   public Pass2NopCastElimination(Program program) {
      super(program);
   }

   /**
    * Eliminate cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
    */
   @Override
   public boolean step() {
      LinkedHashMap<SymbolRef, RValue> castAliasses = new LinkedHashMap<>();

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement stmt = stmtIt.next();
            if(stmt instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) stmt;
               if(assignment.getlValue() instanceof VariableRef && assignment.getrValue1()==null && assignment.getOperator()!=null ) {
                  // It is a simple cast assignment - check if it is no-op
                  SymbolType rValType = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
                  boolean isSimpleCast = false;
                  SymbolType toType = null;
                  if(SymbolType.isByte(rValType) && Operator.CAST_SBYTE.equals(assignment.getOperator())) {
                     isSimpleCast = true;
                     toType = SymbolType.SBYTE;
                  } else if(SymbolType.isSByte(rValType) && Operator.CAST_BYTE.equals(assignment.getOperator())) {
                     isSimpleCast = true;
                     toType = SymbolType.BYTE;
                  } else if(SymbolType.isWord(rValType) && Operator.CAST_SWORD.equals(assignment.getOperator())) {
                     isSimpleCast = true;
                     toType = SymbolType.SWORD;
                  } else if(SymbolType.isSWord(rValType) && Operator.CAST_WORD.equals(assignment.getOperator())) {
                     isSimpleCast = true;
                     toType = SymbolType.WORD;
                  }
                  if(isSimpleCast) {
                     getLog().append("Eliminating Noop Cast "+assignment.toString(getProgram(), false));
                     // Add the alias for replacement
                     castAliasses.put((VariableRef) assignment.getlValue(), new CastValue(toType, assignment.getrValue2()));
                     // Remove the assignment
                     stmtIt.remove();
                  }
               }
            }
         }
      }
      replaceVariables(castAliasses);
      deleteSymbols(castAliasses.keySet());
      return (castAliasses.size() > 0);
   }


}
