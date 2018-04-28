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
    : directive* typeDecl directive* NAME ;

declVar
    :  directive* typeDecl directive* NAME ('=' expr)? ';'
    ;

directive
    : 'const' #directiveConst
    | 'align' '(' NUMBER ')' #directiveAlign
    | 'register' '(' NAME ')' #directiveRegister
    ;

stmtSeq
    : stmt+
    ;

stmt
    : declVar #stmtDeclVar
    | '{' stmtSeq? '}' #stmtBlock
    | expr  ';' #stmtExpr
    | 'if' '(' expr ')' stmt ( 'else' stmt )? #stmtIfElse
    | 'while' '(' expr ')' stmt  #stmtWhile
    | 'do' stmt 'while' '(' expr ')' ';' #stmtDoWhile
    | 'for' '(' forDeclaration? forIteration ')' stmt  #stmtFor
    | 'return' expr? ';' #stmtReturn
    | 'asm' '{' asmLines '}' #stmtAsm
    ;

forDeclaration
    : directive* typeDecl? directive* NAME ('=' expr)? #forDecl
    ;

forIteration
    : ';' expr ';' expr # forClassic
    | ':' expr ( '..' ) expr #forRange
    ;

typeDecl
    : SIMPLETYPE  #typeSimple
    | 'signed' SIMPLETYPE  #typeSignedSimple
    | typeDecl '*' #typePtr
    | typeDecl '[' (expr)? ']' #typeArray
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