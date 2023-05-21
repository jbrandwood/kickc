package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;
import java.util.ListIterator;

/**
 * Rewrite BYTE0() / BYTE1() / BYTE2() / BYTE3() calls to special unary operators.
 */
public class Pass1ByteXIntrinsicRewrite extends Pass2SsaOptimization {

   /** The byte0 procedure name. */
   public static final String INTRINSIC_BYTE0_NAME = "BYTE0";
   /** The byte1 procedure name. */
   public static final String INTRINSIC_BYTE1_NAME = "BYTE1";
   /** The byte2 procedure name. */
   public static final String INTRINSIC_BYTE2_NAME = "BYTE2";
   /** The byte3 procedure name. */
   public static final String INTRINSIC_BYTE3_NAME = "BYTE3";
   /** The word0 procedure name. */
   public static final String INTRINSIC_WORD0_NAME = "WORD0";
   /** The word1 procedure name. */
   public static final String INTRINSIC_WORD1_NAME = "WORD1";
   /** The makeword procedure name. */
   public static final String INTRINSIC_MAKEWORD = "MAKEWORD";
   /** The makelong procedure name. */
   public static final String INTRINSIC_MAKELONG = "MAKELONG";
   /** The makelong4 procedure name. */
   public static final String INTRINSIC_MAKELONG4 = "MAKELONG4";

   public Pass1ByteXIntrinsicRewrite(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(var block : getGraph().getAllBlocks()) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               final List<RValue> parameters = call.getParameters();
               if(INTRINSIC_BYTE0_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.BYTE0);
               } else if(INTRINSIC_BYTE1_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.BYTE1);
               } else if(INTRINSIC_BYTE2_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.BYTE2);
               } else if(INTRINSIC_BYTE3_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.BYTE3);
               } else if(INTRINSIC_WORD0_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.WORD0);
               } else if(INTRINSIC_WORD1_NAME.equals(call.getProcedureName())) {
                  generateUnaryOperator(stmtIt, call, parameters, Operators.WORD1);
               }
            }
         }
      }
      return false;
   }

   /**
    * Generate an unary operator expression for the BYTEX()/WORDX()
    */
   private void generateUnaryOperator(ListIterator<Statement> stmtIt, StatementCall call, List<RValue> parameters, OperatorUnary operator) {
      if(parameters.size()!=1) {
         throw new CompileError("Wrong number of parameters in call " + call.toString(getProgram(), false) + " expected " + 1, call);
      }
      // Remove the call
      stmtIt.remove();
      // Add the unary operator
      stmtIt.add(new StatementAssignment(call.getlValue(), operator, parameters.get(0), call.isInitialAssignment(), call.getSource(), call.getComments()));
   }


}
