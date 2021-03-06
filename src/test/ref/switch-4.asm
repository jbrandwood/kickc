// Tests simple switch()-statement - switch without default
// Expected output " 1  4 "
  // Commodore 64 PRG executable file
.file [name="switch-4.prg", type="prg", segments="Program"]
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
    // case 1:
    cpx #1
    beq __b2
    // case 4:
    //                 SCREEN[i] = '0'+i;
    //                 break;
    cpx #4
    bne __b3
  __b2:
    // '0'+i
    txa
    clc
    adc #'0'
    // SCREEN[i] = '0'+i
    sta SCREEN,x
  __b3:
    // for(char i:0..5)
    inx
    cpx #6
    bne __b1
    // }
    rts
}
