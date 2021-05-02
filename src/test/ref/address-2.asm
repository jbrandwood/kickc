// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem-page address - global variable
  // Commodore 64 PRG executable file
.file [name="address-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label i = $2000
.segment Code
__start: {
    // char __address(0x2000) i = 3
    lda #3
    sta i
    jsr main
    rts
}
main: {
  __b1:
    // while(i<7)
    lda i
    cmp #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = i
    ldy i
    tya
    sta SCREEN,y
    // SCREEN[i++] = i;
    inc i
    jmp __b1
}
