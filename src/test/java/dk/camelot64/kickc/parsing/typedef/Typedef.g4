/**
 *
 * Minimal grammar illustrating the C typedef ambiguity problem
 * (x)&y can have two meanings:
 * - cast address-of y to type x
 * - binary and of x and y
 *
 * Resolving the ambiguity requires the compiler to know whether x is a type or a value.
 * This is handled using predicates during the Lexer Phase to create different tokens (IDENTIFIER vs TYPEDEF)
 */

grammar Typedef;

@header {
    import java.util.ArrayList;
    import java.util.List;
}

@parser::members {
    List<String> typedefs;

	public TypedefParser(TokenStream input, List<String> typedefs) {
		this(input);
		this.typedefs = typedefs;
	}

}

@lexer::members {
    List<String> typedefs;

	public TypedefLexer(CharStream input, List<String> typedefs) {
		this(input);
		this.typedefs = typedefs;
	}

}

stmtSeq
    : stmt*
    ;

stmt
    : 'typedef' typeName IDENTIFIER ';' { typedefs.add($IDENTIFIER.text);} #stmtTypeDef
    | expr ';' #stmtExpr
    ;

expr
    :   '(' typeName ')' expr #exprCast
    |   IDENTIFIER #exprValueName
    |   '(' expr ')' #exprParenthesis
    |   '&' expr #exprAddressOf
    |   expr '&' expr #exprAnd
    ;

typeName
    :   SIMPLETYPE #typeNameSimple
    |   TYPEIDENTIFIER #typeNameTypedef
    ;

SIMPLETYPE: 'char' | 'int';
IDENTIFIER: [a-zA-Z_]+ {!typedefs.contains(getText())}?;
TYPEIDENTIFIER: [a-zA-Z_]+ {typedefs.contains(getText())}?;
WHITESPACE
    :   [ \t\r\n]+
        -> skip
    ;
