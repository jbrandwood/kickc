// Tests pointer to pointer in a more complex setup
  // Commodore 64 PRG executable file
.file [name="pointer-pointer-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label screen1 = $400
  .label screen2 = $400+$28
  .label screen = 4
.segment Code
__start: {
    // byte* screen = (char*)$400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    jsr main
    rts
}
main: {
    // setscreen(&screen, screen1)
    lda #<screen1
    sta.z setscreen.val
    lda #>screen1
    sta.z setscreen.val+1
    jsr setscreen
    // screen[0] = 'a'
    lda #'a'
    ldy #0
    sta (screen),y
    // setscreen(&screen, screen2)
    lda #<screen2
    sta.z setscreen.val
    lda #>screen2
    sta.z setscreen.val+1
    jsr setscreen
    // screen[0] = 'a'
    lda #'a'
    ldy #0
    sta (screen),y
    // }
    rts
}
// setscreen(byte* zp(2) val)
setscreen: {
    .label val = 2
    // *screen = val
    lda.z val
    sta.z @screen
    lda.z val+1
    sta.z @screen+1
    // }
    rts
}
