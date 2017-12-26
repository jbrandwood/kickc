// Generated from /Users/jespergravgaard/c64/src/kickc/src/main/java/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
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
	 * Enter a parse tree produced by {@link KickCParser#asmFile}.
	 * @param ctx the parse tree
	 */
	void enterAsmFile(KickCParser.AsmFileContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#asmFile}.
	 * @param ctx the parse tree
	 */
	void exitAsmFile(KickCParser.AsmFileContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#importSeq}.
	 * @param ctx the parse tree
	 */
	void enterImportSeq(KickCParser.ImportSeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#importSeq}.
	 * @param ctx the parse tree
	 */
	void exitImportSeq(KickCParser.ImportSeqContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#importDecl}.
	 * @param ctx the parse tree
	 */
	void enterImportDecl(KickCParser.ImportDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#importDecl}.
	 * @param ctx the parse tree
	 */
	void exitImportDecl(KickCParser.ImportDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#declSeq}.
	 * @param ctx the parse tree
	 */
	void enterDeclSeq(KickCParser.DeclSeqContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#declSeq}.
	 * @param ctx the parse tree
	 */
	void exitDeclSeq(KickCParser.DeclSeqContext ctx);
	/**
	 * Enter a parse tree produced by the {@code declMethod}
	 * labeled alternative in {@link KickCParser#decl}.
	 * @param ctx the parse tree
	 */
	void enterDeclMethod(KickCParser.DeclMethodContext ctx);
	/**
	 * Exit a parse tree produced by the {@code declMethod}
	 * labeled alternative in {@link KickCParser#decl}.
	 * @param ctx the parse tree
	 */
	void exitDeclMethod(KickCParser.DeclMethodContext ctx);
	/**
	 * Enter a parse tree produced by the {@code declVariable}
	 * labeled alternative in {@link KickCParser#decl}.
	 * @param ctx the parse tree
	 */
	void enterDeclVariable(KickCParser.DeclVariableContext ctx);
	/**
	 * Exit a parse tree produced by the {@code declVariable}
	 * labeled alternative in {@link KickCParser#decl}.
	 * @param ctx the parse tree
	 */
	void exitDeclVariable(KickCParser.DeclVariableContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#parameterListDecl}.
	 * @param ctx the parse tree
	 */
	void enterParameterListDecl(KickCParser.ParameterListDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#parameterListDecl}.
	 * @param ctx the parse tree
	 */
	void exitParameterListDecl(KickCParser.ParameterListDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 */
	void enterParameterDecl(KickCParser.ParameterDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 */
	void exitParameterDecl(KickCParser.ParameterDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#declVar}.
	 * @param ctx the parse tree
	 */
	void enterDeclVar(KickCParser.DeclVarContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#declVar}.
	 * @param ctx the parse tree
	 */
	void exitDeclVar(KickCParser.DeclVarContext ctx);
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
	 * Enter a parse tree produced by the {@code stmtDeclVar}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtDeclVar(KickCParser.StmtDeclVarContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtDeclVar}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtDeclVar(KickCParser.StmtDeclVarContext ctx);
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
	 * Enter a parse tree produced by the {@code stmtDoWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtDoWhile(KickCParser.StmtDoWhileContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtDoWhile}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtDoWhile(KickCParser.StmtDoWhileContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtFor}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtFor(KickCParser.StmtForContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtFor}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtFor(KickCParser.StmtForContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtReturn}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtReturn(KickCParser.StmtReturnContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtReturn}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtReturn(KickCParser.StmtReturnContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtAsm}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtAsm(KickCParser.StmtAsmContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtAsm}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtAsm(KickCParser.StmtAsmContext ctx);
	/**
	 * Enter a parse tree produced by the {@code forDecl}
	 * labeled alternative in {@link KickCParser#forDeclaration}.
	 * @param ctx the parse tree
	 */
	void enterForDecl(KickCParser.ForDeclContext ctx);
	/**
	 * Exit a parse tree produced by the {@code forDecl}
	 * labeled alternative in {@link KickCParser#forDeclaration}.
	 * @param ctx the parse tree
	 */
	void exitForDecl(KickCParser.ForDeclContext ctx);
	/**
	 * Enter a parse tree produced by the {@code forClassic}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 */
	void enterForClassic(KickCParser.ForClassicContext ctx);
	/**
	 * Exit a parse tree produced by the {@code forClassic}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 */
	void exitForClassic(KickCParser.ForClassicContext ctx);
	/**
	 * Enter a parse tree produced by the {@code forRange}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 */
	void enterForRange(KickCParser.ForRangeContext ctx);
	/**
	 * Exit a parse tree produced by the {@code forRange}
	 * labeled alternative in {@link KickCParser#forIteration}.
	 * @param ctx the parse tree
	 */
	void exitForRange(KickCParser.ForRangeContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typePtr}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void enterTypePtr(KickCParser.TypePtrContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typePtr}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void exitTypePtr(KickCParser.TypePtrContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typeArray}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void enterTypeArray(KickCParser.TypeArrayContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typeArray}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void exitTypeArray(KickCParser.TypeArrayContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typeSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void enterTypeSimple(KickCParser.TypeSimpleContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typeSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void exitTypeSimple(KickCParser.TypeSimpleContext ctx);
	/**
	 * Enter a parse tree produced by the {@code typeSignedSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void enterTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx);
	/**
	 * Exit a parse tree produced by the {@code typeSignedSimple}
	 * labeled alternative in {@link KickCParser#typeDecl}.
	 * @param ctx the parse tree
	 */
	void exitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprPtr}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPtr(KickCParser.ExprPtrContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprPtr}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPtr(KickCParser.ExprPtrContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprPreMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPreMod(KickCParser.ExprPreModContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprPreMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPreMod(KickCParser.ExprPreModContext ctx);
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
	 * Enter a parse tree produced by the {@code exprPostMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprPostMod(KickCParser.ExprPostModContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprPostMod}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprPostMod(KickCParser.ExprPostModContext ctx);
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
	/**
	 * Enter a parse tree produced by the {@code exprChar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprChar(KickCParser.ExprCharContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprChar}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprChar(KickCParser.ExprCharContext ctx);
	/**
	 * Enter a parse tree produced by the {@code initList}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterInitList(KickCParser.InitListContext ctx);
	/**
	 * Exit a parse tree produced by the {@code initList}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitInitList(KickCParser.InitListContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprCast(KickCParser.ExprCastContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprCast}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprCast(KickCParser.ExprCastContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprCall}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprCall(KickCParser.ExprCallContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprCall}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprCall(KickCParser.ExprCallContext ctx);
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
	 * Enter a parse tree produced by the {@code exprAssignment}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprAssignment(KickCParser.ExprAssignmentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprAssignment}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprAssignment(KickCParser.ExprAssignmentContext ctx);
	/**
	 * Enter a parse tree produced by the {@code exprArray}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExprArray(KickCParser.ExprArrayContext ctx);
	/**
	 * Exit a parse tree produced by the {@code exprArray}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExprArray(KickCParser.ExprArrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#parameterList}.
	 * @param ctx the parse tree
	 */
	void enterParameterList(KickCParser.ParameterListContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#parameterList}.
	 * @param ctx the parse tree
	 */
	void exitParameterList(KickCParser.ParameterListContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#asmLines}.
	 * @param ctx the parse tree
	 */
	void enterAsmLines(KickCParser.AsmLinesContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#asmLines}.
	 * @param ctx the parse tree
	 */
	void exitAsmLines(KickCParser.AsmLinesContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#asmLine}.
	 * @param ctx the parse tree
	 */
	void enterAsmLine(KickCParser.AsmLineContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#asmLine}.
	 * @param ctx the parse tree
	 */
	void exitAsmLine(KickCParser.AsmLineContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#asmLabel}.
	 * @param ctx the parse tree
	 */
	void enterAsmLabel(KickCParser.AsmLabelContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#asmLabel}.
	 * @param ctx the parse tree
	 */
	void exitAsmLabel(KickCParser.AsmLabelContext ctx);
	/**
	 * Enter a parse tree produced by {@link KickCParser#asmInstruction}.
	 * @param ctx the parse tree
	 */
	void enterAsmInstruction(KickCParser.AsmInstructionContext ctx);
	/**
	 * Exit a parse tree produced by {@link KickCParser#asmInstruction}.
	 * @param ctx the parse tree
	 */
	void exitAsmInstruction(KickCParser.AsmInstructionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeAbs}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeAbs(KickCParser.AsmModeAbsContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeAbs}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeAbs(KickCParser.AsmModeAbsContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeImm}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeImm(KickCParser.AsmModeImmContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeImm}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeImm(KickCParser.AsmModeImmContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeAbsXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeAbsXY(KickCParser.AsmModeAbsXYContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeAbsXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeAbsXY(KickCParser.AsmModeAbsXYContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeIndIdxXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeIndIdxXY(KickCParser.AsmModeIndIdxXYContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeIndIdxXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeIndIdxXY(KickCParser.AsmModeIndIdxXYContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeIdxIndXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeIdxIndXY(KickCParser.AsmModeIdxIndXYContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeIdxIndXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeIdxIndXY(KickCParser.AsmModeIdxIndXYContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmModeInd}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void enterAsmModeInd(KickCParser.AsmModeIndContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmModeInd}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 */
	void exitAsmModeInd(KickCParser.AsmModeIndContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprReplace}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprReplace(KickCParser.AsmExprReplaceContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprReplace}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprReplace(KickCParser.AsmExprReplaceContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprLabelRel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprLabelRel(KickCParser.AsmExprLabelRelContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprLabelRel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprLabelRel(KickCParser.AsmExprLabelRelContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprBinary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprBinary(KickCParser.AsmExprBinaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprBinary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprBinary(KickCParser.AsmExprBinaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprLabel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprLabel(KickCParser.AsmExprLabelContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprLabel}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprLabel(KickCParser.AsmExprLabelContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprInt}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprInt(KickCParser.AsmExprIntContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprInt}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprInt(KickCParser.AsmExprIntContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprUnary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprUnary(KickCParser.AsmExprUnaryContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprUnary}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprUnary(KickCParser.AsmExprUnaryContext ctx);
	/**
	 * Enter a parse tree produced by the {@code asmExprChar}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void enterAsmExprChar(KickCParser.AsmExprCharContext ctx);
	/**
	 * Exit a parse tree produced by the {@code asmExprChar}
	 * labeled alternative in {@link KickCParser#asmExpr}.
	 * @param ctx the parse tree
	 */
	void exitAsmExprChar(KickCParser.AsmExprCharContext ctx);
}