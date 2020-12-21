// Test that volatile vars are turned into load/store
  // Commodore 64 PRG executable file
.file [name="volatile-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    // i = 3
    lda #3
    sta.z i
  __b1:
    // while(i<7)
    lda.z i
    cmp #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = i
    ldy.z i
    tya
    sta SCREEN,y
    // SCREEN[i++] = i;
    inc.z i
    jmp __b1
}
