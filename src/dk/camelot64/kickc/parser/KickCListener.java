// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
package dk.camelot64.kickc.parser;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link KickCParser}.
 */
public interface KickCListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link KickCParser#file}.
	 * @param ctx the parse tree
	 */
	void enterFile(KickCParser.FileContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#file}.
	 * @param ctx the parse tree
	 */
	void exitFile(KickCParser.FileContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#stmtSeq}.
	 * @param ctx the parse tree
	 */
	void enterStmtSeq(KickCParser.StmtSeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#stmtSeq}.
	 * @param ctx the parse tree
	 */
	void exitStmtSeq(KickCParser.StmtSeqContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtBlock}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtBlock(KickCParser.StmtBlockContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtBlock}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtBlock(KickCParser.StmtBlockContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtAssignment}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtAssignment(KickCParser.StmtAssignmentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtAssignment}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtAssignment(KickCParser.StmtAssignmentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtExpr(KickCParser.StmtExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtExpr(KickCParser.StmtExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtIfElse}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtIfElse(KickCParser.StmtIfElseContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtIfElse}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtIfElse(KickCParser.StmtIfElseContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtWhile(KickCParser.StmtWhileContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtWhile(KickCParser.StmtWhileContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprBinary(KickCParser.ExprBinaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprBinary(KickCParser.ExprBinaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPar(KickCParser.ExprParContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPar(KickCParser.ExprParContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprString}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprString(KickCParser.ExprStringContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprString}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprString(KickCParser.ExprStringContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprBool}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprBool(KickCParser.ExprBoolContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprBool}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprBool(KickCParser.ExprBoolContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprId}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprId(KickCParser.ExprIdContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprId}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprId(KickCParser.ExprIdContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprUnary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprUnary(KickCParser.ExprUnaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprUnary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprUnary(KickCParser.ExprUnaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprNumber(KickCParser.ExprNumberContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprNumber(KickCParser.ExprNumberContext ctx);
}