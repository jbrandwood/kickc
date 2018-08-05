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
    : declVariable
    | declFunction
    | declKasm
    ;

declVariable
    :  directive* typeDecl directive* NAME ('=' expr)? ';'
    ;

declFunction
    : directive* typeDecl directive* NAME '(' parameterListDecl? ')' '{' stmtSeq? '}'
    ;

declKasm
    : 'kickasm' kasmDirectives? KICKASM
    ;

kasmDirectives
    : '(' kasmDirective ( ',' kasmDirective )* ')'
    ;

kasmDirective
    : 'resource' STRING #kasmDirectiveResource
    | 'clobber' STRING #kasmDirectiveClobber
    | 'param' NAME ':' expr #kasmDirectiveTransfer
    | 'bytes' expr #kasmDirectiveBytes
    | 'cycles' expr #kasmDirectiveCycles
    | 'pc' ( 'inline' | expr ) #kasmDirectiveAddress
    ;

parameterListDecl
    : parameterDecl (',' parameterDecl)* ;

parameterDecl
    : directive* typeDecl directive* NAME ;

directive
    : 'const' #directiveConst
    | 'extern' #directiveExtern
    | 'align' '(' NUMBER ')' #directiveAlign
    | 'register' '(' NAME ')' #directiveRegister
    | 'inline' #directiveInline
    | 'interrupt' #directiveInterrupt
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVariable #stmtDeclVar
    | '{' stmtSeq? '}' #stmtBlock
    | expr  ';' #stmtExpr
    | 'if' '(' expr ')' stmt ( 'else' stmt )? #stmtIfElse
    | directive? 'while' '(' expr ')' stmt  #stmtWhile
    | directive? 'do' stmt 'while' '(' expr ')' ';' #stmtDoWhile
    | directive? 'for' '(' forDeclaration? forIteration ')' stmt  #stmtFor
    | 'return' expr? ';' #stmtReturn
    | 'asm' '{' asmLines '}' #stmtAsm
    | declKasm #stmtDeclKasm
    ;

forDeclaration
    : directive* typeDecl? directive* NAME ('=' expr)? #forDecl
    ;

forIteration
    : ';' expr ';' expr # forClassic
    | ':' expr ( '..' ) expr #forRange
    ;

typeDecl
    : '(' typeDecl ')' #typePar
    | SIMPLETYPE  #typeSimple
    | 'signed' SIMPLETYPE  #typeSignedSimple
    | typeDecl '*' #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
    | typeDecl '(' ')' #typeProcedure
    ;

expr
    : '(' expr ')' #exprPar
    | NAME '(' parameterList? ')' #exprCall
    | expr '[' expr ']' #exprArray
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
    | <assoc=right> expr '=' expr  #exprAssignment
    | <assoc=right> expr ('+=' | '-=' | '*=' | '/=' | '%=' | '<<=' | '>>=' | '&=' | '|=' | '^=' ) expr  #exprAssignmentCompound
    | '{' expr (',' expr )* '}' #initList
    | NAME  #exprId
    | NUMBER #exprNumber
    | STRING #exprString
    | CHAR #exprChar
    | BOOLEAN #exprBool
    ;

parameterList
    : expr (',' expr)*
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
SIMPLETYPE: 'byte' | 'word' | 'dword' | 'bool' | 'void' ;
STRING : '"' ('\\"' | ~'"')* '"';
CHAR : '\''  ('\\\'' | ~'\'' ) '\'';
BOOLEAN : 'true' | 'false';
NUMBER : NUMFLOAT | NUMINT ;
NUMFLOAT : BINFLOAT | DECFLOAT | HEXFLOAT;
BINFLOAT : ('%' | '0b' | '0B' ) (BINDIGIT)* '.' BINDIGIT+;
DECFLOAT : (DECDIGIT)* '.' DECDIGIT+;
HEXFLOAT : ('$' | '0x' | '0X' ) (HEXDIGIT)* '.' HEXDIGIT+;
NUMINT : DECINTEGER | HEXINTEGER | BININTEGER ;
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

WS : [ \t\r\n]+ -> skip ;
COMMENT_LINE : '//' ~[\r\n]* -> skip ;
COMMENT_BLOCK : '/*' .*? '*/' -> skip;