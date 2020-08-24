// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/typedef/Typedef.g4 by ANTLR 4.8
package dk.camelot64.kickc.parsing.typedef;

    import java.util.ArrayList;
    import java.util.List;

import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link TypedefParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface TypedefVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link TypedefParser#stmtSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtSeq(TypedefParser.StmtSeqContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtTypeDef}
	 * labeled alternative in {@link TypedefParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtTypeDef(TypedefParser.StmtTypeDefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link TypedefParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtExpr(TypedefParser.StmtExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprValueName}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprValueName(TypedefParser.ExprValueNameContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprCast(TypedefParser.ExprCastContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprAnd}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprAnd(TypedefParser.ExprAndContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprAddressOf}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprAddressOf(TypedefParser.ExprAddressOfContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprParenthesis}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprParenthesis(TypedefParser.ExprParenthesisContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeNameSimple}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeNameSimple(TypedefParser.TypeNameSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeNameTypedef}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeNameTypedef(TypedefParser.TypeNameTypedefContext ctx);
}