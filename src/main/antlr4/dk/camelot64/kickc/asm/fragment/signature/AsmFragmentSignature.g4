// Parser for AsmFragmentSignature from name

grammar AsmFragmentSignature;

signatures
    : signature*
    ;

signature
    : expr '=' expr #assignment
    | expr 'then' LABEL #conditionalJump
    | 'call' expr #call
    | 'isr' NAME* ( 'entry'|'exit') #isrRoutine
    | expr #exprSideEffect
    ;

expr
    : '(' expr ')' #par
    | 'deref' expr #derefSimple
    | expr 'derefidx' expr #derefIdx
    | expr ( 'band' | 'bor' | 'bxor' ) expr #binary
    | expr ( 'and' | 'or' ) expr #binary
    | expr ( 'rol' | 'ror' ) expr #binary
    | expr ( 'eq' | 'neq' | 'lt' | 'le' | 'gt' | 'ge' ) expr #binary
    | expr ( 'word' | 'dword' ) expr #binary
    | expr ( 'plus' | 'minus' ) expr #binary
    | 'neg' expr #unary
    | 'bnot' expr #unary
    | ( 'inc' | 'dec' ) expr #unary
    | ( 'byte' | 'sbyte' | 'word' | 'sword' | 'dword' | 'sdword' ) expr #unary
    | ( 'byte0' | 'byte1' | 'byte2' | 'byte3' | 'word0' | 'word1') expr #unary
    | expr ( 'setbyte0' | 'setbyte1' | 'setbyte2' | 'setbyte3' | 'setword0' | 'setword1' ) expr #binary
    | expr 'memcpy' expr #memcpy
    | 'memset' expr #memset
    | 'stackpushpadding' NUM #stackPushPadding
    | 'stackpullpadding' NUM #stackPullPadding
    | ( 'stackidxbyte' | 'stackidxsbyte' | 'stackidxword' | 'stackidxsword' | 'stackidxdword' | 'stackidxsdword' | 'stackidxptr') expr #stackIdx
    | ( 'stackpushbyte' | 'stackpushsbyte' | 'stackpushword' | 'stackpushsword' | 'stackpushdword' | 'stackpushsdword' | 'stackpushptr') #stackPush
    | ( 'stackpullbyte' | 'stackpullsbyte' | 'stackpullword' | 'stackpullsword' | 'stackpulldword' | 'stackpullsdword' | 'stackpullptr') #stackPull
    | 'stackidxstruct' expr expr #stackIdxStruct
    | 'stackpushstruct' expr #stackPushStruct
    | 'stackpullstruct' expr #stackPullStruct
    | 'makelong4' '(' expr ')' '(' expr ')' '(' expr ')' '(' expr ')' #makelong4
    | VAR #var
    | NUM #num
    ;

NUM     : [0-9][0-9]?;
VAR     : [vpq][bwdpsv][usor][czmaxy][0-9axyz] ;
LABEL   : [l][a][0-9] ;
NAME    : [a-z][a-z0-9]+ ;
WHITESPACE : [_\n]+ -> skip ;
