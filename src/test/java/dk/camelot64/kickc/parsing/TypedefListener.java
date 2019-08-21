// Generated from /Users/jespergravgaard/c64/kickc/src/test/java/dk/camelot64/kickc/parsing/Typedef.g4 by ANTLR 4.7
package dk.camelot64.kickc.parsing;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link TypedefParser}.
 */
public interface TypedefListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by the {@code exprValueName}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprValueName(TypedefParser.ExprValueNameContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprValueName}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprValueName(TypedefParser.ExprValueNameContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprCast(TypedefParser.ExprCastContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprCast(TypedefParser.ExprCastContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprAnd}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprAnd(TypedefParser.ExprAndContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprAnd}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprAnd(TypedefParser.ExprAndContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprAddressOf}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprAddressOf(TypedefParser.ExprAddressOfContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprAddressOf}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprAddressOf(TypedefParser.ExprAddressOfContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprParenthesis}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprParenthesis(TypedefParser.ExprParenthesisContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprParenthesis}
	 * labeled alternative in {@link TypedefParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprParenthesis(TypedefParser.ExprParenthesisContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typeNameSimple}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 */
	void enterTypeNameSimple(TypedefParser.TypeNameSimpleContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typeNameSimple}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 */
	void exitTypeNameSimple(TypedefParser.TypeNameSimpleContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typeNameTypedef}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 */
	void enterTypeNameTypedef(TypedefParser.TypeNameTypedefContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typeNameTypedef}
	 * labeled alternative in {@link TypedefParser#typeName}.
	 * @param ctx the parse tree
	 */
	void exitTypeNameTypedef(TypedefParser.TypeNameTypedefContext ctx);
	/**
	 * Enter a parse tree produced by {@link TypedefParser#typedefName}.
	 * @param ctx the parse tree
	 */
	void enterTypedefName(TypedefParser.TypedefNameContext ctx);
	/**
	 * Exit a parse tree produced by {@link TypedefParser#typedefName}.
	 * @param ctx the parse tree
	 */
	void exitTypedefName(TypedefParser.TypedefNameContext ctx);
	/**
	 * Enter a parse tree produced by {@link TypedefParser#valueName}.
	 * @param ctx the parse tree
	 */
	void enterValueName(TypedefParser.ValueNameContext ctx);
	/**
	 * Exit a parse tree produced by {@link TypedefParser#valueName}.
	 * @param ctx the parse tree
	 */
	void exitValueName(TypedefParser.ValueNameContext ctx);
}