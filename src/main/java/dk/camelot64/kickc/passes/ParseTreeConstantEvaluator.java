package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Capable of evaluating constants directly on the parse tree. */
public class ParseTreeConstantEvaluator extends KickCBaseVisitor<ConstantValue> {

   /**
    * Attempt to evaluate a constant expression.
    *
    * @param expr The expression to evaluate
    * @return The constant value of the expression. null if the expression is not constant.
    */
   public static ConstantValue evaluate(KickCParser.ExprContext expr) {
      return (new ParseTreeConstantEvaluator()).visit(expr);
   }

   static ConstantValue calculateBinary(Operator operator, ConstantValue c1, ConstantValue c2) {
      switch(operator.getOperator()) {
         case "-": {
            if(c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) - getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) - getDouble(c2));
            }
         }
         case "+": {
            if(c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) + getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) + getDouble(c2));
            }
         }
         case "*": {
            if(c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) * getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) * getDouble(c2));
            }
         }
         case "/": {
            if(c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) / getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) / getDouble(c2));
            }
         }
         case "*idx": {
            // Cannot be directly propagated
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Binary Operator " + operator.getOperator());
      }
   }

   private static Long getInteger(ConstantValue constant) {
      if(constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getValue();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not an integer number " + constant);
      }
   }

   private static Double getDouble(ConstantValue constant) {
      if(constant instanceof ConstantDouble) {
         return ((ConstantDouble) constant).getValue();
      } else if(constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getValue().doubleValue();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not a number " + constant);
      }
   }

   public static ConstantValue calculateUnary(Operator operator, ConstantValue c) {
      switch(operator.getOperator()) {
         case "-": {
            if(c instanceof ConstantInteger) {
               ConstantInteger cInt = (ConstantInteger) c;
               return new ConstantInteger(-cInt.getValue());
            } else if(c instanceof ConstantDouble) {
               ConstantDouble cDoub = (ConstantDouble) c;
               return new ConstantDouble(-cDoub.getValue());
            } else {
               throw new RuntimeException("Type mismatch. Unary Minus cannot handle value " + c);
            }
         }
         case "+": {
            return c;
         }
         case "++": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getValue() + 1);
         }
         case "--": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getValue() - 1);
         }
         case "*": { // pointer dereference
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

   @Override
   public ConstantValue visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if(number instanceof Long) {
         return new ConstantInteger((Long) number);
      } else if(number instanceof Integer) {
         return new ConstantInteger(number.longValue());
      } else {
         return new ConstantDouble((Double) number);
      }
   }

   @Override
   public ConstantValue visitExprString(KickCParser.ExprStringContext ctx) {
      return new ConstantString(ctx.getText());
   }

   @Override
   public ConstantValue visitExprBool(KickCParser.ExprBoolContext ctx) {
      return new ConstantBool(Boolean.getBoolean(ctx.getText()));
   }

   @Override
   public ConstantValue visitExprPar(KickCParser.ExprParContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public ConstantValue visitExprCast(KickCParser.ExprCastContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public ConstantValue visitExprCall(KickCParser.ExprCallContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public ConstantValue visitExprArray(KickCParser.ExprArrayContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public ConstantValue visitExprId(KickCParser.ExprIdContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public ConstantValue visitInitList(KickCParser.InitListContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public ConstantValue visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      ConstantValue sub = visit(ctx.expr());
      String op = ((TerminalNode) ctx.getChild(0)).getSymbol().getText();
      Operator operator = Operators.getUnary(op);
      return calculateUnary(operator, sub);
   }

   @Override
   public ConstantValue visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      ConstantValue left = this.visit(ctx.expr(0));
      ConstantValue right = this.visit(ctx.expr(1));
      String op = ((TerminalNode) ctx.getChild(1)).getSymbol().getText();
      Operator operator = Operators.getBinary(op);
      return calculateBinary(operator, left, right);
   }

   /** Thrown if the expression is not a constant. */
   public static class NotConstantException extends RuntimeException {
      public NotConstantException() {
      }
   }

}
