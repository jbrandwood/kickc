// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded zero-page address - global variable
  // Commodore 64 PRG executable file
.file [name="address-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label i = 2
.segment Code
__start: {
    // i = 3
    lda #3
    sta.z i
    jsr main
    rts
}
main: {
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
