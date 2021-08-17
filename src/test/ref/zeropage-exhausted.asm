// Tests warning when running out of zeropage-addresses for variables
  // Commodore 64 PRG executable file
.file [name="zeropage-exhausted.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
// And then allocate a 2-byte-variable
main: {
    .label SCREEN = $400
    lda #<0
    sta i
    sta i+1
  __b1:
    // for(__zp int i=0;i<10;i++)
    lda i+1
    bmi __b2
    cmp #>$a
    bcc __b2
    bne !+
    lda i
    cmp #<$a
    bcc __b2
  !:
    // }
    rts
  __b2:
    // SCREEN[(char)i] = i
    lda i
    asl
    tay
    lda i
    sta SCREEN,y
    lda i+1
    sta SCREEN+1,y
    // for(__zp int i=0;i<10;i++)
    inc i
    bne !+
    inc i+1
  !:
    jmp __b1
  .segment Data
    i: .word 0
}
