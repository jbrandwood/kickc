// KickC grammar
grammar KickC;

file
    : importSeq declSeq EOF
    ;

asmFile
    : asmLines EOF
    ;

importSeq
    : importDecl*
    ;

importDecl
    : 'import' STRING
    ;

declSeq
    : decl+
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
    : 'typedef' declVariables
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
    : ('#pragma' 'reserve'|'#reserve') '(' NUMBER ( ',' NUMBER )* ')' #globalDirectiveReserve
    | ('#pragma' 'pc'|'#pc') '(' NUMBER ')' #globalDirectivePc
    | ('#pragma' 'target'|'#target') '(' NAME ')' #globalDirectivePlatform
    | ('#pragma' 'link') '(' STRING ')' #globalDirectiveLinkScript
    | ('#pragma' 'code_seg') '(' NAME ')' #globalDirectiveCodeSeg
    | ('#pragma' 'data_seg') '(' NAME ')' #globalDirectiveDataSeg
    | ('#pragma' 'encoding'|'#encoding') '(' NAME')' #globalDirectiveEncoding
    ;

directive
    : 'const' #directiveConst
    | 'extern' #directiveExtern
    | 'export' #directiveExport
    | 'align' '(' NUMBER ')' #directiveAlign
    | 'register' ( '(' NAME ')')? #directiveRegister
    | 'inline' #directiveInline
    | 'volatile' #directiveVolatile
    | 'interrupt' ( '(' NAME ')' )? #directiveInterrupt
    | 'reserve' '(' NUMBER ( ',' NUMBER )* ')'  #directiveReserveZp
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVariables ';' #stmtDeclVar
    | '{' stmtSeq? '}' #stmtBlock
    | commaExpr  ';' #stmtExpr
    | 'if' '(' commaExpr ')' stmt ( 'else' stmt )? #stmtIfElse
    | directive* 'while' '(' commaExpr ')' stmt  #stmtWhile
    | directive* 'do' stmt 'while' '(' commaExpr ')' ';' #stmtDoWhile
    | directive* 'for' '(' forLoop ')' stmt  #stmtFor
    | 'switch' '(' commaExpr ')' '{' switchCases '}' #stmtSwitch
    | 'return' commaExpr? ';' #stmtReturn
    | 'break' ';' #stmtBreak
    | 'continue' ';' #stmtContinue
    | 'asm' asmDirectives? '{' asmLines '}' #stmtAsm
    | declKasm #stmtDeclKasm
    ;

switchCases:
    switchCase+ ( 'default:' stmtSeq? )
    ;

switchCase:
    'case' expr ':' stmtSeq?
    ;

forLoop
    : forClassicInit ';' commaExpr ';' commaExpr? #forClassic
    | declTypes? NAME ':' expr ( '..' ) expr #forRange
    ;

forClassicInit
    : declVariables? #forClassicInitDecl
    | commaExpr      #forClassicInitExpr
    ;

typeDecl
    : '(' typeDecl ')' #typePar
    | SIMPLETYPE  #typeSimple
    | ('signed'|'unsigned') SIMPLETYPE?  #typeSignedSimple
    | typeDecl '*' #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
    | typeDecl '(' ')' #typeProcedure
    | structDef  #typeStructDef
    | structRef  #typeStructRef
    | enumDef  #typeEnumDef
    | enumRef  #typeEnumRef
    | NAME  #typeNamedRef
    ;

structRef
    : 'struct' NAME
    ;

structDef
    : 'struct' NAME? '{' structMembers+ '}'
    ;

structMembers
    : declVariables ';'
    ;

enumRef
    : 'enum' NAME
    ;

enumDef
    : 'enum' NAME? '{' enumMemberList '}'
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
    | 'sizeof' '(' ( expr | typeDecl ) ')' #exprSizeOf
    | 'typeid' '(' ( expr | typeDecl ) ')' #exprTypeId
    | expr '[' commaExpr ']' #exprArray
    | '(' typeDecl ')' expr #exprCast
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' ) #exprPostMod
    | '*' expr #exprPtr
    | ('+' | '-' | '!' | '&' | '~') expr #exprUnary
    | expr ('>>' | '<<' ) expr #exprBinary
    | expr ('*' | '/' | '%' ) expr #exprBinary
    | expr ( '+' | '-')  expr #exprBinary
    | ('<' | '>') expr #exprUnary
    | expr ( '==' | '!=' | '<' | '<=' | '>=' | '>' ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( '&&' )  expr #exprBinary
    | expr ( '||' )  expr #exprBinary
    | expr '?'   expr ':' expr #exprTernary
    | <assoc=right> expr '=' expr  #exprAssignment
    | <assoc=right> expr ('+=' | '-=' | '*=' | '/=' | '%=' | '<<=' | '>>=' | '&=' | '|=' | '^=' ) expr  #exprAssignmentCompound
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
    : 'kickasm' asmDirectives? KICKASM
    ;

asmDirectives
    : '(' asmDirective ( ',' asmDirective )* ')'
    ;

asmDirective
    : 'resource' STRING #asmDirectiveResource
    | 'uses' NAME #asmDirectiveUses
    | 'clobbers' STRING #asmDirectiveClobber
    | 'bytes' expr #asmDirectiveBytes
    | 'cycles' expr #asmDirectiveCycles
    | 'pc' ( 'inline' | expr ) #asmDirectiveAddress
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
    : NAME ':'  #asmLabelName
    | '!' NAME? ':' #asmLabelMulti
    ;

asmInstruction
    : MNEMONIC (asmParamMode)?
    ;

asmBytes
    : '.byte' asmExpr ( ',' asmExpr)*
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
    | asmExpr ( '<<' | '>>' ) asmExpr #asmExprBinary
    | ('+' | '-' | '<' | '>' ) asmExpr #asmExprUnary
    | asmExpr ('*' | '/' ) asmExpr #asmExprBinary
    | asmExpr ( '+' | '-' )  asmExpr #asmExprBinary
    | NAME #asmExprLabel
    | ASMREL #asmExprLabelRel
    | '{' NAME '}' #asmExprReplace
    | NUMBER #asmExprInt
    | CHAR #asmExprChar
    ;

MNEMONIC:
    'brk' | 'ora' | 'kil' | 'slo' | 'nop' | 'asl' | 'php' | 'anc' | 'bpl' | 'clc' | 'jsr' | 'and' | 'rla' | 'bit' | 'rol' | 'pla' | 'plp' | 'bmi' | 'sec' |
    'rti' | 'eor' | 'sre' | 'lsr' | 'pha' | 'alr' | 'jmp' | 'bvc' | 'cli' | 'rts' | 'adc' | 'rra' | 'bvs' | 'sei' | 'sax' | 'sty' | 'sta' | 'stx' | 'dey' |
    'txa' | 'xaa' | 'bcc' | 'ahx' | 'tya' | 'txs' | 'tas' | 'shy' | 'shx' | 'ldy' | 'lda' | 'ldx' | 'lax' | 'tay' | 'tax' | 'bcs' | 'clv' | 'tsx' | 'las' |
    'cpy' | 'cmp' | 'cpx' | 'dcp' | 'dec' | 'inc' | 'axs' | 'bne' | 'cld' | 'sbc' | 'isc' | 'inx' | 'beq' | 'sed' | 'dex' | 'iny' | 'ror'
    ;


KICKASM: '{{' .*? '}}';
SIMPLETYPE: 'byte' | 'word' | 'dword' | 'bool' | 'char' | 'short' | 'int' | 'long' | 'void' ;
STRING : '"' ('\\"' | ~'"')* '"' [z]?([ps][mu]?)?[z]?;
CHAR : '\''  ('\\\'' | ~'\'' ) '\'';
BOOLEAN : 'true' | 'false';
NUMBER : NUMFLOAT | NUMINT ;
NUMFLOAT : BINFLOAT | DECFLOAT | HEXFLOAT;
BINFLOAT : ('%' | '0b' | '0B' ) (BINDIGIT)* '.' BINDIGIT+;
DECFLOAT : (DECDIGIT)* '.' DECDIGIT+;
HEXFLOAT : ('$' | '0x' | '0X' ) (HEXDIGIT)* '.' HEXDIGIT+;
NUMINT : (DECINTEGER | HEXINTEGER | BININTEGER ) ([us][bcwisdl] | 'l')? ;
BININTEGER : '0' [bB] BINDIGIT+ | '%' BINDIGIT+ ;
DECINTEGER : DECDIGIT+ ;
HEXINTEGER : ( '$' | '0x' | '0X' ) HEXDIGIT+ ;
fragment BINDIGIT : [0-1];
fragment DECDIGIT : [0-9];
fragment HEXDIGIT : [0-9a-fA-F];
NAME : NAME_START NAME_CHAR* ;
fragment NAME_START : [a-zA-Z_];
fragment NAME_CHAR : [a-zA-Z0-9_];
ASMREL: '!' NAME_CHAR* [+-]+ ;

// Add white space to the hidden channel 1
WS : [ \t\r\n\u00a0]+ -> channel(1);
// Add comments to the hidden channel 2
COMMENT_LINE : '//' ~[\r\n]* -> channel(2);
COMMENT_BLOCK : '/*' .*? '*/' -> channel(2);