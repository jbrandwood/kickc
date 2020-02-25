// Test some forced zeropage access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label __1 = 4
    .label u = 2
    // u = *(word *)0xA0 - u
    sec
    lda $a0
    sbc #<$22b
    sta.z u
    lda $a0+1
    sbc #>$22b
    sta.z u+1
    // *((word*)0x0400) = u
    lda.z u
    sta $400
    lda.z u+1
    sta $400+1
    // *(byte **)0xD1 + 0xD400
    clc
    lda $d1
    adc #<$d400
    sta.z __1
    lda $d1+1
    adc #>$d400
    sta.z __1+1
    // *(byte **)0xF3 = *(byte **)0xD1 + 0xD400
    lda.z __1
    sta $f3
    lda.z __1+1
    sta $f3+1
    // }
    rts
}
