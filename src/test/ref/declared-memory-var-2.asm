// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable containing a pointer
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label cursor_ptr = cursor
  .label SCREEN = $400
__bbegin:
  lda #<SCREEN
  sta cursor_ptr
  lda #>SCREEN
  sta cursor_ptr+1
  jsr main
  rts
main: {
    ldx #0
  __b1:
    lda #'*'
    ldy cursor_ptr
    sty.z $fe
    ldy cursor_ptr+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    lda cursor_ptr
    clc
    adc #$29
    sta cursor_ptr
    lda cursor_ptr+1
    adc #0
    sta cursor_ptr+1
    inx
    cpx #$19
    bne __b1
    rts
}
  cursor: .word 0
