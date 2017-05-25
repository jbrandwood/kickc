package dk.camelot64.kickc.icl;

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
      throw new RuntimeException("Not implemented!");
   }

   @Override
   public Constant visitExprArray(KickCParser.ExprArrayContext ctx) {
      throw new RuntimeException("Not implemented!");
   }

   @Override
   public Constant visitExprId(KickCParser.ExprIdContext ctx) {
      throw new RuntimeException("Not implemented!");
   }

   @Override
   public Constant visitInitExpr(KickCParser.InitExprContext ctx) {
      return visit(ctx.expr());
   }

   @Override
   public Constant visitInitList(KickCParser.InitListContext ctx) {
      throw new RuntimeException("Not implemented!");
   }

   @Override
   public Constant visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      Constant sub = visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      Operator operator = new Operator(op);
      return Pass2ConstantPropagation.calculateUnary(operator, sub);
   }

   @Override
   public Constant visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      Constant left = this.visit(ctx.expr(0));
      Constant right = this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      Operator operator = new Operator(op);
      return Pass2ConstantPropagation.calculateBinary(operator, left, right);
   }
}
