package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPointer;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

/** Pass that identified indirect calls to constant function pointers */
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
                     statementsIt.remove();
                     StatementCall call = new StatementCall(callPointer.getlValue(), constProcedureRef.getFullName(), callPointer.getParameters(), callPointer.getSource(), callPointer.getComments());
                     call.setProcedure(constProcedureRef);
                     call.setIndex(callPointer.getIndex());
                     block.setCallSuccessor(constProcedureRef.getLabelRef());
                     statementsIt.add(call);
                     getLog().append("Replacing constant pointer function " + call.toString(getProgram(), false));
                  }
               } else if(procedure instanceof ConstantRef) {
                  ConstantVar procedureVariable = getScope().getConstant((ConstantRef) procedure);
                  SymbolType procedureVariableType = procedureVariable.getType();
                  if(procedureVariableType instanceof SymbolTypePointer) {
                     if(((SymbolTypePointer) procedureVariableType).getElementType() instanceof SymbolTypeProcedure) {
                        optimized = true;
                        throw new RuntimeException("not implemented!");
                     }
                  }
               }
            }
         }
      }
      return optimized;
   }

   private ProcedureRef findConstProcedure(RValue procedurePointer) {
      if(procedurePointer instanceof ConstantRef) {
         ConstantVar constant = getScope().getConstant((ConstantRef) procedurePointer);
         return findConstProcedure(constant.getValue());
      } else if(procedurePointer instanceof ConstantSymbolPointer) {
         ConstantSymbolPointer pointer = (ConstantSymbolPointer) procedurePointer;
         if(pointer.getToSymbol() instanceof ProcedureRef) {
            return (ProcedureRef) pointer.getToSymbol();
         }
      }
      return null;
   }

}
