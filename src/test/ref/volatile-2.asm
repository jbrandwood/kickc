// Test that volatile const vars are turned into load/store
  // Commodore 64 PRG executable file
.file [name="volatile-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label ch = 2
.segment Code
__start: {
    // ch = 3
    lda #3
    sta.z ch
    jsr main
    rts
}
main: {
    ldx #3
  __b1:
    // while(i<7)
    cpx #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = ch
    lda.z ch
    sta SCREEN,x
    // SCREEN[i++] = ch;
    inx
    jmp __b1
}
