// Test a procedure with calling convention stack
// Return value larger than parameter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
  .label SCREEN = $400
  .const STACK_BASE = $103
  .label current = 2
main: {
    .label __0 = 2
    .label __1 = 4
    pha
    pha
    jsr next
    pla
    sta.z __0
    pla
    sta.z __0+1
    lda.z __0
    sta SCREEN
    lda.z __0+1
    sta SCREEN+1
    pha
    pha
    jsr next
    pla
    sta.z __1
    pla
    sta.z __1+1
    lda.z __1
    sta SCREEN+1*SIZEOF_SIGNED_WORD
    lda.z __1+1
    sta SCREEN+1*SIZEOF_SIGNED_WORD+1
    rts
}
next: {
    .const OFFSET_STACK_RETURN = 0
    .label return = 2
    tsx
    lda.z return
    sta STACK_BASE+OFFSET_STACK_RETURN,x
    lda.z return+1
    sta STACK_BASE+OFFSET_STACK_RETURN+1,x
    rts
}
