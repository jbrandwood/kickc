// Test legal definition of multiple local variables with the same name
  // Commodore 64 PRG executable file
.file [name="cstyle-decl-var-multiple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
// And a little code using them
main: {
    .label c1 = 2
    lda #0
    sta.z c1
    tay
  __b1:
    ldx #0
  __b2:
    // SCREEN[idx++] = '*'
    lda #'*'
    sta SCREEN,y
    // SCREEN[idx++] = '*';
    iny
    // for( char c: 0..10)
    inx
    cpx #$b
    bne __b2
    inc.z c1
    lda #$b
    cmp.z c1
    bne __b1
    // }
    rts
}
