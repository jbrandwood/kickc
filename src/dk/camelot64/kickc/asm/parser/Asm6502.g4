// 6502 Assembler Grammar
grammar Asm6502;

file
    : line ( '\n' line)* EOF
    ;

line
    : label? instruction? comment?
    ;

label
    : NAME ':'
    ;

comment
    : '//' .*?
    ;

instruction
    : MNEMONIC (paramMode)?
    ;

paramMode
    : expr #modeAbs
    | '#' expr #modeImm
    | expr ',x' #modeAbsX
    | expr ',y' #modeAbsY
    | '(' expr ')' ',y' #modeIndY
    | '(' expr ',x' ')'  #modeIndX
    | '(' expr ')'  #modeInd
    ;

expr
    : ('+' | '-' | '<' | '>') expr #exprUnary
    | expr ('*' | '/' ) expr #exprBinary
    | expr ( '+' | '-')  expr #exprBinary
    | NAME #exprLabel
    | '{' NAME '}' #exprReplace
    | NUMINT #exprInt
    ;

MNEMONIC: [A-Za-z][A-Za-z][A-Za-z];
NUMINT : DECINTEGER | HEXINTEGER | BININTEGER ;
BININTEGER : '0' [bB] BINDIGIT+ | '%' BINDIGIT+ ;
DECINTEGER : DECDIGIT+ ;
HEXINTEGER : ( '$' | '0x' | '0X' ) HEXDIGIT+ ;
fragment BINDIGIT : [0-1];
fragment DECDIGIT : [0-9];
fragment HEXDIGIT : [0-9a-fA-F];
NAME : NAME_START NAME_CHAR* [+-]* ;
fragment NAME_START : [!a-zA-Z_];
fragment NAME_CHAR : [a-zA-Z0-9_];
WS : [ \t\r]+ -> skip ; // skip spaces, tabs