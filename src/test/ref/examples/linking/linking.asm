// Example showing how to perform linking using a linker-file
// The linker file is created using KickAssembler segments.
// See the KickAssembler manual for description of the format http://theweb.dk/KickAssembler/
// Specifying the linker script file is done using the #pragma link(<file>)
// It can also be specified using kickc command line option -T <file>
  .file [name="linking.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data, CodeHigh, DataHigh"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$0810]
.segmentdef Data [startAfter="Code"]
.segmentdef CodeHigh [start=$4000]
.segmentdef DataHigh [startAfter="CodeHigh"]
.segment Basic
:BasicUpstart(main)


  .label BGCOL = $d021
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  b1:
    txa
    sta base,x
    inx
    cpx #0
    bne b1
  b2:
    lda BGCOL
    sta.z fillscreen.c
    jsr fillscreen
    inc BGCOL
    jmp b2
}
.segment CodeHigh
// fillscreen(byte zeropage(4) c)
fillscreen: {
    .label c = 4
    .label screen = 2
    ldx #0
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  b2:
    lda base,x
    clc
    adc.z c
    ldy #0
    sta (screen),y
    inx
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda.z screen+1
    cmp #>SCREEN+$3e8
    bcc b2
    bne !+
    lda.z screen
    cmp #<SCREEN+$3e8
    bcc b2
  !:
    rts
}
.segment DataHigh
  base: .fill $100, 0
