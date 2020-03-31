// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/macros/Macros.g4 by ANTLR 4.7.2
package dk.camelot64.kickc.parsing.macros;


import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link MacrosParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface MacrosVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link MacrosParser#stmtSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtSeq(MacrosParser.StmtSeqContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link MacrosParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtExpr(MacrosParser.StmtExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprCast(MacrosParser.ExprCastContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBinary(MacrosParser.ExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPar(MacrosParser.ExprParContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprNumber(MacrosParser.ExprNumberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprName}
	 * labeled alternative in {@link MacrosParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprName(MacrosParser.ExprNameContext ctx);
}