// Generated from /Users/jespergravgaard/c64/src/kickc/src/dk/camelot64/kickc/parser/KickC.g4 by ANTLR 4.7
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
	 * Enter a parse tree produced by the {@code stmtFunction}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtFunction(KickCParser.StmtFunctionContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtFunction}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtFunction(KickCParser.StmtFunctionContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtDeclaration}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtDeclaration(KickCParser.StmtDeclarationContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtDeclaration}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtDeclaration(KickCParser.StmtDeclarationContext ctx);
	/**
	 * Enter a parse tree produced by the {@code stmtAssignment}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmtAssignment(KickCParser.StmtAssignmentContext ctx);
	/**
	 * Exit a parse tree produced by the {@code stmtAssignment}
	 * labeled alternative in {@link KickCParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmtAssignment(KickCParser.StmtAssignmentContext ctx);
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
	 * Enter a parse tree produced by the {@code initExpr}
	 * labeled alternative in {@link KickCParser#initializer}.
	 * @param ctx the parse tree
	 */
	void enterInitExpr(KickCParser.InitExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code initExpr}
	 * labeled alternative in {@link KickCParser#initializer}.
	 * @param ctx the parse tree
	 */
	void exitInitExpr(KickCParser.InitExprContext ctx);
	/**
	 * Enter a parse tree produced by the {@code initList}
	 * labeled alternative in {@link KickCParser#initializer}.
	 * @param ctx the parse tree
	 */
	void enterInitList(KickCParser.InitListContext ctx);
	/**
	 * Exit a parse tree produced by the {@code initList}
	 * labeled alternative in {@link KickCParser#initializer}.
	 * @param ctx the parse tree
	 */
	void exitInitList(KickCParser.InitListContext ctx);
	/**
	 * Enter a parse tree produced by the {@code lvalueName}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void enterLvalueName(KickCParser.LvalueNameContext ctx);
	/**
	 * Exit a parse tree produced by the {@code lvalueName}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void exitLvalueName(KickCParser.LvalueNameContext ctx);
	/**
	 * Enter a parse tree produced by the {@code lvaluePtr}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void enterLvaluePtr(KickCParser.LvaluePtrContext ctx);
	/**
	 * Exit a parse tree produced by the {@code lvaluePtr}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void exitLvaluePtr(KickCParser.LvaluePtrContext ctx);
	/**
	 * Enter a parse tree produced by the {@code lvalueArray}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void enterLvalueArray(KickCParser.LvalueArrayContext ctx);
	/**
	 * Exit a parse tree produced by the {@code lvalueArray}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void exitLvalueArray(KickCParser.LvalueArrayContext ctx);
	/**
	 * Enter a parse tree produced by the {@code lvaluePar}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void enterLvaluePar(KickCParser.LvalueParContext ctx);
	/**
	 * Exit a parse tree produced by the {@code lvaluePar}
	 * labeled alternative in {@link KickCParser#lvalue}.
	 * @param ctx the parse tree
	 */
	void exitLvaluePar(KickCParser.LvalueParContext ctx);
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
}