// Test a function taking boolean parameter and returning boolean result
  // Commodore 64 PRG executable file
.file [name="bool-function.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // isSet(i, (i&1)==0)
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    tay
    txa
    jsr isSet
    // if( isSet(i, (i&1)==0))
    cmp #0
    bne __b2
    // screen[i] = ' '
    lda #' '
    sta screen,x
  __b3:
    // for(byte i: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
  __b2:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
    jmp __b3
}
// Determine whether to set a char to '*.
// Returns true if i&8!=0 or b=true
// __register(A) bool isSet(__register(A) char i, __register(Y) bool b)
isSet: {
    // i&8
    and #8
    // (i&8)!=0
    eor #0
    beq !+
    lda #1
  !:
    // b || ((i&8)!=0)
    sty.z $ff
    ora.z $ff
    // }
    rts
}
