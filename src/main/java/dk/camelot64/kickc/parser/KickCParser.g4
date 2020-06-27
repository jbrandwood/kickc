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
    : decl*
    ;

decl
    : declVariables ';'
    | structDef ';'
    | enumDef ';'
    | declFunction
    | globalDirective
    | typeDef ';'
    ;

declVariables
    : declType declVariableList
    ;

declVariableList
    : declPointer* declVariableInit
    | declVariableList COMMA declPointer* declVariableInit
    ;

typeDef
    : TYPEDEF declType declPointer* NAME declArray* {cParser.addTypedef($NAME.text);}
    ;

declVariableInit
    : NAME declArray* ('=' expr)? #declVariableInitExpr
    | NAME declArray* '=' kasmContent #declVariableInitKasm
    ;

declType
    : directive* type directive*
    ;

declPointer
    : ASTERISK directive*
    ;

declArray
    : BRACKET_BEGIN (expr)? BRACKET_END
    ;

typeSpecifier
    : type #typeSpecifierSimple
    | typeSpecifier ASTERISK #typeSpecifierPointer
    | typeSpecifier BRACKET_BEGIN (expr)? BRACKET_END #typeSpecifierArray
    ;

type
    : PAR_BEGIN type PAR_END #typePar
    | SIMPLETYPE  #typeSimple
    | SIGNEDNESS SIMPLETYPE?  #typeSignedSimple
    | type BRACKET_BEGIN (expr)? BRACKET_END #typeArray
    | type PAR_BEGIN PAR_END #typeProcedure
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

declFunction
    : declType declPointer* NAME PAR_BEGIN parameterListDecl? PAR_END (declFunctionBody | ';' )
    ;

declFunctionBody
    : CURLY_BEGIN stmtSeq? CURLY_END
    ;

parameterListDecl
    : parameterDecl (COMMA parameterDecl)* ;

parameterDecl
    : declType declPointer* NAME #parameterDeclType
    | SIMPLETYPE #parameterDeclVoid
    | PARAM_LIST #parameterDeclList
    ;

globalDirective
    : (PRAGMA TARGET) PAR_BEGIN NAME PAR_END #globalDirectivePlatform
    | (PRAGMA CPU) PAR_BEGIN NAME PAR_END #globalDirectiveCpu
    | (PRAGMA LINK) PAR_BEGIN STRING PAR_END #globalDirectiveLinkScript
    | (PRAGMA EXTENSION) PAR_BEGIN STRING PAR_END #globalDirectiveExtension
    | (PRAGMA EMULATOR) PAR_BEGIN STRING PAR_END #globalDirectiveEmulator
    | (PRAGMA RESERVE) PAR_BEGIN directiveReserveParam ( COMMA directiveReserveParam )* PAR_END #globalDirectiveReserve
    | (PRAGMA PC) PAR_BEGIN NUMBER PAR_END #globalDirectivePc
    | (PRAGMA CODESEG) PAR_BEGIN NAME PAR_END #globalDirectiveCodeSeg
    | (PRAGMA DATASEG) PAR_BEGIN NAME PAR_END #globalDirectiveDataSeg
    | (PRAGMA ENCODING) PAR_BEGIN NAME PAR_END #globalDirectiveEncoding
    | (PRAGMA CALLING) PAR_BEGIN CALLINGCONVENTION PAR_END #globalDirectiveCalling
    | (PRAGMA VARMODEL) PAR_BEGIN NAME ( COMMA NAME )* PAR_END #globalDirectiveVarModel
    ;

directiveReserveParam
    : NUMBER (RANGE NUMBER)?
    ;

directive
    : CONST #directiveConst
    | ALIGN PAR_BEGIN NUMBER PAR_END #directiveAlign
    | REGISTER ( PAR_BEGIN ( NAME ) PAR_END)? #directiveRegister
    | ADDRESS_ZEROPAGE #directiveMemoryAreaZp
    | ADDRESS_MAINMEM #directiveMemoryAreaMain
    | ADDRESS PAR_BEGIN ( NUMBER ) PAR_END #directiveMemoryAreaAddress
    | VOLATILE #directiveVolatile
    | STATIC #directiveStatic
    | FORM_SSA #directiveFormSsa
    | FORM_MA #directiveFormMa
    | EXTERN #directiveExtern
    | EXPORT #directiveExport
    | INLINE #directiveInline
    | INTRINSIC #directiveIntrinsic
    | INTERRUPT ( PAR_BEGIN NAME PAR_END )? #directiveInterrupt
    | LOCAL_RESERVE PAR_BEGIN directiveReserveParam ( COMMA directiveReserveParam )* PAR_END  #directiveReserveZp
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
    ;

switchCases:
    switchCase+ ( DEFAULT COLON stmtSeq? )?
    ;

switchCase:
    CASE expr COLON stmtSeq?
    ;

forLoop
    : forClassicInit ';' commaExpr ';' commaExpr? #forClassic
    | (declType declPointer*)? NAME COLON expr RANGE expr  #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
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
    | SIZEOF PAR_BEGIN ( expr | typeSpecifier ) PAR_END #exprSizeOf
    | TYPEID PAR_BEGIN ( expr | typeSpecifier ) PAR_END #exprTypeId
    | DEFINED PAR_BEGIN? NAME PAR_END? #exprDefined
    | expr BRACKET_BEGIN commaExpr BRACKET_END #exprArray
    | PAR_BEGIN typeSpecifier PAR_END expr #exprCast
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
    | CURLY_BEGIN expr (COMMA expr )* COMMA? CURLY_END #initList
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
    : RESOURCE STRING #asmDirectiveResource
    | USES NAME #asmDirectiveUses
    | CLOBBERS STRING #asmDirectiveClobber
    | BYTES expr #asmDirectiveBytes
    | CYCLES expr #asmDirectiveCycles
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
