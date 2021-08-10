// Multiple calls with different (constant?) parameters should yield different values at runtime
// Currently the same constant parameter is passed on every call.
// Reason: Multiple versioned parameter constants x0#0, x0#1 are only output as a single constant in the ASM .const x0 = 0
  // Commodore 64 PRG executable file
.file [name="callconstparam.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 3
.segment Code
main: {
    // line(1,2)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #2
    sta.z line.x1
    ldx #1
    jsr line
    // line(3,5)
    lda #5
    sta.z line.x1
    ldx #3
    jsr line
    // }
    rts
}
// void line(char x0, __zp(2) char x1)
line: {
    .label x1 = 2
  __b1:
    // for(byte x  = x0; x<x1; x++)
    cpx.z x1
    bcc __b2
    // }
    rts
  __b2:
    // *screen = x
    txa
    ldy #0
    sta (screen),y
    // screen++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for(byte x  = x0; x<x1; x++)
    inx
    jmp __b1
}
