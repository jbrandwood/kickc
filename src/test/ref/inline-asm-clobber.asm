// Tests that inline ASM clobbering is taken into account when assigning registers
  // Commodore 64 PRG executable file
.file [name="inline-asm-clobber.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label l = 2
    ldx #0
  // First loop with no clobber
  __b1:
    lda #0
  __b2:
    // SCREEN[i] = j
    sta SCREEN,x
    // for(byte j: 0..100)
    clc
    adc #1
    cmp #$65
    bne __b2
    // for(byte i : 0..100)
    inx
    cpx #$65
    bne __b1
    ldy #0
  // Then loop with clobbering A&X
  __b4:
    lda #0
    sta.z l
  __b5:
    // asm
    eor #$55
    tax
    // SCREEN[k] = l
    lda.z l
    sta SCREEN,y
    // for(byte l: 0..100)
    inc.z l
    lda #$65
    cmp.z l
    bne __b5
    // for(byte k : 0..100)
    iny
    cpy #$65
    bne __b4
    // }
    rts
}
