// KickC grammar
grammar KickC;

file :
    stmtSeq EOF
    ;

stmtSeq
    : stmt+
    ;

stmt
    : '{' stmtSeq '}' #stmtBlock
    | (TYPE)? NAME ('=' expr)? ';' #stmtAssignment
    | expr  ';' #stmtExpr
    | 'if' '(' expr ')' stmt ( 'else' stmt )? #stmtIfElse
    | 'while' '(' expr ')' stmt  #stmtWhile
    ;


expr
    : '(' expr ')' #exprPar
    | ('+' | '-' | 'not' | '!') expr #exprUnary
    | expr ('*' | '/' ) expr #exprBinary
    | expr ( '+' | '-')  expr #exprBinary
    | expr ( '==' | '!=' | '<>' | '<' | '<=' | '=<' | '>=' | '=>' | '>' ) expr #exprBinary
    | expr ( 'and' | '&&' )  expr #exprBinary
    | expr ( 'or' | '||' )  expr #exprBinary
    | NAME #exprId
    | NUMBER #exprNumber
    | STRING #exprString
    | BOOLEAN #exprBool
    ;

TYPE: 'byte' | 'word' | 'string' | 'boolean';
STRING : '"' ('\\"' | ~'"')* '"';
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
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines