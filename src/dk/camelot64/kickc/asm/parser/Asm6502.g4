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
    : param #modeAbs
    | '#' param #modeImm
    | param ',x' #modeAbsX
    | param ',y' #modeAbsY
    | '(' param ')' ',y' #modeIndY
    | '(' param ',x' ')'  #modeIndX
    | '(' param ')'  #modeInd
    ;

param
    : NAME #paramLabel
    | '{' NAME '}' #paramReplace
    | NUMINT #paramInt
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