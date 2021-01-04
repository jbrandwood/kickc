// Demonstrates error with nested ternary operator
  // Commodore 64 PRG executable file
.file [name="sandbox-ternary-error.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (b == 0) ? 'a' : ((b == 1) ? 'b' : 'c')
    cpx #0
    beq __b2
    // (b == 1) ? 'b' : 'c'
    cpx #1
    beq __b4
    lda #'c'
    jmp __b3
  __b4:
    // (b == 1) ? 'b' : 'c'
    lda #'b'
    // (b == 0) ? 'a' : ((b == 1) ? 'b' : 'c')
    jmp __b3
  __b2:
    lda #'a'
  __b3:
    // *SCREEN = (b == 0) ? 'a' : ((b == 1) ? 'b' : 'c')
    sta SCREEN
    // for ( byte b: 0..2 )
    inx
    cpx #3
    bne __b1
    // }
    rts
}
