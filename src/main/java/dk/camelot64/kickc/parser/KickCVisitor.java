// Generated from C:/c64/kickc/src/main/java/dk/camelot64/kickc/parser\KickC.g4 by ANTLR 4.7
package dk.camelot64.kickc.parser;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link KickCParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface KickCVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link KickCParser#file}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFile(KickCParser.FileContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmFile}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmFile(KickCParser.AsmFileContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#importSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImportSeq(KickCParser.ImportSeqContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#importDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitImportDecl(KickCParser.ImportDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclSeq(KickCParser.DeclSeqContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#decl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecl(KickCParser.DeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declVariable}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclVariable(KickCParser.DeclVariableContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declFunction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclFunction(KickCParser.DeclFunctionContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#parameterListDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterListDecl(KickCParser.ParameterListDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterDecl(KickCParser.ParameterDeclContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveConst}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveConst(KickCParser.DirectiveConstContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveExtern}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveExtern(KickCParser.DirectiveExternContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveAlign}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveAlign(KickCParser.DirectiveAlignContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveRegister}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveRegister(KickCParser.DirectiveRegisterContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveInline}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveInline(KickCParser.DirectiveInlineContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveVolatile}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveVolatile(KickCParser.DirectiveVolatileContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveInterrupt}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveInterrupt(KickCParser.DirectiveInterruptContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#stmtSeq}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtSeq(KickCParser.StmtSeqContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtDeclVar}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtDeclVar(KickCParser.StmtDeclVarContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtBlock}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtBlock(KickCParser.StmtBlockContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtExpr}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtExpr(KickCParser.StmtExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtIfElse}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtIfElse(KickCParser.StmtIfElseContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtWhile(KickCParser.StmtWhileContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtDoWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtDoWhile(KickCParser.StmtDoWhileContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtFor}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtFor(KickCParser.StmtForContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtReturn}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtReturn(KickCParser.StmtReturnContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtBreak}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtBreak(KickCParser.StmtBreakContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtContinue}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtContinue(KickCParser.StmtContinueContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtAsm}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtAsm(KickCParser.StmtAsmContext ctx);
	/**
	 * Visit a parse tree produced by the {@code stmtDeclKasm}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtDeclKasm(KickCParser.StmtDeclKasmContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forDecl}
	 * labeled alternative in {@link KickCParser#forDeclaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForDecl(KickCParser.ForDeclContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forClassic}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForClassic(KickCParser.ForClassicContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forRange}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForRange(KickCParser.ForRangeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typePar}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypePar(KickCParser.TypeParContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeProcedure}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeProcedure(KickCParser.TypeProcedureContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typePtr}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypePtr(KickCParser.TypePtrContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeArray}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeArray(KickCParser.TypeArrayContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSimple(KickCParser.TypeSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSignedSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprPtr}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPtr(KickCParser.ExprPtrContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprPreMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPreMod(KickCParser.ExprPreModContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprBinary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBinary(KickCParser.ExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprPostMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPostMod(KickCParser.ExprPostModContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprUnary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprUnary(KickCParser.ExprUnaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprNumber}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprNumber(KickCParser.ExprNumberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprChar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprChar(KickCParser.ExprCharContext ctx);
	/**
	 * Visit a parse tree produced by the {@code initList}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInitList(KickCParser.InitListContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprCast(KickCParser.ExprCastContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprCall}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprCall(KickCParser.ExprCallContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprPar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprPar(KickCParser.ExprParContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprString}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprString(KickCParser.ExprStringContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprAssignmentCompound}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprAssignmentCompound(KickCParser.ExprAssignmentCompoundContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprBool}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprBool(KickCParser.ExprBoolContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprId}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprId(KickCParser.ExprIdContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprAssignment}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprAssignment(KickCParser.ExprAssignmentContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprArray}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprArray(KickCParser.ExprArrayContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#parameterList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterList(KickCParser.ParameterListContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declKasm}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclKasm(KickCParser.DeclKasmContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmDirectives}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectives(KickCParser.AsmDirectivesContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveResource}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveResource(KickCParser.AsmDirectiveResourceContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveUses}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveUses(KickCParser.AsmDirectiveUsesContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveClobber}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveClobber(KickCParser.AsmDirectiveClobberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveBytes}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveBytes(KickCParser.AsmDirectiveBytesContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveCycles}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveCycles(KickCParser.AsmDirectiveCyclesContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmDirectiveAddress}
	 * labeled alternative in {@link KickCParser#asmDirective}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmDirectiveAddress(KickCParser.AsmDirectiveAddressContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmLines}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmLines(KickCParser.AsmLinesContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmLine}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmLine(KickCParser.AsmLineContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmLabelName}
	 * labeled alternative in {@link KickCParser#asmLabel}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmLabelName(KickCParser.AsmLabelNameContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmLabelMulti}
	 * labeled alternative in {@link KickCParser#asmLabel}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmLabelMulti(KickCParser.AsmLabelMultiContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmInstruction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmInstruction(KickCParser.AsmInstructionContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#asmBytes}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmBytes(KickCParser.AsmBytesContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeAbs}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeAbs(KickCParser.AsmModeAbsContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeImm}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeImm(KickCParser.AsmModeImmContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeAbsXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeAbsXY(KickCParser.AsmModeAbsXYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeIndIdxXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeIndIdxXY(KickCParser.AsmModeIndIdxXYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeIdxIndXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeIdxIndXY(KickCParser.AsmModeIdxIndXYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeInd}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeInd(KickCParser.AsmModeIndContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprReplace}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprReplace(KickCParser.AsmExprReplaceContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprLabelRel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprLabelRel(KickCParser.AsmExprLabelRelContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprPar}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprPar(KickCParser.AsmExprParContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprBinary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprBinary(KickCParser.AsmExprBinaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprLabel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprLabel(KickCParser.AsmExprLabelContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprInt}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprInt(KickCParser.AsmExprIntContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprUnary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprUnary(KickCParser.AsmExprUnaryContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmExprChar}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmExprChar(KickCParser.AsmExprCharContext ctx);
}