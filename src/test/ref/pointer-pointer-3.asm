// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label screen1 = $400
  .label screen2 = $400+$28
  .label screen = 4
__bbegin:
  lda #<$400
  sta.z screen
  lda #>$400
  sta.z screen+1
  jsr main
  rts
main: {
    lda #<screen1
    sta.z setscreen.val
    lda #>screen1
    sta.z setscreen.val+1
    jsr setscreen
    lda #'a'
    ldy #0
    sta (screen),y
    lda #<screen2
    sta.z setscreen.val
    lda #>screen2
    sta.z setscreen.val+1
    jsr setscreen
    lda #'a'
    ldy #0
    sta (screen),y
    rts
}
// setscreen(byte* zp(2) val)
setscreen: {
    .label val = 2
    lda.z val
    sta.z screen
    lda.z val+1
    sta.z screen+1
    rts
}
