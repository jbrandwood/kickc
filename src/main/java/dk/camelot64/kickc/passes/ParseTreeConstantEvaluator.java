package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.NumberParser;
import dk.camelot64.kickc.icl.*;
import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Capable of evaluating constants directly on the parse tree. */
public class ParseTreeConstantEvaluator extends KickCBaseVisitor<Constant> {

   /**
    * Attempt to evaluate a constant expression.
    *
    * @param expr The expression to evaluate
    * @return The constant value of the expression. null if the expression is not constant.
    */
   public static Constant evaluate(KickCParser.ExprContext expr) {
      return (new ParseTreeConstantEvaluator()).visit(expr);
   }

   @Override
   public Constant visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = NumberParser.parseLiteral(ctx.getText());
      if(number instanceof Integer)  {
         return new ConstantInteger((Integer) number);
      } else {
         return new ConstantDouble((Double) number);
      }
   }

   @Override
   public Constant visitExprString(KickCParser.ExprStringContext ctx) {
      return new ConstantString(ctx.getText());
   }

   @Override
   public Constant visitExprBool(KickCParser.ExprBoolContext ctx) {
      return new ConstantBool(Boolean.getBoolean(ctx.getText()));
   }

   @Override
   public Constant visitExprPar(KickCParser.ExprParContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public Constant visitExprCast(KickCParser.ExprCastContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public Constant visitExprCall(KickCParser.ExprCallContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public Constant visitExprArray(KickCParser.ExprArrayContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public Constant visitExprId(KickCParser.ExprIdContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public Constant visitInitExpr(KickCParser.InitExprContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public Constant visitInitList(KickCParser.InitListContext ctx) {
      throw new NotConstantException();
   }

   @Override
   public Constant visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      Constant sub = visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      Operator operator = Operator.getUnary(op);
      return calculateUnary(operator, sub);
   }

   @Override
   public Constant visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      Constant left = this.visit(ctx.expr(0));
      Constant right = this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      Operator operator = Operator.getBinary(op);
      return calculateBinary(operator, left, right);
   }

   /** Thrown if the expression is not a constant. */
   public static class NotConstantException extends RuntimeException {
      public NotConstantException() {
      }
   }

   static Constant calculateBinary(Operator operator, Constant c1, Constant c2) {
      switch (operator.getOperator()) {
         case "-": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) - getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) - getDouble(c2));
            }
         }
         case "+": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) + getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) + getDouble(c2));
            }
         }
         case "*": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) * getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) * getDouble(c2));
            }
         }
         case "/": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
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

   private static Integer getInteger(Constant constant) {
      if (constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getNumber();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not an integer number " + constant);
      }
   }

   private static Double getDouble(Constant constant) {
      if (constant instanceof ConstantDouble) {
         return ((ConstantDouble) constant).getNumber();
      } else if (constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getNumber().doubleValue();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not a number " + constant);
      }
   }

   public static Constant calculateUnary(Operator operator, Constant c) {
      switch (operator.getOperator()) {
         case "-": {
            if (c instanceof ConstantInteger) {
               ConstantInteger cInt = (ConstantInteger) c;
               return new ConstantInteger(-cInt.getNumber());
            } else if (c instanceof ConstantDouble) {
               ConstantDouble cDoub = (ConstantDouble) c;
               return new ConstantDouble(-cDoub.getNumber());
            } else {
               throw new RuntimeException("Type mismatch. Unary Minus cannot handle value " + c);
            }
         }
         case "+": {
            return c;
         }
         case "++": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getNumber()+1);
         }
         case "--": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getNumber()-1);
         }
         case "*": { // pointer dereference
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

}
