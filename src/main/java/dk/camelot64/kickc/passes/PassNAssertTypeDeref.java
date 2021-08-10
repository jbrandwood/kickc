package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.PointerDereference;
import dk.camelot64.kickc.model.values.RValue;

/**
 * Asserts that all dereferenced values are pointers.
 */
public class PassNAssertTypeDeref extends Pass2SsaAssertion {

   public PassNAssertTypeDeref(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereference) {
            RValue pointer = ((PointerDereference) programValue.get()).getPointer();
            SymbolType pointertype = SymbolTypeInference.inferType(getProgram().getScope(), pointer);
            if(!SymbolType.VAR.equals(pointertype) && !(pointertype instanceof SymbolTypePointer))
               throw new CompileError("Dereferencing a non-pointer type "+ pointertype.toCDecl(), currentStmt);
         }
      });
   }


}
