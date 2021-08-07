// Test labels/goto
// goto a label nested in a loop
  // Commodore 64 PRG executable file
.file [name="labelgoto-5.prg", type="prg", segments="Program"]
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
  first:
    // SCREEN[40]++;
    inc SCREEN+$28
    // for(;i<10;i++)
    inx
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    sta SCREEN,x
    jmp first
}
