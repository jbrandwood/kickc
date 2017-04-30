// Define a grammar called Hello
grammar KickC;
expr :
        NUMBER |
        NAME |
        '(' expr ')' |
        ('+' | '-') expr |
        expr ( '*' | '/' ) expr  |
        expr ( '+' | '-' ) expr ;
NAME : NAME_START NAME_CHAR* ;
fragment NAME_START : [a-zA-Z_];
fragment NAME_CHAR : [a-zA-Z0-9_];
NUMBER : FLOAT | DECINTEGER | HEXINTEGER | BININTEGER ;
FLOAT : (DECDIGIT)* '.' DECDIGIT+;
DECINTEGER : DECDIGIT+ ;
fragment DECDIGIT : [0-9];
HEXINTEGER : '0' [xX] HEXDIGIT+ | '$' HEXDIGIT+ ;
fragment HEXDIGIT : [0-9a-fA-F];
BININTEGER : '0' [bB] BINDIGIT+ | '%' BINDIGIT+ ;
fragment BINDIGIT : [0-1];
WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines