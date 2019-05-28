// Minimal struct - two instances being used.
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label point1 = 2
  .label point2 = 4
bbegin:
  lda #0
  sta point1
  sta point1+1
  sta point2
  sta point2+1
  jsr main
  rts
main: {
    .label SCREEN = $400
    lda #2
    sta point1+0
    lda #3
    sta point1+1
    sta point2+0
    lda point1+0
    sta point2+1
    lda point2+0
    sta SCREEN
    lda point2+1
    sta SCREEN+1
    rts
}
