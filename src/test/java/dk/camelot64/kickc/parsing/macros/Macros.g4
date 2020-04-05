/**
 * Minimal grammar implementing C macros
 */

grammar Macros;

@header {
}

@parser::members {
}

@lexer::members {
}

stmtSeq
    : stmt*
    ;

stmt
    : expr ';' #stmtExpr
    ;

expr
    :   PAR_BEGIN SIMPLETYPE PAR_END expr #exprCast
    |   IDENTIFIER #exprName
    |   NUMBER #exprNumber
    |   PAR_BEGIN expr PAR_END #exprPar
    |   expr '*' expr #exprBinary
    |   expr '/' expr #exprBinary
    |   expr '+' expr #exprBinary
    |   expr '-' expr #exprBinary
    |   expr COMMA expr #exprBinary
    ;

PAR_BEGIN: '(' ;
PAR_END: ')' ;
COMMA : ',' ;
SIMPLETYPE: 'char' | 'int' ;
IDENTIFIER: [a-zA-Z_][a-zA-Z_0-9]* ;
NUMBER: [0-9]+ ;
DEFINE: '#define' ;
UNDEF: '#undef' ;
IFDEF: '#ifdef' ;
IFNDEF: '#ifndef' ;
IFELSE: '#else' ;
ENDIF: '#endif' ;
DEFINE_CONTINUE: '\\\n' ;
WHITESPACE: [ \t\r\n]+ -> channel(1) ; // Send whitespace to the hidden WS channel
