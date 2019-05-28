// Minimal struct - declaration, instantiation and usage
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label point = 2
bbegin:
  lda #0
  sta point
  sta point+1
  jsr main
  rts
main: {
    .label SCREEN = $400
    lda #2
    sta point+0
    lda #3
    sta point+1
    lda point+0
    sta SCREEN
    lda point+1
    sta SCREEN+1
    rts
}
