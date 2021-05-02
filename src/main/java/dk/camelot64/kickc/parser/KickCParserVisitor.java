// Generated from /Users/jespergravgaard/c64/kickc/src/main/java/dk/camelot64/kickc/parser/KickCParser.g4 by ANTLR 4.9
package dk.camelot64.kickc.parser;


import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link KickCParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface KickCParserVisitor<T> extends ParseTreeVisitor<T> {
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
	 * Visit a parse tree produced by {@link KickCParser#declVariables}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclVariables(KickCParser.DeclVariablesContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declaratorInitList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclaratorInitList(KickCParser.DeclaratorInitListContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declVariableInitExpr}
	 * labeled alternative in {@link KickCParser#declaratorInit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclVariableInitExpr(KickCParser.DeclVariableInitExprContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declVariableInitKasm}
	 * labeled alternative in {@link KickCParser#declaratorInit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclVariableInitKasm(KickCParser.DeclVariableInitKasmContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#typeDef}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeDef(KickCParser.TypeDefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declType}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclType(KickCParser.DeclTypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declPointer}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclPointer(KickCParser.DeclPointerContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declArray}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclArray(KickCParser.DeclArrayContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSpecifierSimple}
	 * labeled alternative in {@link KickCParser#typeSpecifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSpecifierSimple(KickCParser.TypeSpecifierSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSpecifierPointer}
	 * labeled alternative in {@link KickCParser#typeSpecifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSpecifierPointer(KickCParser.TypeSpecifierPointerContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSpecifierArray}
	 * labeled alternative in {@link KickCParser#typeSpecifier}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSpecifierArray(KickCParser.TypeSpecifierArrayContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declaratorPointer}
	 * labeled alternative in {@link KickCParser#declarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclaratorPointer(KickCParser.DeclaratorPointerContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declaratorArray}
	 * labeled alternative in {@link KickCParser#declarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclaratorArray(KickCParser.DeclaratorArrayContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declaratorPar}
	 * labeled alternative in {@link KickCParser#declarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclaratorPar(KickCParser.DeclaratorParContext ctx);
	/**
	 * Visit a parse tree produced by the {@code declaratorName}
	 * labeled alternative in {@link KickCParser#declarator}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclaratorName(KickCParser.DeclaratorNameContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeProcedure}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeProcedure(KickCParser.TypeProcedureContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeStructRef}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeStructRef(KickCParser.TypeStructRefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSimple}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSimple(KickCParser.TypeSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeStructDef}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeStructDef(KickCParser.TypeStructDefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeNamedRef}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeNamedRef(KickCParser.TypeNamedRefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeSignedSimple}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeSignedSimple(KickCParser.TypeSignedSimpleContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeEnumRef}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeEnumRef(KickCParser.TypeEnumRefContext ctx);
	/**
	 * Visit a parse tree produced by the {@code typeEnumDef}
	 * labeled alternative in {@link KickCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTypeEnumDef(KickCParser.TypeEnumDefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#structRef}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStructRef(KickCParser.StructRefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#structDef}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStructDef(KickCParser.StructDefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#structMembers}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStructMembers(KickCParser.StructMembersContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#enumRef}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnumRef(KickCParser.EnumRefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#enumDef}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnumDef(KickCParser.EnumDefContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#enumMemberList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnumMemberList(KickCParser.EnumMemberListContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#enumMember}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitEnumMember(KickCParser.EnumMemberContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declFunction}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclFunction(KickCParser.DeclFunctionContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#declFunctionBody}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDeclFunctionBody(KickCParser.DeclFunctionBodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#parameterListDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterListDecl(KickCParser.ParameterListDeclContext ctx);
	/**
	 * Visit a parse tree produced by the {@code parameterDeclType}
	 * labeled alternative in {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterDeclType(KickCParser.ParameterDeclTypeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code parameterDeclVoid}
	 * labeled alternative in {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterDeclVoid(KickCParser.ParameterDeclVoidContext ctx);
	/**
	 * Visit a parse tree produced by the {@code parameterDeclList}
	 * labeled alternative in {@link KickCParser#parameterDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameterDeclList(KickCParser.ParameterDeclListContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#pragma}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragma(KickCParser.PragmaContext ctx);
	/**
	 * Visit a parse tree produced by the {@code pragmaParamNumber}
	 * labeled alternative in {@link KickCParser#pragmaParam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragmaParamNumber(KickCParser.PragmaParamNumberContext ctx);
	/**
	 * Visit a parse tree produced by the {@code pragmaParamRange}
	 * labeled alternative in {@link KickCParser#pragmaParam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragmaParamRange(KickCParser.PragmaParamRangeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code pragmaParamName}
	 * labeled alternative in {@link KickCParser#pragmaParam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragmaParamName(KickCParser.PragmaParamNameContext ctx);
	/**
	 * Visit a parse tree produced by the {@code pragmaParamString}
	 * labeled alternative in {@link KickCParser#pragmaParam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragmaParamString(KickCParser.PragmaParamStringContext ctx);
	/**
	 * Visit a parse tree produced by the {@code pragmaParamCallingConvention}
	 * labeled alternative in {@link KickCParser#pragmaParam}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPragmaParamCallingConvention(KickCParser.PragmaParamCallingConventionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveConst}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveConst(KickCParser.DirectiveConstContext ctx);
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
	 * Visit a parse tree produced by the {@code directiveMemoryAreaZp}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveMemoryAreaZp(KickCParser.DirectiveMemoryAreaZpContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveMemoryAreaMain}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveMemoryAreaMain(KickCParser.DirectiveMemoryAreaMainContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveMemoryAreaAddress}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveMemoryAreaAddress(KickCParser.DirectiveMemoryAreaAddressContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveVolatile}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveVolatile(KickCParser.DirectiveVolatileContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveStatic}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveStatic(KickCParser.DirectiveStaticContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveFormSsa}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveFormSsa(KickCParser.DirectiveFormSsaContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveFormMa}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveFormMa(KickCParser.DirectiveFormMaContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveExtern}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveExtern(KickCParser.DirectiveExternContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveExport}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveExport(KickCParser.DirectiveExportContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveInline}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveInline(KickCParser.DirectiveInlineContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveIntrinsic}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveIntrinsic(KickCParser.DirectiveIntrinsicContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveInterrupt}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveInterrupt(KickCParser.DirectiveInterruptContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveReserveZp}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveReserveZp(KickCParser.DirectiveReserveZpContext ctx);
	/**
	 * Visit a parse tree produced by the {@code directiveCallingConvention}
	 * labeled alternative in {@link KickCParser#directive}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDirectiveCallingConvention(KickCParser.DirectiveCallingConventionContext ctx);
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
	 * Visit a parse tree produced by the {@code stmtSwitch}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtSwitch(KickCParser.StmtSwitchContext ctx);
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
	 * Visit a parse tree produced by the {@code stmtEmpty}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmtEmpty(KickCParser.StmtEmptyContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#switchCases}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSwitchCases(KickCParser.SwitchCasesContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#switchCase}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSwitchCase(KickCParser.SwitchCaseContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forClassic}
	 * labeled alternative in {@link KickCParser#forLoop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForClassic(KickCParser.ForClassicContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forRange}
	 * labeled alternative in {@link KickCParser#forLoop}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForRange(KickCParser.ForRangeContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forClassicInitDecl}
	 * labeled alternative in {@link KickCParser#forClassicInit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForClassicInitDecl(KickCParser.ForClassicInitDeclContext ctx);
	/**
	 * Visit a parse tree produced by the {@code forClassicInitExpr}
	 * labeled alternative in {@link KickCParser#forClassicInit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForClassicInitExpr(KickCParser.ForClassicInitExprContext ctx);
	/**
	 * Visit a parse tree produced by {@link KickCParser#forClassicCondition}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForClassicCondition(KickCParser.ForClassicConditionContext ctx);
	/**
	 * Visit a parse tree produced by the {@code commaNone}
	 * labeled alternative in {@link KickCParser#commaExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommaNone(KickCParser.CommaNoneContext ctx);
	/**
	 * Visit a parse tree produced by the {@code commaSimple}
	 * labeled alternative in {@link KickCParser#commaExpr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCommaSimple(KickCParser.CommaSimpleContext ctx);
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
	 * Visit a parse tree produced by the {@code exprTypeId}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprTypeId(KickCParser.ExprTypeIdContext ctx);
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
	 * Visit a parse tree produced by the {@code exprArrow}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprArrow(KickCParser.ExprArrowContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprDot}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprDot(KickCParser.ExprDotContext ctx);
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
	 * Visit a parse tree produced by the {@code exprSizeOf}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprSizeOf(KickCParser.ExprSizeOfContext ctx);
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
	 * Visit a parse tree produced by the {@code exprDefined}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprDefined(KickCParser.ExprDefinedContext ctx);
	/**
	 * Visit a parse tree produced by the {@code exprTernary}
	 * labeled alternative in {@link KickCParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprTernary(KickCParser.ExprTernaryContext ctx);
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
	 * Visit a parse tree produced by {@link KickCParser#kasmContent}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitKasmContent(KickCParser.KasmContentContext ctx);
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
	 * Visit a parse tree produced by the {@code asmModeIndLongIdxXY}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeIndLongIdxXY(KickCParser.AsmModeIndLongIdxXYContext ctx);
	/**
	 * Visit a parse tree produced by the {@code asmModeSPIndIdx}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeSPIndIdx(KickCParser.AsmModeSPIndIdxContext ctx);
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
	 * Visit a parse tree produced by the {@code asmModeIndLong}
	 * labeled alternative in {@link KickCParser#asmParamMode}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAsmModeIndLong(KickCParser.AsmModeIndLongContext ctx);
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