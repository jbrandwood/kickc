// Test declaring a variable as at a hard-coded address
// Incrementing a load/store variable will result in cause two *SIZEOF's
  // Commodore 64 PRG executable file
.file [name="address-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const ch = $102
    .label i = 2
    // __address(0x2) char i=0
    lda #0
    sta.z i
  __b1:
    // while(i<8)
    lda.z i
    cmp #8
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = ch
    lda.z i
    asl
    tay
    lda #<ch
    sta SCREEN,y
    lda #>ch
    sta SCREEN+1,y
    // SCREEN[i++] = ch;
    inc.z i
    // SCREEN[i++] = ch
    lda.z i
    asl
    tay
    lda #<ch
    sta SCREEN,y
    lda #>ch
    sta SCREEN+1,y
    // SCREEN[i++] = ch;
    inc.z i
    jmp __b1
}
