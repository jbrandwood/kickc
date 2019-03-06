// Tests uninitialized values of variables.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const b = 0
  .const w = 0
  .label ptr = 0
  .label SCREEN = $400
main: {
    lda #b
    sta SCREEN
    lda #<w
    sta SCREEN+2
    lda #>w
    sta SCREEN+3
    lda #<ptr
    sta SCREEN+5
    lda #>ptr
    sta SCREEN+5
    rts
}
