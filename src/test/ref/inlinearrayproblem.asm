// Arrays / strings allocated inline destroy functions (because they are allocated where the call enters.
// The following places the text at the start of the main-function - and JSR's straight into the text - not the code.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label SCREEN2 = $400+$28
main: {
    ldx #0
  __b1:
    lda txt,x
    sta SCREEN,x
    lda data,x
    sta SCREEN2,x
    inx
    cpx #4
    bne __b1
    rts
    txt: .text "qwe"
    data: .byte 1, 2, 3
}
