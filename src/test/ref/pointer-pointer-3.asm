// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label screen1 = $400
  .label screen2 = $400+$28
  .label screen = 4
__start: {
    // screen = $400
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
