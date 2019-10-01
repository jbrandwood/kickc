// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable containing a pointer
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
__bbegin:
  lda #<SCREEN
  sta cursor
  lda #>SCREEN
  sta cursor+1
  jsr main
  rts
main: {
    ldx #0
  __b1:
    lda #'*'
    ldy cursor
    sty.z $fe
    ldy cursor+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    lda #$29
    clc
    adc cursor
    sta cursor
    bcc !+
    inc cursor+1
  !:
    inx
    cpx #$19
    bne __b1
    rts
}
  cursor: .word 0
