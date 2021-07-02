package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantBinary;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

/**
 * Compiler Pass propagating identifying (intrinsic) calls that return a constant value
 */
public class Pass2ConstantIntrinsics extends Pass2SsaOptimization {

   public Pass2ConstantIntrinsics(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               final StatementCall call = (StatementCall) statement;
               final Procedure procedure = getScope().getProcedure(call.getProcedure());
               if(procedure.isDeclaredIntrinsic()) {
                  if(procedure.getFullName().equals(Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4)) {
                     List<ConstantValue> constParams = new ArrayList<>();
                     for(RValue parameter : call.getParameters()) {
                        final ConstantValue constParam = Pass2ConstantIdentification.getConstant(parameter);
                        if(constParam == null) break;
                        constParams.add(constParam);
                     }
                     if(constParams.size() == 4) {
                        // All parameters are constant - dword is constant
                        final ConstantBinary constValue = new ConstantBinary(
                              new ConstantBinary(constParams.get(0), Operators.MULTIPLY, new ConstantInteger(0x1000000l, SymbolType.DWORD)),
                              Operators.PLUS,
                              new ConstantBinary(
                                    new ConstantBinary(constParams.get(1), Operators.MULTIPLY, new ConstantInteger(0x10000l, SymbolType.DWORD)),
                                    Operators.PLUS,
                                    new ConstantBinary(
                                          new ConstantBinary(constParams.get(2), Operators.MULTIPLY, new ConstantInteger(0x100l, SymbolType.DWORD)),
                                          Operators.PLUS,
                                          constParams.get(3)
                                    )
                              )
                        );
                        // Remove the intrinsic call
                        stmtIt.remove();
                        // Add the constant assignment
                        stmtIt.add(new StatementAssignment(call.getlValue(), constValue, call.isInitialAssignment(), call.getSource(), call.getComments()));
                        getLog().append("Identified constant dword "+call.toString(getProgram(), false));
                     }
                  }
               }
            }

         }
      }
      return false;
   }
}
