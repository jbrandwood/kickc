// Hello World for MEGA 65
.cpu _45gs02
  .file [name="hello-mega65.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$2001]
.segmentdef Code [start=$2017]
.segmentdef Data [startAfter="Code"]
.segment Basic
.byte $0a, $20, $0a, $00, $fe, $02, $20, $30, $00       // 10 BANK 0
.byte $15, $20, $14, $00, $9e, $20                      // 20 SYS 
.text toIntString(main)                                   //         NNNN
.byte $00, $00, $00                                     // 
  .label SCREEN = $800
  .label COLORS = $d800
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0;MSG[i];i++)
    lda MSG,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = MSG[i]
    lda MSG,x
    sta SCREEN,x
    // COLORS[i] = i
    txa
    sta COLORS,x
    // for(char i=0;MSG[i];i++)
    inx
    jmp __b1
}
.segment Data
  MSG: .text "hello world!"
  .byte 0
