// Test MAKEWORD()
  // Commodore 64 PRG executable file
.file [name="makeword-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label i = 2
    ldx #0
  __b1:
    // for(char lo=0;lo<100;lo++)
    cpx #$64
    bcc __b4
    // }
    rts
  __b4:
    ldy #0
  __b2:
    // for(char hi=0;hi<100;hi++)
    cpy #$64
    bcc __b3
    // for(char lo=0;lo<100;lo++)
    inx
    jmp __b1
  __b3:
    // unsigned int i = MAKEWORD(hi, lo)
    sty.z i+1
    stx.z i
    // *SCREEN = i
    txa
    sta SCREEN
    tya
    sta SCREEN+1
    // for(char hi=0;hi<100;hi++)
    iny
    jmp __b2
}
