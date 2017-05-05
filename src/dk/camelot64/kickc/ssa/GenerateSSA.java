package dk.camelot64.kickc.ssa;

import dk.camelot64.kickc.parser.KickCBaseVisitor;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.tree.TerminalNode;

/** Generates program SSA form by visiting the ANTLR4 parse tree*/
public class GenerateSSA extends KickCBaseVisitor<SSAFragment> {

   SSAVariableManager variableManager;

   public GenerateSSA(SSAVariableManager variableManager) {
      this.variableManager = variableManager;
   }

   @Override
   public SSAFragment visitExprNumber(KickCParser.ExprNumberContext ctx) {
      Number number = KickCNumberParser.parseLiteral(ctx.getText());
      if(number instanceof Integer)  {
         return new SSAConstantInteger((Integer) number);
      } else {
         return new SSAConstantDouble((Double) number);
      }
   }

   @Override
   public SSAFragment visitExprString(KickCParser.ExprStringContext ctx) {
      return new SSAConstantString(ctx.getText());
   }

   @Override
   public SSAFragment visitExprBool(KickCParser.ExprBoolContext ctx) {
      String bool = ctx.getText();
      return new SSAConstantBool(new Boolean(bool));
   }


   @Override
   public SSAFragment visitExprBinary(KickCParser.ExprBinaryContext ctx) {
      SSAFragment left = this.visit(ctx.expr(0));
      SSAFragment right = this.visit(ctx.expr(1));
      String op = ((TerminalNode)ctx.getChild(1)).getSymbol().getText();
      SSAOperator operator = new SSAOperator(op);
      SSAVariable tmpVar = variableManager.generateIntermediateVariable();
      SSAStatement stmt = new SSAStatement(tmpVar, getSSARValue(left), operator, getSSARValue(right));
      System.out.println(stmt);
      return stmt;
   }

   @Override
   public SSAFragment visitExprUnary(KickCParser.ExprUnaryContext ctx) {
      SSAFragment child = this.visit(ctx.expr());
      String op = ((TerminalNode)ctx.getChild(0)).getSymbol().getText();
      SSAOperator operator = new SSAOperator(op);
      SSAVariable tmpVar = variableManager.generateIntermediateVariable();
      SSAStatement stmt = new SSAStatement(tmpVar, operator, getSSARValue(child));
      System.out.println(stmt);
      return stmt;
   }

   @Override
   public SSAFragment visitExprPar(KickCParser.ExprParContext ctx) {
      return this.visit(ctx.expr());
   }

   SSARValue getSSARValue(SSAFragment ssaFragment) {
      if(ssaFragment instanceof SSARValue) {
         return (SSARValue) ssaFragment;
      } if(ssaFragment instanceof SSAStatement) {
         SSAStatement ssaStatement = (SSAStatement) ssaFragment;
         return (SSARValue) ssaStatement.getlValue();
      }
      throw new RuntimeException("Cannot extract SSA RValue");
   }


}
