// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/asm/parser/Asm6502.g4 by ANTLR 4.7
package dk.camelot64.kickc.asm.parser;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link Asm6502Parser}.
 */
public interface Asm6502Listener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link Asm6502Parser#file}.
	 * @param ctx the parse tree
	 */
	void enterFile(Asm6502Parser.FileContext ctx);
	/**
	 * Exit a parse tree produced by {@link Asm6502Parser#file}.
	 * @param ctx the parse tree
	 */
	void exitFile(Asm6502Parser.FileContext ctx);
	/**
	 * Enter a parse tree produced by {@link Asm6502Parser#line}.
	 * @param ctx the parse tree
	 */
	void enterLine(Asm6502Parser.LineContext ctx);
	/**
	 * Exit a parse tree produced by {@link Asm6502Parser#line}.
	 * @param ctx the parse tree
	 */
	void exitLine(Asm6502Parser.LineContext ctx);
	/**
	 * Enter a parse tree produced by {@link Asm6502Parser#label}.
	 * @param ctx the parse tree
	 */
	void enterLabel(Asm6502Parser.LabelContext ctx);
	/**
	 * Exit a parse tree produced by {@link Asm6502Parser#label}.
	 * @param ctx the parse tree
	 */
	void exitLabel(Asm6502Parser.LabelContext ctx);
	/**
	 * Enter a parse tree produced by {@link Asm6502Parser#comment}.
	 * @param ctx the parse tree
	 */
	void enterComment(Asm6502Parser.CommentContext ctx);
	/**
	 * Exit a parse tree produced by {@link Asm6502Parser#comment}.
	 * @param ctx the parse tree
	 */
	void exitComment(Asm6502Parser.CommentContext ctx);
	/**
	 * Enter a parse tree produced by {@link Asm6502Parser#instruction}.
	 * @param ctx the parse tree
	 */
	void enterInstruction(Asm6502Parser.InstructionContext ctx);
	/**
	 * Exit a parse tree produced by {@link Asm6502Parser#instruction}.
	 * @param ctx the parse tree
	 */
	void exitInstruction(Asm6502Parser.InstructionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeAbs}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeAbs(Asm6502Parser.ModeAbsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeAbs}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeAbs(Asm6502Parser.ModeAbsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeImm}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeImm(Asm6502Parser.ModeImmContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeImm}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeImm(Asm6502Parser.ModeImmContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeAbsX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeAbsX(Asm6502Parser.ModeAbsXContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeAbsX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeAbsX(Asm6502Parser.ModeAbsXContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeAbsY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeAbsY(Asm6502Parser.ModeAbsYContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeAbsY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeAbsY(Asm6502Parser.ModeAbsYContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeIndY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeIndY(Asm6502Parser.ModeIndYContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeIndY}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeIndY(Asm6502Parser.ModeIndYContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeIndX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeIndX(Asm6502Parser.ModeIndXContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeIndX}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeIndX(Asm6502Parser.ModeIndXContext ctx);
	/**
	 * Enter a parse tree produced by the {@code modeInd}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void enterModeInd(Asm6502Parser.ModeIndContext ctx);
	/**
	 * Exit a parse tree produced by the {@code modeInd}
	 * labeled alternative in {@link Asm6502Parser#paramMode}.
	 * @param ctx the parse tree
	 */
	void exitModeInd(Asm6502Parser.ModeIndContext ctx);
	/**
	 * Enter a parse tree produced by the {@code paramLabel}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void enterParamLabel(Asm6502Parser.ParamLabelContext ctx);
	/**
	 * Exit a parse tree produced by the {@code paramLabel}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void exitParamLabel(Asm6502Parser.ParamLabelContext ctx);
	/**
	 * Enter a parse tree produced by the {@code paramReplace}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void enterParamReplace(Asm6502Parser.ParamReplaceContext ctx);
	/**
	 * Exit a parse tree produced by the {@code paramReplace}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void exitParamReplace(Asm6502Parser.ParamReplaceContext ctx);
	/**
	 * Enter a parse tree produced by the {@code paramInt}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void enterParamInt(Asm6502Parser.ParamIntContext ctx);
	/**
	 * Exit a parse tree produced by the {@code paramInt}
	 * labeled alternative in {@link Asm6502Parser#param}.
	 * @param ctx the parse tree
	 */
	void exitParamInt(Asm6502Parser.ParamIntContext ctx);
}