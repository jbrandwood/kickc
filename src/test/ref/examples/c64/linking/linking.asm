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
.segment Code


  .label BG_COLOR = $d021
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // base[i] = i
    txa
    sta base,x
    // for(char i:0..255)
    inx
    cpx #0
    bne __b1
  __b2:
    // fillscreen(*BG_COLOR)
    lda BG_COLOR
    sta.z fillscreen.c
    jsr fillscreen
    // (*BG_COLOR)++;
    inc BG_COLOR
    jmp __b2
}
.segment CodeHigh
// fillscreen(byte zp(4) c)
fillscreen: {
    .label c = 4
    .label screen = 2
    ldx #0
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  __b1:
    // for( char *screen = SCREEN; screen<SCREEN+1000; screen++)
    lda.z screen+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z screen
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // c+base[i++]
    lda base,x
    clc
    adc.z c
    // *screen = c+base[i++]
    ldy #0
    sta (screen),y
    // *screen = c+base[i++];
    inx
    // for( char *screen = SCREEN; screen<SCREEN+1000; screen++)
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    jmp __b1
}
.segment DataHigh
  base: .fill $100, 0
