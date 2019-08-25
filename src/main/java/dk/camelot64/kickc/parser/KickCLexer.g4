// KickC grammar
lexer grammar KickCLexer;

tokens { TYPEDEFNAME }

@header {
}

@lexer::members {
    CParser cParser;

	public KickCLexer(CharStream input, CParser cParser) {
		this(input);
		this.cParser = cParser;
	}
}

CURLY_BEGIN: '{' ;
CURLY_END: '}' ;
BRACKET_BEGIN : '[' ;
BRACKET_END : ']' ;
PAR_BEGIN: '(' ;
PAR_END: ')' ;
SEMICOLON: ';' ;
COLON: ':';
COMMA: ',' ;
RANGE : '..' ;
QUESTION : '?' ;
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
ASM_IMM : '#' ;

TYPEDEF: 'typedef' ;
PRAGMA: '#pragma' ;
RESERVE:'reserve' ;
PC:'pc';
TARGET:'target';
LINK:'link';
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
ASM: 'asm' ;
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
ASM_BYTE : '.byte' ;
SIGNEDNESS : 'signed' | 'unsigned' ;
ASM_MNEMONIC:
    'brk' | 'ora' | 'kil' | 'slo' | 'nop' | 'asl' | 'php' | 'anc' | 'bpl' | 'clc' | 'jsr' | 'and' | 'rla' | 'bit' | 'rol' | 'pla' | 'plp' | 'bmi' | 'sec' |
    'rti' | 'eor' | 'sre' | 'lsr' | 'pha' | 'alr' | 'jmp' | 'bvc' | 'cli' | 'rts' | 'adc' | 'rra' | 'bvs' | 'sei' | 'sax' | 'sty' | 'sta' | 'stx' | 'dey' |
    'txa' | 'xaa' | 'bcc' | 'ahx' | 'tya' | 'txs' | 'tas' | 'shy' | 'shx' | 'ldy' | 'lda' | 'ldx' | 'lax' | 'tay' | 'tax' | 'bcs' | 'clv' | 'tsx' | 'las' |
    'cpy' | 'cmp' | 'cpx' | 'dcp' | 'dec' | 'inc' | 'axs' | 'bne' | 'cld' | 'sbc' | 'isc' | 'inx' | 'beq' | 'sed' | 'dex' | 'iny' | 'ror'
    ;
IMPORT: 'import' { cParser.setModeImport(true); } ;
SIMPLETYPE: 'byte' | 'word' | 'dword' | 'bool' | 'char' | 'short' | 'int' | 'long' | 'void' ;
STRING : '"' ('\\"' | ~'"')* '"' [z]?([ps][mu]?)?[z]? { if(cParser.isModeImport()) { cParser.setModeImport(false); cParser.loadCFile(getText()); } } ;
CHAR : '\''  ('\\'['"rfn] | ~'\'' ) '\'';
BOOLEAN : 'true' | 'false';
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
NAME : NAME_START NAME_CHAR* {if(cParser.isTypedef(getText())) setType(TYPEDEFNAME); };
fragment NAME_START : [a-zA-Z_];
fragment NAME_CHAR : [a-zA-Z0-9_];
ASMREL: '!' NAME_CHAR* [+-]+ {cParser.isModeAsm()}? ;
KICKASM_BODY: '{{' .*? '}}';

// Add white space to the hidden channel 1
WS : [ \t\r\n\u00a0]+ -> channel(1);
// Add comments to the hidden channel 2
COMMENT_LINE : '//' ~[\r\n]* -> channel(2);
COMMENT_BLOCK : '/*' .*? '*/' -> channel(2);