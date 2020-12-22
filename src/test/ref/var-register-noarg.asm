// Test declaring a variable as register with no information about which register (for compatibility with standard C)
  // Commodore 64 PRG executable file
.file [name="var-register-noarg.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // while(i<40*4)
    cpx #$28*4
    bcc __b2
    // }
    rts
  __b2:
    // i&7
    txa
    and #7
    // SCREEN[i++] = MSG[i&7]
    tay
    lda MSG,y
    sta SCREEN,x
    // SCREEN[i++] = MSG[i&7];
    inx
    jmp __b1
}
.segment Data
.encoding "screencode_upper"
  MSG: .text "CAMELOT!"
  .byte 0
