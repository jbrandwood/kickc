// Test access to __ma variable from inline ASM
  // Commodore 64 PRG executable file
.file [name="inline-asm-ma-var.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label value = 2
    // value = 0
    lda #0
    sta.z value
    tax
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // value += i
    txa
    clc
    adc.z value
    sta.z value
    // asm
    lda #$55
    eor value
    sta SCREEN
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
