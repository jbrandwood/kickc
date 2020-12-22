// Tests simple switch()-statement - including a continue statement for the enclosing loop
// Expected output 'a1aa1a' (numbers should be inverted)
  // Commodore 64 PRG executable file
.file [name="switch-1.prg", type="prg", segments="Program"]
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
    //                 SCREEN[i] = '1';
    //                 break;
    cpx #4
    beq __b2
    // SCREEN[i] = 'a'
    // No case for 0 & 5
    lda #'a'
    sta SCREEN,x
  __b5:
    // for(char i:0..5)
    inx
    cpx #6
    bne __b1
    // }
    rts
  __b2:
    // SCREEN[i] = '1'
    lda #'1'
    sta SCREEN,x
    // SCREEN[i] |= 0x80
    // Invert the screen character
    lda #$80
    ora SCREEN,x
    sta SCREEN,x
    jmp __b5
}
