// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label screen1 = $400
  .label screen2 = $400+$28
  .label screen = 6
bbegin:
  lda #<$400
  sta screen
  lda #>$400
  sta screen+1
  jsr main
  rts
main: {
    lda #<screen
    sta setscreen.screen
    lda #>screen
    sta setscreen.screen+1
    lda #<screen1
    sta setscreen.val
    lda #>screen1
    sta setscreen.val+1
    jsr setscreen
    lda #'a'
    ldy #0
    sta (screen),y
    lda #<screen
    sta setscreen.screen
    lda #>screen
    sta setscreen.screen+1
    lda #<screen2
    sta setscreen.val
    lda #>screen2
    sta setscreen.val+1
    jsr setscreen
    lda #'a'
    ldy #0
    sta (screen),y
    rts
}
// setscreen(byte** zeropage(4) screen, byte* zeropage(2) val)
setscreen: {
    .label val = 2
    .label screen = 4
    ldy #0
    lda val
    sta (screen),y
    iny
    lda val+1
    sta (screen),y
    rts
}
