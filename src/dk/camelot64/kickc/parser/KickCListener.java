// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
package dk.camelot64.kickc.parser;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link KickCParser}.
 */
public interface KickCListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(KickCParser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(KickCParser.ExprContext ctx);
}