// Test a procedure with calling convention stack
// Return value larger than parameter
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_SIGNED_WORD = 2
  .const STACK_BASE = $103
  .label current = 2
__bbegin:
  // current = 48
  lda #<$30
  sta.z current
  lda #>$30
  sta.z current+1
  jsr main
  rts
main: {
    .label __0 = 4
    .label __1 = 2
    // next()
    pha
    pha
    jsr next
    pla
    sta.z __0
    pla
    sta.z __0+1
    // SCREEN[0] = next()
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    // next()
    pha
    pha
    jsr next
    pla
    sta.z __1
    pla
    sta.z __1+1
    // SCREEN[1] = next()
    lda.z __1
    sta SCREEN+1*SIZEOF_SIGNED_WORD
    lda.z __1+1
    sta SCREEN+1*SIZEOF_SIGNED_WORD+1
    // }
    rts
}
next: {
    .const OFFSET_STACK_RETURN = 0
    .label return = 4
    // return current++;
    lda.z current
    sta.z return
    lda.z current+1
    sta.z return+1
    inc.z current
    bne !+
    inc.z current+1
  !:
    // }
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN+1,x
    rts
}
