// KickC grammar
parser grammar KickCParser;

options { tokenVocab=KickCLexer; }

@header {
}


@members {
    // The C parser
    CParser cParser;
    // true when a typedef is being created
    boolean isTypedef;

	public KickCParser(TokenStream input, CParser cParser) {
		this(input);
		this.cParser = cParser;
		this.isTypedef = false;
	}

}

file
    : declSeq EOF
    ;

asmFile
    : asmLines EOF
    ;

declSeq
    : decl*
    ;

decl
    : declVariables ';'
    | declFunction
    | structDef ';'
    | enumDef ';'
    | pragma
    | typeDef ';'
    ;

declVariables
    : declType declaratorInitList
    ;

declaratorInitList
    : declaratorInit
    | declaratorInitList COMMA declaratorInit
    ;

declaratorInit
    : declarator ('=' expr)? #declVariableInitExpr
    | declarator '=' kasmContent #declVariableInitKasm
    ;

typeDef
    : TYPEDEF declType { isTypedef=true; }  declarator
    ;

declType
    : directive* type directive*
    ;

typeName
    : type typeNameDeclarator
    ;

typeNameDeclarator
    :  #typeNameDeclaratorName
    | typeNameDeclarator PAR_BEGIN parameterListDecl? PAR_END #typeNameDeclaratorProcedure
    | typeNameDeclarator BRACKET_BEGIN (expr)? BRACKET_END #typeNameDeclaratorArray
    | ASTERISK directive* typeNameDeclarator #typeNameDeclaratorPointer
    | PAR_BEGIN typeNameDeclarator PAR_END #typeNameDeclaratorPar
    ;

declarator
    : NAME {if(isTypedef) { cParser.addTypedef($NAME.text); isTypedef=false; } } #declaratorName
    | declarator PAR_BEGIN parameterListDecl? PAR_END #declaratorProcedure
    | declarator BRACKET_BEGIN (expr)? BRACKET_END #declaratorArray
    | ASTERISK directive* declarator #declaratorPointer
    | PAR_BEGIN declarator PAR_END #declaratorPar
    ;

type
    : SIMPLETYPE+  #typeSimple
    | structDef  #typeStructDef
    | structRef  #typeStructRef
    | enumDef  #typeEnumDef
    | enumRef  #typeEnumRef
    | TYPEDEFNAME  #typeNamedRef
    ;

structRef
    : (STRUCT|UNION) NAME
    ;

structDef
    : (STRUCT|UNION) NAME? CURLY_BEGIN structMembers+ CURLY_END
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

declFunction
    : declType declarator CURLY_BEGIN stmtSeq? CURLY_END
    ;

parameterListDecl
    : parameterDecl (COMMA parameterDecl)* ;

parameterDecl
    : declType declarator #parameterDeclTypeDeclarator
    | typeName #parameterDeclTypeName
    | PARAM_LIST #parameterDeclList
    ;

pragma
    : PRAGMA NAME PAR_BEGIN pragmaParam (COMMA pragmaParam)* PAR_END
    ;

pragmaParam
    : NUMBER #pragmaParamNumber
    | NUMBER RANGE NUMBER #pragmaParamRange
    | NAME #pragmaParamName
    | STRING #pragmaParamString
    | CALLINGCONVENTION #pragmaParamCallingConvention
    ;

directive
    : CONST #directiveConst
    | ALIGN PAR_BEGIN NUMBER PAR_END #directiveAlign
    | REGISTER ( PAR_BEGIN ( NAME ) PAR_END)? #directiveRegister
    | ADDRESS_ZEROPAGE #directiveMemoryAreaZp
    | ADDRESS_MAINMEM #directiveMemoryAreaMain
    | ADDRESS PAR_BEGIN ( expr ) PAR_END #directiveMemoryAreaAddress
    | VOLATILE #directiveVolatile
    | STATIC #directiveStatic
    | FORM_SSA #directiveFormSsa
    | FORM_MA #directiveFormMa
    | EXTERN #directiveExtern
    | EXPORT #directiveExport
    | INLINE #directiveInline
    | INTRINSIC #directiveIntrinsic
    | INTERRUPT ( PAR_BEGIN NAME PAR_END )? #directiveInterrupt
    | LOCAL_RESERVE PAR_BEGIN pragmaParam ( COMMA pragmaParam )* PAR_END  #directiveReserveZp
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
    | kasmContent #stmtDeclKasm
    | ';' #stmtEmpty
    | NAME COLON #stmtLabel
    | GOTO NAME ';' #stmtGoto
    ;

switchCases:
    switchCase+ ( DEFAULT COLON stmtSeq? )?
    ;

switchCase:
    CASE expr COLON stmtSeq?
    ;

forLoop
    : forClassicInit ';' forClassicCondition? ';' commaExpr? #forClassic
    | declType declarator COLON expr RANGE expr  #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
    ;

forClassicCondition
    : commaExpr
    ;

commaExpr
    : expr #commaNone
    | commaExpr COMMA expr #commaSimple
    ;


initExpr
    : (DOT expr ASSIGN)? expr
    ;


expr
    : PAR_BEGIN commaExpr PAR_END #exprPar
    | expr DOT NAME #exprDot
    | expr '->' NAME  #exprArrow
    | expr PAR_BEGIN parameterList? PAR_END #exprCall
    | SIZEOF PAR_BEGIN typeName PAR_END  #exprSizeOfType
    | SIZEOF expr #exprSizeOf
    | TYPEID PAR_BEGIN typeName PAR_END  #exprTypeIdType
    | TYPEID expr  #exprTypeId
    | DEFINED PAR_BEGIN? NAME PAR_END? #exprDefined
    | expr BRACKET_BEGIN commaExpr BRACKET_END #exprArray
    | PAR_BEGIN typeName PAR_END expr #exprCast
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' ) #exprPostMod
    | ASTERISK expr #exprPtr
    | (PLUS | MINUS | LOGIC_NOT | '&'| '~' ) expr #exprUnary
    | expr (SHIFT_LEFT | SHIFT_RIGHT ) expr #exprBinary
    | expr (ASTERISK | DIVIDE | '%' ) expr #exprBinary
    | expr ( PLUS | MINUS )  expr #exprBinary
    | expr ( '==' | '!=' | LESS_THAN | '<=' | '>=' | GREATER_THAN ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( '&&' )  expr #exprBinary
    | expr ( '||' )  expr #exprBinary
    | expr '?'   expr COLON expr #exprTernary
    | <assoc=right> expr '=' expr  #exprAssignment
    | <assoc=right> expr ASSIGN_COMPOUND expr  #exprAssignmentCompound
    | CURLY_BEGIN initExpr (COMMA initExpr )* COMMA? CURLY_END #initList
    | NAME  #exprId
    | NUMBER #exprNumber
    | STRING+ #exprString
    | CHAR #exprChar
    | BOOLEAN #exprBool
    ;

parameterList
    : expr (COMMA expr)*
    ;

kasmContent
    : KICKASM asmDirectives? KICKASM_BODY
    ;

asmDirectives
    : PAR_BEGIN asmDirective ( COMMA asmDirective )* PAR_END
    ;

asmDirective
    : NAME STRING #asmDirectiveString
    | NAME NAME #asmDirectiveName
    | NAME expr #asmDirectiveExpr
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
    : ASM_NAME ASM_COLON ASM_TAG* #asmLabelName
    | ASM_CURLY_BEGIN ASM_NAME ASM_CURLY_END ASM_COLON ASM_TAG* #asmLabelReplace
    | ASM_MULTI_NAME ASM_COLON ASM_TAG* #asmLabelMulti
    ;

asmInstruction
    : ASM_MNEMONIC (asmParamMode)? ASM_TAG*
    ;

asmBytes
    : ASM_BYTE asmExpr ( ASM_COMMA asmExpr)* ASM_TAG*
    ;

asmParamMode
    : asmExpr #asmModeAbs
    | ASM_IMM asmExpr #asmModeImm
    | asmExpr ASM_COMMA asmExpr #asmModeAbs2
    | asmExpr ASM_COMMA asmExpr ASM_COMMA asmExpr #asmModeAbs3
    | ASM_PAR_BEGIN asmExpr ASM_PAR_END ASM_COMMA ASM_NAME #asmModeIndIdxXY
    | ASM_PAR_BEGIN ASM_PAR_BEGIN asmExpr ASM_PAR_END ASM_PAR_END ASM_COMMA ASM_NAME #asmModeIndLongIdxXY
    | ASM_PAR_BEGIN asmExpr ASM_COMMA ASM_NAME ASM_PAR_END ASM_COMMA ASM_NAME #asmModeSPIndIdx
    | ASM_PAR_BEGIN asmExpr ASM_COMMA ASM_NAME ASM_PAR_END #asmModeIdxIndXY
    | ASM_PAR_BEGIN asmExpr ASM_PAR_END  #asmModeInd
    | ASM_PAR_BEGIN ASM_PAR_BEGIN asmExpr ASM_PAR_END ASM_PAR_END  #asmModeIndLong
    | ASM_IMM asmExpr ASM_COMMA asmExpr #asmModeImmAndAbs
    | ASM_IMM asmExpr ASM_COMMA asmExpr ASM_COMMA ASM_NAME #asmModeImmAndAbsX
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
