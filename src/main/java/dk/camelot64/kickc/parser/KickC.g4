// KickC grammar
grammar KickC;

file :
    stmtSeq EOF
    ;

stmtSeq
    : stmt+
    ;

stmt
    : '{' stmtSeq? '}' #stmtBlock
    | typeDecl NAME '(' parameterListDecl? ')' '{' stmtSeq? '}' #stmtFunction
    | ('const')? typeDecl NAME ('=' initializer)? ';' #stmtDeclaration
    | lvalue '=' expr ';' #stmtAssignment
    | expr  ';' #stmtExpr
    | 'if' '(' expr ')' stmt ( 'else' stmt )? #stmtIfElse
    | 'while' '(' expr ')' stmt  #stmtWhile
    | 'do' stmt 'while' '(' expr ')' #stmtDoWhile
    | 'for' '(' forDeclaration? forIteration ')' stmt  #stmtFor
    | 'return' expr? ';' #stmtReturn
    ;

forDeclaration
    : typeDecl? NAME ('=' initializer)? #forDecl
    ;

forIteration
    : ';' expr ';' expr? # forClassic
    | ':' expr ( '..' ) expr #forRange
    ;

parameterListDecl
    : parameterDecl (',' parameterDecl)* ;

parameterDecl
    : typeDecl NAME ;

typeDecl
    : SIMPLETYPE  #typeSimple
    | typeDecl '*' #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
    ;

initializer
    : expr #initExpr
    | '{' initializer (',' initializer )* '}' #initList
    ;

lvalue
    : '(' lvalue ')' #lvaluePar
    | NAME #lvalueName
    | '*' lvalue #lvaluePtr
    | lvalue '[' expr ']' #lvalueArray
    ;

expr
    : '(' expr ')' #exprPar
    | NAME '(' parameterList? ')' #exprCall
    | '(' typeDecl ')' expr #exprCast
    | expr '[' expr ']' #exprArray
    | ('--' | '++' ) expr #exprPreMod
    | expr ('--' | '++' )#exprPostMod
    | ('+' | '-' | 'not' | '!' | '&' | '*' | '~' | '<' | '>') expr #exprUnary
    | expr ('>>' | '<<' ) expr #exprBinary
    | expr ('*' | '/' | '%' ) expr #exprBinary
    | expr ( '+' | '-')  expr #exprBinary
    | expr ( '==' | '!=' | '<>' | '<' | '<=' | '=<' | '>=' | '=>' | '>' ) expr #exprBinary
    | expr ( '&' ) expr #exprBinary
    | expr ( '^' ) expr #exprBinary
    | expr ( '|' ) expr #exprBinary
    | expr ( 'and' | '&&' )  expr #exprBinary
    | expr ( 'or' | '||' )  expr #exprBinary
    | NAME  #exprId
    | NUMBER #exprNumber
    | STRING #exprString
    | CHAR #exprChar
    | BOOLEAN #exprBool
    ;

parameterList
    : expr (',' expr)*
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
WS : [ \t\r\n]+ -> skip ;
COMMENT_LINE : '//' ~[\r\n]* -> skip ;
COMMENT_BLOCK : '/*' .*? '*/' -> skip;