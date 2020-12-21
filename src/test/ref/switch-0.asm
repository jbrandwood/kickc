// Tests simple switch()-statement
// Expected output 'd1444d'
  // Commodore 64 PRG executable file
.file [name="switch-0.prg", type="prg", segments="Program"]
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
    //                 // A simple case with a break
    //                 SCREEN[i] = '1';
    //                 break;
    cpx #1
    beq __b2
    // case 2:
    cpx #2
    beq __b3
    // case 3:
    //                 // A case with fall-through
    //                 SCREEN[i] = '3';
    // A case with no body
    cpx #3
    beq __b3
    // case 4:
    //                 SCREEN[i] = '4';
    //                 break;
    cpx #4
    beq __b4
    // SCREEN[i] = 'd'
    // No case for 0 & 5
    lda #'d'
    sta SCREEN,x
  __b6:
    // for(char i:0..5)
    inx
    cpx #6
    bne __b1
    // }
    rts
  __b4:
    // SCREEN[i] = '4'
    lda #'4'
    sta SCREEN,x
    jmp __b6
  __b3:
    // SCREEN[i] = '3'
    // A case with fall-through
    lda #'3'
    sta SCREEN,x
    jmp __b4
  __b2:
    // SCREEN[i] = '1'
    // A simple case with a break
    lda #'1'
    sta SCREEN,x
    jmp __b6
}
