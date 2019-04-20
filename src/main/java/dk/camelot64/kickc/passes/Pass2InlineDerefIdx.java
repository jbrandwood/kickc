package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorCastPtr;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.concurrent.atomic.AtomicBoolean;

/** Identify derefs of pointers that are defined as pointer + value - and inline them as derefidx instead */
public class Pass2InlineDerefIdx extends Pass2SsaOptimization {

   public Pass2InlineDerefIdx(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean optimized = new AtomicBoolean(false);
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof PointerDereferenceSimple) {
            PointerDereferenceSimple pointerDereferenceSimple = (PointerDereferenceSimple) programValue.get();
            RValue inlined = attemptInlineDeref(pointerDereferenceSimple.getPointer());
            if(inlined!=null) {
               getLog().append("Converting *(pointer+n) to pointer[n] "+currentStmt.toString(getProgram(), false) + "  -- " + inlined);
               programValue.set(inlined);
               optimized.set(true);
            }
         }
      });
      return optimized.get();
   }

   /**
    * Attempt to inline a pointer reference to an indexed pointer reference
    * by examining the definition of the pointer to see if it is ptr+value
    * @param pointer the pointer
    * @return The indexed pointer dereference if the inlining is possible
    */
   public RValue attemptInlineDeref(RValue pointer) {
      if(pointer instanceof VariableRef) {
         VariableRef derefVar = (VariableRef) pointer;
         StatementLValue derefVarDefined = getGraph().getAssignment(derefVar);
         if(derefVarDefined instanceof StatementAssignment) {
            StatementAssignment derefAssignment = (StatementAssignment) derefVarDefined;
            return attemptInlineDeref(derefAssignment);
         }
      } else if(pointer instanceof CastValue) {
         CastValue castValue = (CastValue) pointer;
         RValue inlined = attemptInlineDeref(castValue.getValue());
         if(inlined!=null) {
            if(inlined instanceof PointerDereferenceIndexed) {
               return new
                     PointerDereferenceIndexed(
                           new CastValue(castValue.getToType(), ((PointerDereferenceIndexed) inlined).getPointer()),
                                 ((PointerDereferenceIndexed) inlined).getIndex());
            }  else {
               throw new CompileError("Not implemented!");
            }
         }
      }
      return null;
   }


   public RValue attemptInlineDeref(StatementAssignment derefAssignment) {
      if(Operators.PLUS.equals(derefAssignment.getOperator())) {
         SymbolType derefLeftType = SymbolTypeInference.inferType(getScope(), derefAssignment.getrValue1());
         if(derefLeftType instanceof SymbolTypePointer) {
            SymbolType derefIndexType = SymbolTypeInference.inferType(getScope(), derefAssignment.getrValue2());
            if(derefIndexType.getSizeBytes()==1) {
               // Only inline byte-based indices
               return new PointerDereferenceIndexed(derefAssignment.getrValue1(), derefAssignment.getrValue2());
            }
         }
      } else if(derefAssignment.getOperator()==null) {
         return attemptInlineDeref(derefAssignment.getrValue2());
      } else if(derefAssignment.getOperator() instanceof OperatorCastPtr) {
         throw new CompileError("Not implemented!");
        //return attemptInlineDeref(derefAssignment.getrValue2());
        }
      return null;
   }


}
