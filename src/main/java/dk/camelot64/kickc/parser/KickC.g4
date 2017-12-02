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
    : typeDecl NAME '(' parameterListDecl? ')' '{' stmtSeq? '}' #declMethod
    | declVar #declVariable
    ;

parameterListDecl
    : parameterDecl (',' parameterDecl)* ;

parameterDecl
    : typeDecl NAME ;

declVar
    : ('const')? typeDecl NAME ('=' initializer)? ';'
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVar #stmtDeclVar
    | '{' stmtSeq? '}' #stmtBlock
    | lvalue '=' expr ';' #stmtAssignment
    | expr  ';' #stmtExpr
    | 'if' '(' expr ')' stmt ( 'else' stmt )? #stmtIfElse
    | 'while' '(' expr ')' stmt  #stmtWhile
    | 'do' stmt 'while' '(' expr ')' ';' #stmtDoWhile
    | 'for' '(' forDeclaration? forIteration ')' stmt  #stmtFor
    | 'return' expr? ';' #stmtReturn
    | 'asm' '{' asmLines '}' #stmtAsm
    ;

forDeclaration
    : typeDecl? NAME ('=' initializer)? #forDecl
    ;

forIteration
    : ';' expr ';' expr? # forClassic
    | ':' expr ( '..' ) expr #forRange
    ;

typeDecl
    : SIMPLETYPE  #typeSimple
    | 'signed' SIMPLETYPE  #typeSignedSimple
    | typeDecl '*' #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
    ;

initializer
    : expr #initExpr
    | '{' initializer (',' initializer )* '}' #initList
    ;

lvalue
    : NAME #lvalueName
    | '*' NAME #lvaluePtr
    | '*' '(' expr ')' #lvaluePtrExpr
    | ('<' | '>' ) lvalue #lvalueLoHi
    | lvalue '[' expr ']' #lvalueArray
    ;

expr
    : '(' expr ')' #exprPar
    | NAME '(' parameterList? ')' #exprCall
    | '(' typeDecl ')' expr #exprCast
    | expr '[' expr ']' #exprArray
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' )#exprPostMod
    | ('+' | '-' | '!' | '&' | '*' | '~' | '<' | '>') expr #exprUnary
    | expr ('>>' | '<<' ) expr #exprBinary
    | expr ('*' | '/' | '%' ) expr #exprBinary
    | expr ( '+' | '-')  expr #exprBinary
    | expr ( '==' | '!=' | '<>' | '<' | '<=' | '=<' | '>=' | '=>' | '>' ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( '&&' )  expr #exprBinary
    | expr ( '||' )  expr #exprBinary
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
    ;

asmLabel
    : NAME ':'
    | '!' ':'
    ;

asmInstruction
    : MNEMONIC (asmParamMode)?
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
    : ('+' | '-' | '<' | '>') asmExpr #asmExprUnary
    | asmExpr ('*' | '/' ) asmExpr #asmExprBinary
    | asmExpr ( '+' | '-')  asmExpr #asmExprBinary
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
    'cpy' | 'cmp' | 'cpx' | 'dcp' | 'dec' | 'inc' | 'axs' | 'bne' | 'cld' | 'sbc' | 'isc' | 'inx' | 'beq' | 'sed' | 'dex' | 'iny'
    ;

SIMPLETYPE: 'byte' | 'word' | 'boolean' | 'void' ;
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
ASMREL: '!' [+-]* ;

WS : [ \t\r\n]+ -> skip ;
COMMENT_LINE : '//' ~[\r\n]* -> skip ;
COMMENT_BLOCK : '/*' .*? '*/' -> skip;