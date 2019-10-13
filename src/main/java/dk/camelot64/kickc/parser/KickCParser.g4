// KickC grammar
parser grammar KickCParser;

options { tokenVocab=KickCLexer; }

@header {
}


@members {
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
    : declVariables ';'
    | structDef ';'
    | enumDef ';'
    | declFunction
    | declKasm
    | globalDirective
    | typeDef ';'
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
    : NAME ('=' expr)? #declVariableInitExpr
    | NAME '=' declKasm #declVariableInitKasm
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
    | (PRAGMA CPU) PAR_BEGIN NAME PAR_END #globalDirectiveCpu
    | (PRAGMA LINK) PAR_BEGIN STRING PAR_END #globalDirectiveLinkScript
    | (PRAGMA CODESEG) PAR_BEGIN NAME PAR_END #globalDirectiveCodeSeg
    | (PRAGMA DATASEG) PAR_BEGIN NAME PAR_END #globalDirectiveDataSeg
    | (PRAGMA ENCODING) PAR_BEGIN NAME PAR_END #globalDirectiveEncoding
    | (PRAGMA CALLING) PAR_BEGIN CALLINGCONVENTION PAR_END #globalDirectiveCalling
    ;

directive
    : CONST #directiveConst
    | EXTERN #directiveExtern
    | EXPORT #directiveExport
    | ALIGN PAR_BEGIN NUMBER PAR_END #directiveAlign
    | REGISTER ( PAR_BEGIN ( NAME ) PAR_END)? #directiveRegister
    | MEMORY #directiveMemory
    | ( ZEROPAGE | MAINMEM ) ( PAR_BEGIN ( NUMBER ) PAR_END)? #directiveMemoryArea
    | INLINE #directiveInline
    | VOLATILE #directiveVolatile
    | INTERRUPT ( PAR_BEGIN NAME PAR_END )? #directiveInterrupt
    | RESERVE PAR_BEGIN NUMBER ( COMMA NUMBER )* PAR_END  #directiveReserveZp
    | CALLINGCONVENTION #directiveCallingConvention
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVariables ';' #stmtDeclVar
    | CURLY_BEGIN stmtSeq? CURLY_END #stmtBlock
    | commaExpr  ';' #stmtExpr
    | IF PAR_BEGIN commaExpr PAR_END stmt ( ELSE stmt )? #stmtIfElse
    | directive* WHILE PAR_BEGIN commaExpr PAR_END stmt  #stmtWhile
    | directive* DO stmt WHILE PAR_BEGIN commaExpr PAR_END ';' #stmtDoWhile
    | directive* FOR PAR_BEGIN forLoop PAR_END stmt  #stmtFor
    | SWITCH PAR_BEGIN commaExpr PAR_END CURLY_BEGIN switchCases CURLY_END #stmtSwitch
    | RETURN commaExpr? ';' #stmtReturn
    | BREAK ';' #stmtBreak
    | CONTINUE ';' #stmtContinue
    | ASM asmDirectives? CURLY_BEGIN asmLines ASM_CURLY_END #stmtAsm
    | declKasm #stmtDeclKasm
    ;

switchCases:
    switchCase+ ( DEFAULT COLON stmtSeq? )?
    ;

switchCase:
    CASE expr COLON stmtSeq?
    ;

forLoop
    : forClassicInit ';' commaExpr ';' commaExpr? #forClassic
    | declTypes? NAME COLON expr '..' expr  #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
    ;

typeDecl
    : PAR_BEGIN typeDecl PAR_END #typePar
    | SIMPLETYPE  #typeSimple
    | SIGNEDNESS SIMPLETYPE?  #typeSignedSimple
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
    : declVariables ';'
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
    :   NAME ( '=' expr )?
    ;

commaExpr
    : expr #commaNone
    | commaExpr COMMA expr #commaSimple
    ;

expr
    : PAR_BEGIN commaExpr PAR_END #exprPar
    | expr DOT NAME #exprDot
    | expr '->' NAME  #exprArrow
    | expr PAR_BEGIN parameterList? PAR_END #exprCall
    | SIZEOF PAR_BEGIN ( expr | typeDecl ) PAR_END #exprSizeOf
    | TYPEID PAR_BEGIN ( expr | typeDecl ) PAR_END #exprTypeId
    | expr BRACKET_BEGIN commaExpr BRACKET_END #exprArray
    | PAR_BEGIN typeDecl PAR_END expr #exprCast
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' ) #exprPostMod
    | ASTERISK expr #exprPtr
    | (PLUS | MINUS | LOGIC_NOT | '&'| '~' ) expr #exprUnary
    | expr (SHIFT_LEFT | SHIFT_RIGHT ) expr #exprBinary
    | expr (ASTERISK | DIVIDE | '%' ) expr #exprBinary
    | expr ( PLUS | MINUS )  expr #exprBinary
    | (LESS_THAN | GREATER_THAN) expr #exprUnary
    | expr ( '==' | '!=' | LESS_THAN | '<=' | '>=' | GREATER_THAN ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( '&&' )  expr #exprBinary
    | expr ( '||' )  expr #exprBinary
    | expr '?'   expr COLON expr #exprTernary
    | <assoc=right> expr '=' expr  #exprAssignment
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
    : asmLine*
    ;

asmLine
    : asmLabel
    | asmInstruction
    | asmBytes
    ;

asmLabel
    : ASM_NAME ASM_COLON  #asmLabelName
    | ASM_MULTI_NAME ASM_COLON #asmLabelMulti
    ;

asmInstruction
    : ASM_MNEMONIC (asmParamMode)?
    ;

asmBytes
    : ASM_BYTE asmExpr ( ASM_COMMA asmExpr)*
    ;

asmParamMode
    : asmExpr #asmModeAbs
    | ASM_IMM asmExpr #asmModeImm
    | asmExpr ASM_COMMA ASM_NAME #asmModeAbsXY
    | ASM_PAR_BEGIN asmExpr ASM_PAR_END ASM_COMMA ASM_NAME #asmModeIndIdxXY
    | ASM_PAR_BEGIN asmExpr ASM_COMMA ASM_NAME ASM_PAR_END #asmModeIdxIndXY
    | ASM_PAR_BEGIN asmExpr ASM_PAR_END  #asmModeInd
    ;

asmExpr
    : ASM_BRACKET_BEGIN asmExpr ASM_BRACKET_END #asmExprPar
    | asmExpr ( ASM_DOT ) asmExpr #asmExprBinary
    | asmExpr ( ASM_SHIFT_LEFT| ASM_SHIFT_RIGHT ) asmExpr #asmExprBinary
    | (ASM_PLUS | ASM_MINUS| ASM_LESS_THAN | ASM_GREATER_THAN ) asmExpr #asmExprUnary
    | asmExpr (ASM_MULTIPLY | ASM_DIVIDE ) asmExpr #asmExprBinary
    | asmExpr ( ASM_PLUS | ASM_MINUS )  asmExpr #asmExprBinary
    | ASM_NAME #asmExprLabel
    | ASM_MULTI_REL #asmExprLabelRel
    | ASM_CURLY_BEGIN ASM_NAME ASM_CURLY_END #asmExprReplace
    | ASM_NUMBER #asmExprInt
    | ASM_CHAR #asmExprChar
    ;
