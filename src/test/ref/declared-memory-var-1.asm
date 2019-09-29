// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a pointer to a memory variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label idx_ptr = idx
  .label SCREEN = $400
  .label idx_p = 2
__bbegin:
  lda #0
  sta idx_ptr
  lda #<idx_ptr
  sta.z idx_p
  lda #>idx_ptr
  sta.z idx_p+1
  jsr main
  rts
main: {
    ldx #0
  __b1:
    ldy #0
    lda (idx_p),y
    sta SCREEN,x
    txa
    clc
    adc (idx_p),y
    sta (idx_p),y
    inx
    cpx #6
    bne __b1
    rts
}
  idx: .byte 0
