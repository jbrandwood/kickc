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
    | declVariableList ',' declVariableInit
    ;

declVariableInit
    : NAME ('=' expr)? #declVariableInitExpr
    | NAME '=' declKasm #declVariableInitKasm
    ;

declFunction
    : declTypes NAME '(' parameterListDecl? ')' '{' stmtSeq? '}'
    ;

parameterListDecl
    : parameterDecl (',' parameterDecl)* ;

parameterDecl
    : declTypes NAME #parameterDeclType
    | SIMPLETYPE #parameterDeclVoid
    ;

globalDirective
    : (PRAGMA RESERVE) '(' NUMBER ( ',' NUMBER )* ')' #globalDirectiveReserve
    | (PRAGMA PC) '(' NUMBER ')' #globalDirectivePc
    | (PRAGMA TARGET) '(' NAME ')' #globalDirectivePlatform
    | (PRAGMA LINK) '(' STRING ')' #globalDirectiveLinkScript
    | (PRAGMA CODESEG) '(' NAME ')' #globalDirectiveCodeSeg
    | (PRAGMA DATASEG) '(' NAME ')' #globalDirectiveDataSeg
    | (PRAGMA ENCODING) '(' NAME ')' #globalDirectiveEncoding
    ;

directive
    : CONST #directiveConst
    | EXTERN #directiveExtern
    | EXPORT #directiveExport
    | ALIGN '(' NUMBER ')' #directiveAlign
    | REGISTER ( '(' NAME ')')? #directiveRegister
    | INLINE #directiveInline
    | VOLATILE #directiveVolatile
    | INTERRUPT ( '(' NAME ')' )? #directiveInterrupt
    | RESERVE '(' NUMBER ( ',' NUMBER )* ')'  #directiveReserveZp
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVariables ';' #stmtDeclVar
    | '{' stmtSeq? '}' #stmtBlock
    | commaExpr  ';' #stmtExpr
    | IF '(' commaExpr ')' stmt ( ELSE stmt )? #stmtIfElse
    | directive* WHILE '(' commaExpr ')' stmt  #stmtWhile
    | directive* DO stmt WHILE '(' commaExpr ')' ';' #stmtDoWhile
    | directive* FOR '(' forLoop ')' stmt  #stmtFor
    | SWITCH '(' commaExpr ')' '{' switchCases '}' #stmtSwitch
    | RETURN commaExpr? ';' #stmtReturn
    | BREAK ';' #stmtBreak
    | CONTINUE ';' #stmtContinue
    | ASM asmDirectives? '{' asmLines '}' #stmtAsm
    | declKasm #stmtDeclKasm
    ;

switchCases:
    switchCase+ ( DEFAULT ':' stmtSeq? )?
    ;

switchCase:
    CASE expr ':' stmtSeq?
    ;

forLoop
    : forClassicInit ';' commaExpr ';' commaExpr? #forClassic
    | declTypes? NAME ':' expr '..' expr  #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
    ;

typeDecl
    : '(' typeDecl ')' #typePar
    | SIMPLETYPE  #typeSimple
    | SIGNEDNESS SIMPLETYPE?  #typeSignedSimple
    | typeDecl ASTERISK #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
    | typeDecl '(' ')' #typeProcedure
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
    : STRUCT NAME? '{' structMembers+ '}'
    ;

structMembers
    : declVariables ';'
    ;

enumRef
    : ENUM NAME
    ;

enumDef
    : ENUM NAME? '{' enumMemberList '}'
    ;

enumMemberList
    :  enumMember
    |  enumMemberList ',' enumMember
    ;

enumMember
    :   NAME ( '=' expr )?
    ;

commaExpr
    : expr #commaNone
    | commaExpr ',' expr #commaSimple
    ;

expr
    : '(' commaExpr ')' #exprPar
    | expr '.' NAME #exprDot
    | expr '->' NAME  #exprArrow
    | expr '(' parameterList? ')' #exprCall
    | SIZEOF '(' ( expr | typeDecl ) ')' #exprSizeOf
    | TYPEID '(' ( expr | typeDecl ) ')' #exprTypeId
    | expr '[' commaExpr ']' #exprArray
    | '(' typeDecl ')' expr #exprCast
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' ) #exprPostMod
    | '*' expr #exprPtr
    | ('+' | '-' | '!' | '&'| '~' ) expr #exprUnary
    | expr ('<<' | '>>' ) expr #exprBinary
    | expr ('*' | '/' | '%' ) expr #exprBinary
    | expr ( '+' | '-' )  expr #exprBinary
    | ('<' | '>') expr #exprUnary
    | expr ( '==' | '!=' | '<' | '<=' | '>=' | '>' ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( '&&' )  expr #exprBinary
    | expr ( '||' )  expr #exprBinary
    | expr '?'   expr ':' expr #exprTernary
    | <assoc=right> expr '=' expr  #exprAssignment
    | <assoc=right> expr ASSIGN_COMPOUND expr  #exprAssignmentCompound
    | '{' expr (',' expr )* '}' #initList
    | NAME  #exprId
    | NUMBER #exprNumber
    | STRING+ #exprString
    | CHAR #exprChar
    | BOOLEAN #exprBool
    ;

parameterList
    : expr (',' expr)*
    ;

declKasm
    : KICKASM asmDirectives? KICKASM_BODY
    ;

asmDirectives
    : '(' asmDirective ( ',' asmDirective )* ')'
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
    : NAME ':'  #asmLabelName
    | '!' NAME? ':' #asmLabelMulti
    ;

asmInstruction
    : ASM_MNEMONIC (asmParamMode)?
    ;

asmBytes
    : ASM_BYTE asmExpr ( ',' asmExpr)*
    ;

asmParamMode
    : asmExpr #asmModeAbs
    | '#' asmExpr #asmModeImm
    | asmExpr ',' NAME #asmModeAbsXY
    | '(' asmExpr ')' ',' NAME #asmModeIndIdxXY
    | '(' asmExpr ',' NAME ')' #asmModeIdxIndXY
    | '(' asmExpr ')'  #asmModeInd
    ;

asmExpr
    : '[' asmExpr ']' #asmExprPar
    | asmExpr ( '.' ) asmExpr #asmExprBinary
    | asmExpr ( '<<'| '>>' ) asmExpr #asmExprBinary
    | ('+' | '-'| '<' | '>' ) asmExpr #asmExprUnary
    | asmExpr ('*' | '/' ) asmExpr #asmExprBinary
    | asmExpr ( '+' | '-' )  asmExpr #asmExprBinary
    | NAME #asmExprLabel
    | ASM_REL #asmExprLabelRel
    | '{' NAME '}' #asmExprReplace
    | NUMBER #asmExprInt
    | CHAR #asmExprChar
    ;
