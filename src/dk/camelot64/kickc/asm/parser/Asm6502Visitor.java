// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/asm/parser/Asm6502.g4 by ANTLR 4.7
package dk.camelot64.kickc.asm.parser;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link Asm6502Parser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface Asm6502Visitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link Asm6502Parser#file}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFile(Asm6502Parser.FileContext ctx);
	/**
	 * Visit a parse tree produced by {@link Asm6502Parser#line}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLine(Asm6502Parser.LineContext ctx);
	/**
	 * Visit a parse tree produced by {@link Asm6502Parser#label}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLabel(Asm6502Parser.LabelContext ctx);
	/**
	 * Visit a parse tree produced by {@link Asm6502Parser#comment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComment(Asm6502Parser.CommentContext ctx);
	/**
	 * Visit a parse tree produced by {@link Asm6502Parser#instruction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInstruction(Asm6502Parser.InstructionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeAbs}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeAbs(Asm6502Parser.ModeAbsContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeImm}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeImm(Asm6502Parser.ModeImmContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeAbsX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeAbsX(Asm6502Parser.ModeAbsXContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeAbsY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeAbsY(Asm6502Parser.ModeAbsYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeIndY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeIndY(Asm6502Parser.ModeIndYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeIndX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeIndX(Asm6502Parser.ModeIndXContext ctx);
	/**
	 * Visit a parse tree produced by the {@code modeInd}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitModeInd(Asm6502Parser.ModeIndContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprInt}
	 * labeled alternative in {@link Asm6502Parser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprInt(Asm6502Parser.ExprIntContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprLabel}
	 * labeled alternative in {@link Asm6502Parser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprLabel(Asm6502Parser.ExprLabelContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link Asm6502Parser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBinary(Asm6502Parser.ExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprUnary}
	 * labeled alternative in {@link Asm6502Parser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprUnary(Asm6502Parser.ExprUnaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprReplace}
	 * labeled alternative in {@link Asm6502Parser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprReplace(Asm6502Parser.ExprReplaceContext ctx);
}