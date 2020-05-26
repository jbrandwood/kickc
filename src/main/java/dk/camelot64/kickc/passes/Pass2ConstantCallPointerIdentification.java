package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPointer;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

/** Pass that identifies indirect calls to constant function pointers */
public class Pass2ConstantCallPointerIdentification extends Pass2SsaOptimization {

   public Pass2ConstantCallPointerIdentification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean optimized = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> statementsIt = block.getStatements().listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementCallPointer) {
               StatementCallPointer callPointer = (StatementCallPointer) statement;
               RValue procedure = callPointer.getProcedure();
               if(procedure instanceof PointerDereferenceSimple) {
                  RValue pointer = ((PointerDereferenceSimple) procedure).getPointer();
                  ProcedureRef constProcedureRef = findConstProcedure(pointer);
                  if(constProcedureRef != null) {
                     replacePointerCall(callPointer, constProcedureRef, statementsIt, block);
                     optimized = true;
                  }
               } else if(procedure instanceof ConstantRef) {
                  Variable procedureVariable = getScope().getConstant((ConstantRef) procedure);
                  SymbolType procedureVariableType = procedureVariable.getType();
                  if(procedureVariableType instanceof SymbolTypePointer) {
                     if(((SymbolTypePointer) procedureVariableType).getElementType() instanceof SymbolTypeProcedure) {
                        ProcedureRef constProcedureRef = findConstProcedure(procedure);
                        if(constProcedureRef != null) {
                           replacePointerCall(callPointer, constProcedureRef, statementsIt, block);
                           optimized = true;
                        }
                     }
                  }
               }
            }
         }
      }
      return optimized;
   }

   /**
    * Replace a pointer-based call to a constant procedure with a classic procedure call
    * @param callPointer The call to replace
    * @param constProcedureRef The constant procedure pointed to
    * @param statementsIt The statement iterator currently pointing to the pointer-based call
    * @param block The block containing the call
    */
   private void replacePointerCall(StatementCallPointer callPointer, ProcedureRef constProcedureRef, ListIterator<Statement> statementsIt, ControlFlowBlock block) {
      statementsIt.remove();
      StatementCall call = new StatementCall(callPointer.getlValue(), constProcedureRef.getFullName(), callPointer.getParameters(), callPointer.getSource(), callPointer.getComments());
      call.setProcedure(constProcedureRef);
      call.setIndex(callPointer.getIndex());
      block.setCallSuccessor(constProcedureRef.getLabelRef());
      statementsIt.add(call);
      final Procedure procedure = getScope().getProcedure(constProcedureRef);
      procedure.setCallingConvention(Procedure.CallingConvention.STACK_CALL);
      getLog().append("Replacing constant pointer function " + call.toString(getProgram(), false));
   }

   /**
    * Examine whither the passed RValue represents a constant procedure pointer.
    * If it does returns the procedure pointed to
    *
    * @param procedurePointer The potential procedure pointer
    * @return The procedure pointed to
    */
   private ProcedureRef findConstProcedure(RValue procedurePointer) {
      if(procedurePointer instanceof ConstantRef) {
         Variable constant = getScope().getConstant((ConstantRef) procedurePointer);
         return findConstProcedure(constant.getInitValue());
      } else if(procedurePointer instanceof ConstantSymbolPointer) {
         ConstantSymbolPointer pointer = (ConstantSymbolPointer) procedurePointer;
         if(pointer.getToSymbol() instanceof ProcedureRef) {
            return (ProcedureRef) pointer.getToSymbol();
         }
      }
      return null;
   }

}
