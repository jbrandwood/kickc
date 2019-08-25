// KickC grammar
parser grammar KickCParser;

options { tokenVocab=KickCLexer; }

@header {
}


@parser::members {
    CParser cParser;

	public KickCParser(TokenStream input, CParser cParser) {
		this(input);
		this.cParser = cParser;
	}

}

file
    : declSeq EOF
    ;


asmFile
    : asmLines EOF
    ;

declSeq
    : declOrImport*
    ;

declOrImport
    : decl
    | importDecl
    ;

importDecl
    : IMPORT STRING
    ;

decl
    : declVariables SEMICOLON
    | structDef SEMICOLON
    | enumDef SEMICOLON
    | declFunction
    | declKasm
    | globalDirective
    | typeDef SEMICOLON
    ;

typeDef
    : TYPEDEF typeDecl NAME {cParser.addTypedef($NAME.text);}
    ;

declTypes
    : directive* typeDecl directive*
    ;

declVariables
    : declTypes declVariableList
    ;

declVariableList
    : declVariableInit
    | declVariableList COMMA declVariableInit
    ;

declVariableInit
    : NAME (ASSIGN expr)? #declVariableInitExpr
    | NAME ASSIGN declKasm #declVariableInitKasm
    ;

declFunction
    : declTypes NAME PAR_BEGIN parameterListDecl? PAR_END CURLY_BEGIN stmtSeq? CURLY_END
    ;

parameterListDecl
    : parameterDecl (COMMA parameterDecl)* ;

parameterDecl
    : declTypes NAME #parameterDeclType
    | SIMPLETYPE #parameterDeclVoid
    ;

globalDirective
    : (PRAGMA RESERVE) PAR_BEGIN NUMBER ( COMMA NUMBER )* PAR_END #globalDirectiveReserve
    | (PRAGMA PC) PAR_BEGIN NUMBER PAR_END #globalDirectivePc
    | (PRAGMA TARGET) PAR_BEGIN NAME PAR_END #globalDirectivePlatform
    | (PRAGMA LINK) PAR_BEGIN STRING PAR_END #globalDirectiveLinkScript
    | (PRAGMA CODESEG) PAR_BEGIN NAME PAR_END #globalDirectiveCodeSeg
    | (PRAGMA DATASEG) PAR_BEGIN NAME PAR_END #globalDirectiveDataSeg
    | (PRAGMA ENCODING) PAR_BEGIN NAME PAR_END #globalDirectiveEncoding
    ;

directive
    : CONST #directiveConst
    | EXTERN #directiveExtern
    | EXPORT #directiveExport
    | ALIGN PAR_BEGIN NUMBER PAR_END #directiveAlign
    | REGISTER ( PAR_BEGIN NAME PAR_END)? #directiveRegister
    | INLINE #directiveInline
    | VOLATILE #directiveVolatile
    | INTERRUPT ( PAR_BEGIN NAME PAR_END )? #directiveInterrupt
    | RESERVE PAR_BEGIN NUMBER ( COMMA NUMBER )* PAR_END  #directiveReserveZp
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVariables SEMICOLON #stmtDeclVar
    | CURLY_BEGIN stmtSeq? CURLY_END #stmtBlock
    | commaExpr  SEMICOLON #stmtExpr
    | IF PAR_BEGIN commaExpr PAR_END stmt ( ELSE stmt )? #stmtIfElse
    | directive* WHILE PAR_BEGIN commaExpr PAR_END stmt  #stmtWhile
    | directive* DO stmt WHILE PAR_BEGIN commaExpr PAR_END SEMICOLON #stmtDoWhile
    | directive* FOR PAR_BEGIN forLoop PAR_END stmt  #stmtFor
    | SWITCH PAR_BEGIN commaExpr PAR_END CURLY_BEGIN switchCases CURLY_END #stmtSwitch
    | RETURN commaExpr? SEMICOLON #stmtReturn
    | BREAK SEMICOLON #stmtBreak
    | CONTINUE SEMICOLON #stmtContinue
    | ASM asmDirectives? CURLY_BEGIN asmLines CURLY_END #stmtAsm
    | declKasm #stmtDeclKasm
    ;

switchCases:
    switchCase+ ( DEFAULT COLON stmtSeq? )?
    ;

switchCase:
    CASE expr COLON stmtSeq?
    ;

forLoop
    : forClassicInit SEMICOLON commaExpr SEMICOLON commaExpr? #forClassic
    | declTypes? NAME COLON expr RANGE expr  #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
    ;

typeDecl
    : PAR_BEGIN typeDecl PAR_END #typePar
    | SIMPLETYPE  #typeSimple
    | (SIGNED|UNSIGNED) SIMPLETYPE?  #typeSignedSimple
    | typeDecl ASTERISK #typePtr
    | typeDecl BRACKET_BEGIN (expr)? BRACKET_END #typeArray
    | typeDecl PAR_BEGIN PAR_END #typeProcedure
    | structDef  #typeStructDef
    | structRef  #typeStructRef
    | enumDef  #typeEnumDef
    | enumRef  #typeEnumRef
    | TYPEDEFNAME  #typeNamedRef
    ;

structRef
    : STRUCT NAME
    ;

structDef
    : STRUCT NAME? CURLY_BEGIN structMembers+ CURLY_END
    ;

structMembers
    : declVariables SEMICOLON
    ;

enumRef
    : ENUM NAME
    ;

enumDef
    : ENUM NAME? CURLY_BEGIN enumMemberList CURLY_END
    ;

enumMemberList
    :  enumMember
    |  enumMemberList COMMA enumMember
    ;

enumMember
    :   NAME ( ASSIGN expr )?
    ;

commaExpr
    : expr #commaNone
    | commaExpr COMMA expr #commaSimple
    ;

expr
    : PAR_BEGIN commaExpr PAR_END #exprPar
    | expr DOT NAME #exprDot
    | expr ARROW NAME  #exprArrow
    | expr PAR_BEGIN parameterList? PAR_END #exprCall
    | SIZEOF PAR_BEGIN ( expr | typeDecl ) PAR_END #exprSizeOf
    | TYPEID PAR_BEGIN ( expr | typeDecl ) PAR_END #exprTypeId
    | expr BRACKET_BEGIN commaExpr BRACKET_END #exprArray
    | PAR_BEGIN typeDecl PAR_END expr #exprCast
    | (DEC | INC ) expr #exprPreMod
    | expr (DEC | INC ) #exprPostMod
    | ASTERISK expr #exprPtr
    | (PLUS | MINUS | LOGIC_NOT | AND | BIT_NOT) expr #exprUnary
    | expr (SHIFT_RIGHT | SHIFT_LEFT ) expr #exprBinary
    | expr (ASTERISK | DIVIDE | MODULO ) expr #exprBinary
    | expr ( PLUS | MINUS)  expr #exprBinary
    | (LESS_THAN | GREATER_THAN) expr #exprUnary
    | expr ( EQUAL | NOT_EQUAL | LESS_THAN | LESS_THAN_EQUAL | GREATER_THAN_EQUAL | GREATER_THAN ) expr #exprBinary
    | expr ( AND ) expr #exprBinary
    | expr ( BIT_XOR ) expr #exprBinary
    | expr ( BIT_OR ) expr #exprBinary
    | expr ( LOGIC_AND )  expr #exprBinary
    | expr ( LOGIC_OR )  expr #exprBinary
    | expr QUESTION   expr COLON expr #exprTernary
    | <assoc=right> expr ASSIGN expr  #exprAssignment
    | <assoc=right> expr ASSIGN_COMPOUND expr  #exprAssignmentCompound
    | CURLY_BEGIN expr (COMMA expr )* CURLY_END #initList
    | NAME  #exprId
    | NUMBER #exprNumber
    | STRING+ #exprString
    | CHAR #exprChar
    | BOOLEAN #exprBool
    ;

parameterList
    : expr (COMMA expr)*
    ;

declKasm
    : KICKASM asmDirectives? KICKASM_BODY
    ;

asmDirectives
    : PAR_BEGIN asmDirective ( COMMA asmDirective )* PAR_END
    ;

asmDirective
    : RESOURCE STRING #asmDirectiveResource
    | USES NAME #asmDirectiveUses
    | CLOBBERS STRING #asmDirectiveClobber
    | BYTES expr #asmDirectiveBytes
    | CYCLES expr #asmDirectiveCycles
    | PC ( INLINE | expr ) #asmDirectiveAddress
    ;

asmLines
    : {cParser.setModeAsm(true);} asmLine* {cParser.setModeAsm(false);}
    ;

asmLine
    : asmLabel
    | asmInstruction
    | asmBytes
    ;

asmLabel
    : NAME COLON  #asmLabelName
    | LOGIC_NOT NAME? COLON #asmLabelMulti
    ;

asmInstruction
    : MNEMONIC (asmParamMode)?
    ;

asmBytes
    : ASM_BYTE asmExpr ( COMMA asmExpr)*
    ;

asmParamMode
    : asmExpr #asmModeAbs
    | ASM_IMM asmExpr #asmModeImm
    | asmExpr COMMA NAME #asmModeAbsXY
    | PAR_BEGIN asmExpr PAR_END COMMA NAME #asmModeIndIdxXY
    | PAR_BEGIN asmExpr COMMA NAME PAR_END #asmModeIdxIndXY
    | PAR_BEGIN asmExpr PAR_END  #asmModeInd
    ;

asmExpr
    : BRACKET_BEGIN asmExpr BRACKET_END #asmExprPar
    | asmExpr ( DOT ) asmExpr #asmExprBinary
    | asmExpr ( SHIFT_LEFT | SHIFT_RIGHT ) asmExpr #asmExprBinary
    | (PLUS | MINUS | LESS_THAN | GREATER_THAN ) asmExpr #asmExprUnary
    | asmExpr (ASTERISK | DIVIDE ) asmExpr #asmExprBinary
    | asmExpr ( PLUS | MINUS )  asmExpr #asmExprBinary
    | NAME #asmExprLabel
    | ASMREL #asmExprLabelRel
    | CURLY_BEGIN NAME CURLY_END #asmExprReplace
    | NUMBER #asmExprInt
    | CHAR #asmExprChar
    ;
