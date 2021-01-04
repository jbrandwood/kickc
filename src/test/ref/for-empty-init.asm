// Tests that for()-loops can have empty inits
  // Commodore 64 PRG executable file
.file [name="for-empty-init.prg", type="prg", segments="Program"]
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
    // for(;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // for(;i<10;i++)
    inx
    jmp __b1
}
