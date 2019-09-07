// KickC grammar
lexer grammar KickCLexer;

tokens { TYPEDEFNAME }

@header {
}

@members {

    /** The C-Parser. Used for importing C-files and communicating with the Parser about typedefs. */
    CParser cParser;
    /** True of the next string is the name of a C-file to import*/
    boolean importEnter = false;
    /** True if the next CURLY starts ASM_MODE */
    boolean asmEnter = false;
    /** Counts the nested curlies inside ASM_MODE to determine when to exit ASM_MODE */
    int asmCurlyCount = 0;

	public KickCLexer(CharStream input, CParser cParser) {
		this(input);
		this.cParser = cParser;
	}
}

// Special characters
CURLY_BEGIN: '{' { if(asmEnter) { pushMode(ASM_MODE); asmEnter=false; } }  ;
CURLY_END: '}' ;
BRACKET_BEGIN : '[' ;
BRACKET_END : ']' ;
PAR_BEGIN: '(' ;
PAR_END: ')' ;
SEMICOLON: ';' ;
COLON: ':';
COMMA: ',' ;
RANGE : '..' ;
CONDITION : '?' ;
DOT : '.' ;
ARROW : '->' ;
PLUS: '+';
MINUS: '-';
ASTERISK : '*' ;
DIVIDE : '/' ;
MODULO : '%' ;
INC : '++' ;
DEC : '--' ;
AND : '&' ;
BIT_NOT : '~' ;
BIT_XOR : '^' ;
BIT_OR : '|' ;
SHIFT_LEFT : '<<' ;
SHIFT_RIGHT : '>>' ;
EQUAL: '==' ;
NOT_EQUAL: '!=' ;
LESS_THAN: '<';
LESS_THAN_EQUAL: '<=';
GREATER_THAN_EQUAL: '>=';
GREATER_THAN : '>' ;
LOGIC_AND : '&&' ;
LOGIC_OR : '||' ;
ASSIGN: '=' ;
ASSIGN_COMPOUND : '+=' | '-=' | '*=' | '/=' | '%=' | '<<=' | '>>=' | '&=' | '|=' | '^=' ;

// Keywords
IMPORT: 'import' { importEnter=true; } ;
TYPEDEF: 'typedef' ;
PRAGMA: '#pragma' ;
RESERVE:'reserve' ;
PC:'pc';
TARGET:'target';
LINK:'link';
CPU:'cpu';
CODESEG:'code_seg';
DATASEG:'data_seg';
ENCODING:'encoding';
CONST: 'const' ;
EXTERN: 'extern' ;
EXPORT: 'export' ;
ALIGN: 'align' ;
REGISTER: 'register' ;
INLINE: 'inline' ;
VOLATILE: 'volatile' ;
INTERRUPT: 'interrupt' ;
IF: 'if' ;
ELSE: 'else' ;
WHILE: 'while' ;
DO: 'do' ;
FOR: 'for' ;
SWITCH: 'switch' ;
RETURN: 'return' ;
BREAK: 'break' ;
CONTINUE: 'continue' ;
ASM: 'asm' { asmEnter=true; };
DEFAULT : 'default' ;
CASE : 'case' ;
STRUCT : 'struct' ;
ENUM : 'enum' ;
SIZEOF : 'sizeof' ;
TYPEID : 'typeid' ;
KICKASM : 'kickasm' ;
RESOURCE : 'resource' ;
USES : 'uses' ;
CLOBBERS : 'clobbers' ;
BYTES : 'bytes' ;
CYCLES : 'cycles' ;
LOGIC_NOT : '!' ;
SIGNEDNESS : 'signed' | 'unsigned' ;
SIMPLETYPE: 'byte' | 'word' | 'dword' | 'bool' | 'char' | 'short' | 'int' | 'long' | 'void' ;
BOOLEAN : 'true' | 'false';
KICKASM_BODY: '{{' .*? '}}';


// Strings and chars - with special handling of imports
STRING : '"' ('\\"' | ~'"')* '"' [z]?([ps][mu]?)?[z]? { if(importEnter) { importEnter=false; cParser.loadCFile(getText()); } } ;
CHAR : '\''  ('\\'['"rfn] | ~'\'' ) '\'';

// Numbers
NUMBER : NUMFLOAT | NUMINT ;
NUMFLOAT : BINFLOAT | DECFLOAT | HEXFLOAT;
BINFLOAT : ('%' | '0b' | '0B' ) (BINDIGIT)* '.' BINDIGIT+;
DECFLOAT : (DECDIGIT)* '.' DECDIGIT+;
HEXFLOAT : ('$' | '0x' | '0X' ) (HEXDIGIT)* '.' HEXDIGIT+;
NUMINT : (DECINTEGER | HEXINTEGER | BININTEGER ) ([us][bcwisdl] | 'l')? ;
BININTEGER : '0' [bB] BINDIGIT+ | '%' BINDIGIT+ ;
DECINTEGER : DECDIGIT+ ;
HEXINTEGER : ( '$' | '0x' | '0X' ) HEXDIGIT+ ;
fragment BINDIGIT : [0-1];
fragment DECDIGIT : [0-9];
fragment HEXDIGIT : [0-9a-fA-F];

// Names
NAME : NAME_START NAME_CHAR* {if(cParser.isTypedef(getText())) setType(TYPEDEFNAME); };
fragment NAME_START : [a-zA-Z_];
fragment NAME_CHAR : [a-zA-Z0-9_];

// White space on hidden channel 1
WS : [ \t\r\n\u00a0]+ -> channel(1);
// Comments on hidden channel 2
COMMENT_LINE : '//' ~[\r\n]* -> channel(2);
COMMENT_BLOCK : '/*' .*? '*/' -> channel(2);


// MODE FOR INLINE ASSEMBLER

mode ASM_MODE;
ASM_BYTE : '.byte' ;
ASM_MNEMONIC:
    'brk' | 'ora' | 'kil' | 'slo' | 'nop' | 'asl' | 'php' | 'anc' | 'bpl' | 'clc' | 'jsr' | 'and' | 'rla' | 'bit' | 'rol' | 'pla' | 'plp' | 'bmi' | 'sec' |
    'rti' | 'eor' | 'sre' | 'lsr' | 'pha' | 'alr' | 'jmp' | 'bvc' | 'cli' | 'rts' | 'adc' | 'rra' | 'bvs' | 'sei' | 'sax' | 'sty' | 'sta' | 'stx' | 'dey' |
    'txa' | 'xaa' | 'bcc' | 'ahx' | 'tya' | 'txs' | 'tas' | 'shy' | 'shx' | 'ldy' | 'lda' | 'ldx' | 'lax' | 'tay' | 'tax' | 'bcs' | 'clv' | 'tsx' | 'las' |
    'cpy' | 'cmp' | 'cpx' | 'dcp' | 'dec' | 'inc' | 'axs' | 'bne' | 'cld' | 'sbc' | 'isc' | 'inx' | 'beq' | 'sed' | 'dex' | 'iny' | 'ror'
    ;

ASM_IMM : '#' ;
ASM_COLON : ':';
ASM_COMMA : ',' ;
ASM_PAR_BEGIN : '(' ;
ASM_PAR_END : ')' ;
ASM_BRACKET_BEGIN: '[' ;
ASM_BRACKET_END: ']' ;
ASM_DOT : '.' ;
ASM_SHIFT_LEFT : '<<' ;
ASM_SHIFT_RIGHT : '>>' ;
ASM_PLUS : '+' ;
ASM_MINUS : '-' ;
ASM_LESS_THAN : '<' ;
ASM_GREATER_THAN : '>' ;
ASM_MULTIPLY : '*' ;
ASM_DIVIDE : '/' ;
ASM_CURLY_BEGIN : '{' { asmCurlyCount++; };
ASM_CURLY_END : '}' { asmCurlyCount--; if(asmCurlyCount<0) { popMode(); } };

// Numbers
ASM_NUMBER : ASM_NUMFLOAT | ASM_NUMINT ;
ASM_NUMFLOAT : ASM_BINFLOAT | ASM_DECFLOAT | ASM_HEXFLOAT;
ASM_BINFLOAT : '%' (ASM_BINDIGIT)* '.' ASM_BINDIGIT+;
ASM_DECFLOAT : (ASM_DECDIGIT)* '.' ASM_DECDIGIT+;
ASM_HEXFLOAT : '$' (ASM_HEXDIGIT)* '.' ASM_HEXDIGIT+;
ASM_NUMINT : (ASM_DECINTEGER | ASM_HEXINTEGER | ASM_BININTEGER ) ;
ASM_BININTEGER : '%' ASM_BINDIGIT+ ;
ASM_DECINTEGER : ASM_DECDIGIT+ ;
ASM_HEXINTEGER : '$' ASM_HEXDIGIT+ ;
fragment ASM_BINDIGIT : [0-1];
fragment ASM_DECDIGIT : [0-9];
fragment ASM_HEXDIGIT : [0-9a-fA-F];

ASM_CHAR : '\''  ('\\'['"rfn] | ~'\'' ) '\'';

ASM_MULTI_REL: ASM_MULTI_NAME [+-]+ ;
ASM_MULTI_NAME : '!' ASM_NAME_CHAR* ;

//Names
ASM_NAME : ASM_NAME_START ASM_NAME_CHAR* ;
fragment ASM_NAME_START : [a-zA-Z_];
fragment ASM_NAME_CHAR : [a-zA-Z0-9_];

// White space on hidden channel 1
ASM_WS : [ \t\r\n\u00a0]+ -> channel(1);
// Comments on hidden channel 2
ASM_COMMENT_LINE : '//' ~[\r\n]* -> channel(2);
ASM_COMMENT_BLOCK : '/*' .*? '*/' -> channel(2);
