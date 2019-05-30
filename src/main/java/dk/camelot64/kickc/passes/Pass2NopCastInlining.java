package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashMap;
import java.util.ListIterator;

/**
 * Compiler Pass inlineng cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
 */
public class Pass2NopCastInlining extends Pass2SsaOptimization {

   public Pass2NopCastInlining(Program program) {
      super(program);
   }

   /**
    * Inline cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
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
               // TODO: Handle constant values?
               if(assignment.getOperator()==null && assignment.getrValue2() instanceof CastValue) {
                  CastValue castValue = (CastValue) assignment.getrValue2();
                  SymbolType subValType = SymbolTypeInference.inferType(getScope(), castValue.getValue());
                  boolean isNopCast = false;
                  if(SymbolType.BYTE.equals(castValue.getToType()) && SymbolType.SBYTE.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.SBYTE.equals(castValue.getToType()) && SymbolType.BYTE.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.WORD.equals(castValue.getToType()) && SymbolType.SWORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.SWORD.equals(castValue.getToType()) && SymbolType.WORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(castValue.getToType() instanceof SymbolTypePointer && SymbolType.WORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.WORD.equals(castValue.getToType()) && subValType instanceof SymbolTypePointer) {
                     isNopCast = true;
                  } else if(castValue.getToType() instanceof SymbolTypePointer && subValType instanceof SymbolTypePointer) {
                     isNopCast = true;
                  }
                  if(isNopCast && assignment.getlValue() instanceof VariableRef) {
                     getLog().append("Inlining Noop Cast " + assignment.toString(getProgram(), false));
                     // Add the alias for replacement
                     castAliasses.put((VariableRef) assignment.getlValue(), assignment.getrValue2());
                     // Remove the assignment
                     stmtIt.remove();
                  }

               }
            }
         }
      }
      replaceVariables(castAliasses);
      deleteSymbols(getScope(), castAliasses.keySet());
      return (castAliasses.size() > 0);
   }


}
