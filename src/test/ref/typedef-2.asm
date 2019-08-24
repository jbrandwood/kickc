.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label ptr = 2
bbegin:
  lda #<$1000
  sta.z ptr
  lda #>$1000
  sta.z ptr+1
  jsr main
  rts
main: {
    lda #<ptr+$32
    sta SCREEN
    rts
}
