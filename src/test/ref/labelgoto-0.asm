// Test labels/goto
// a few simple labels
  // Commodore 64 PRG executable file
.file [name="labelgoto-0.prg", type="prg", segments="Program"]
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
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc label3
    // SCREEN[40] = '*'
    lda #'*'
    sta SCREEN+$28
    // }
    rts
  label3:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
