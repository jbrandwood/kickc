// Tests declaring a (constant) variable as __notconst
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label size = 2
  .label SCREEN = 3
__bbegin:
  lda #$28
  sta.z size
  lda #<$400
  sta.z SCREEN
  lda #>$400
  sta.z SCREEN+1
  jsr main
  rts
main: {
    ldy #0
  __b1:
    cpy.z size
    bcc __b2
    rts
  __b2:
    lda #'*'
    sta (SCREEN),y
    iny
    jmp __b1
}
