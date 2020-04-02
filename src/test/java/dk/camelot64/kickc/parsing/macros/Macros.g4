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
    :   '(' SIMPLETYPE ')' expr #exprCast
    |   IDENTIFIER #exprName
    |   NUMBER #exprNumber
    |   '(' expr ')' #exprPar
    |   expr '*' expr #exprBinary
    |   expr '/' expr #exprBinary
    |   expr '+' expr #exprBinary
    |   expr '-' expr #exprBinary
    ;

SIMPLETYPE: 'char' | 'int' ;
IDENTIFIER: [a-zA-Z_]+ ;
NUMBER: [0-9]+ ;
DEFINE: '#define' ;
DEFINE_CONTINUE: '\\\n' ;
WHITESPACE: [ \t\r\n]+ -> channel(1) ; // Send whitespace to the hidden WS channel
