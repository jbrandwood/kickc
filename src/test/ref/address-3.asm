// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem address - local variable
  // Commodore 64 PRG executable file
.file [name="address-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i = $2000
    // char __address(0x2000) i = 3
    lda #3
    sta i
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
