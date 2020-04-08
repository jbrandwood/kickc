// Test declarations without body
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
// Definition of main()
main: {
    // sum('a', 2)
    lda #2
    ldx #'a'
    jsr sum
    // sum('a', 2)
    // SCREEN[0] = sum('a', 2)
    sta SCREEN
    // sum('a', 12)
    lda #$c
    ldx #'a'
    jsr sum
    // sum('a', 12)
    // SCREEN[1] = sum('a', 12)
    sta SCREEN+1
    // }
    rts
}
// Definition of sum()
// sum(byte register(X) a, byte register(A) b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
