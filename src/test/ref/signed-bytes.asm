  // Commodore 64 PRG executable file
.file [name="signed-bytes.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldy #0
    ldx #-$7f
  __b1:
    // while(i<127)
    txa
    sec
    sbc #$7f
    bvc !+
    eor #$80
  !:
    bmi __b2
    // }
    rts
  __b2:
    // screen[j] = (byte)i
    txa
    sta screen,y
    // i++;
    inx
    // j++;
    iny
    jmp __b1
}
