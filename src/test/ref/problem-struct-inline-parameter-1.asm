// Illustrates problem with passing an inline struct value as a parameter
  // Commodore 64 PRG executable file
.file [name="problem-struct-inline-parameter-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // print('c', { '-', '-' } )
    jsr print
    // }
    rts
}
// void print(char c, char fmt_prefix, char fmt_postfix)
print: {
    .const c = 'c'
    .const fmt_prefix = '-'
    .const fmt_postfix = '-'
    // SCREEN[idx++] = fmt.prefix
    lda #fmt_prefix
    sta SCREEN
    // SCREEN[idx++] = c
    lda #c
    sta SCREEN+1
    // SCREEN[idx++] = fmt.postfix
    lda #fmt_postfix
    sta SCREEN+2
    // }
    rts
}
