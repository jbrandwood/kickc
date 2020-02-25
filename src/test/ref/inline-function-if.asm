// Test inlining a slightly complex print function (containing an if)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .const toUpper1_ch = 'c'
    .const toUpper2_ch = 'm'
    .const toUpper1_return = toUpper1_ch+$40
    // screen[0] = toUpper('c',true)
    lda #toUpper1_return
    sta screen
    // screen[1] = toUpper('m',false)
    lda #toUpper2_ch
    sta screen+1
    // }
    rts
}
