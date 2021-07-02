package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeProcedure;

import java.util.Arrays;

/**
 * Updates procedure calls to point to the actual procedure called.
 */
public class Pass1Procedures extends Pass2SsaOptimization {

   public Pass1Procedures(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               String procedureName = call.getProcedureName();
               if(procedureName.equals(Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4)) {
                  if(getScope().getGlobalSymbol(Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4) == null) {
                     // Add the intrinsic MAKEWORD4()
                     final Procedure makeword4 = new Procedure(
                           Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4,
                           new SymbolTypeProcedure(SymbolType.DWORD, Arrays.asList(new SymbolType[]{ SymbolType.BYTE, SymbolType.BYTE, SymbolType.BYTE, SymbolType.BYTE})),
                           getScope(),
                           Scope.SEGMENT_CODE_DEFAULT, Scope.SEGMENT_DATA_DEFAULT,
                           Procedure.CallingConvention.INTRINSIC_CALL);
                     makeword4.setDeclaredIntrinsic(true);
                     final Variable hihi = new Variable("hihi", Variable.Kind.PHI_MASTER, SymbolType.BYTE, makeword4, Variable.MemoryArea.ZEROPAGE_MEMORY, Scope.SEGMENT_DATA_DEFAULT, null);
                     makeword4.add(hihi);
                     final Variable hilo = new Variable("hilo", Variable.Kind.PHI_MASTER, SymbolType.BYTE, makeword4, Variable.MemoryArea.ZEROPAGE_MEMORY, Scope.SEGMENT_DATA_DEFAULT, null);
                     makeword4.add(hilo);
                     final Variable lohi = new Variable("lohi", Variable.Kind.PHI_MASTER, SymbolType.BYTE, makeword4, Variable.MemoryArea.ZEROPAGE_MEMORY, Scope.SEGMENT_DATA_DEFAULT, null);
                     makeword4.add(lohi);
                     final Variable lolo = new Variable("lolo", Variable.Kind.PHI_MASTER, SymbolType.BYTE, makeword4, Variable.MemoryArea.ZEROPAGE_MEMORY, Scope.SEGMENT_DATA_DEFAULT, null);
                     makeword4.add(lolo);
                     makeword4.setParameters(Arrays.asList(hihi, hilo, lohi, lolo));
                     getScope().add(makeword4);
                  }
               }

               Scope localScope = (Scope) getScope().getSymbol(block.getScope());
               final Symbol procedureSymbol = localScope.findSymbol(procedureName);
               if(procedureSymbol == null)
                  throw new CompileError("Called procedure not found. " + procedureName, statement.getSource());
               if(!(procedureSymbol instanceof Procedure))
                  throw new CompileError("Called symbol is not a procedure. " + procedureSymbol.toString(), statement.getSource());
               Procedure procedure = (Procedure) procedureSymbol;
               call.setProcedure(procedure.getRef());
               if(procedure.isVariableLengthParameterList() && procedure.getParameters().size() > call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + " or more. " + statement.toString(), statement.getSource());
               } else if(!procedure.isVariableLengthParameterList() && procedure.getParameters().size() != call.getParameters().size()) {
                  throw new CompileError("Wrong number of parameters in call. Expected " + procedure.getParameters().size() + ". " + statement.toString(), statement.getSource());
               }
            }
         }
      }
      return false;
   }

}
