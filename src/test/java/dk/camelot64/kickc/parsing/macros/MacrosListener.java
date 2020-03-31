// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/macros/Macros.g4 by ANTLR 4.7.2
package dk.camelot64.kickc.parsing.macros;


import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link MacrosParser}.
 */
public interface MacrosListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link MacrosParser#stmtSeq}.
	 * @param ctx the parse tree
	 */
	void enterStmtSeq(MacrosParser.StmtSeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link MacrosParser#stmtSeq}.
	 * @param ctx the parse tree
	 */
	void exitStmtSeq(MacrosParser.StmtSeqContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link MacrosParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtExpr(MacrosParser.StmtExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link MacrosParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtExpr(MacrosParser.StmtExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprCast(MacrosParser.ExprCastContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprCast(MacrosParser.ExprCastContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprBinary(MacrosParser.ExprBinaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprBinary(MacrosParser.ExprBinaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPar(MacrosParser.ExprParContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPar(MacrosParser.ExprParContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprNumber(MacrosParser.ExprNumberContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprNumber(MacrosParser.ExprNumberContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprName}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprName(MacrosParser.ExprNameContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprName}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprName(MacrosParser.ExprNameContext ctx);
}