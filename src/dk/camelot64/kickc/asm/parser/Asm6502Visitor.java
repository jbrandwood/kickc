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
	 * Visit a parse tree produced by {@link Asm6502Parser#lineSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLineSeq(Asm6502Parser.LineSeqContext ctx);
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
	 * Visit a parse tree produced by the {@code paramLabel}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParamLabel(Asm6502Parser.ParamLabelContext ctx);
	/**
	 * Visit a parse tree produced by the {@code paramReplace}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParamReplace(Asm6502Parser.ParamReplaceContext ctx);
	/**
	 * Visit a parse tree produced by the {@code paramInt}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParamInt(Asm6502Parser.ParamIntContext ctx);
}