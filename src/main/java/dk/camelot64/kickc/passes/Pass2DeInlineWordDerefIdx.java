package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.PointerDereferenceIndexed;
import dk.camelot64.kickc.model.values.PointerDereferenceSimple;
import dk.camelot64.kickc.model.values.RValue;

import java.util.concurrent.atomic.AtomicBoolean;

/** Fnds derefidx with word indices - and de-inlines them (converting to + and normal deref). */
public class Pass2DeInlineWordDerefIdx extends Pass2SsaOptimization {

   public Pass2DeInlineWordDerefIdx(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed dereferenceIndexed = (PointerDereferenceIndexed) programValue.get();
            RValue indexValue = dereferenceIndexed.getIndex();
            SymbolType indexType = SymbolTypeInference.inferType(getScope(), indexValue);
            if(indexType.getSizeBytes()>1) {
               // Index is multiple bytes - de-inline it
               getLog().append("De-inlining pointer[w] to *(pointer+w)   "+currentStmt.toString(getProgram(), false));
               Scope currentScope = getScope().getScope(currentBlock.getScope());
               VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
               SymbolType pointerType = SymbolTypeInference.inferType(getScope(), dereferenceIndexed.getPointer(), Operators.PLUS, indexValue);
               tmpVar.setType(pointerType);
               stmtIt.previous();
               stmtIt.add(new StatementAssignment(tmpVar.getRef(), dereferenceIndexed.getPointer(), Operators.PLUS, indexValue, currentStmt.getSource(), Comment.NO_COMMENTS));
               stmtIt.next();
               programValue.set(new PointerDereferenceSimple(tmpVar.getRef()));
               optimized.set(true);
            }
         }
      });
      return optimized.get();
   }


}
