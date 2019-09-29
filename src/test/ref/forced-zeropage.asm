// Test some forced zeropage access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label __5 = 4
    .label u = 2
    sec
    lda $a0
    sbc #<$22b
    sta.z u
    lda $a0+1
    sbc #>$22b
    sta.z u+1
    lda.z u
    sta $400
    lda.z u+1
    sta $400+1
    clc
    lda $d1
    adc #<$d400
    sta.z __5
    lda $d1+1
    adc #>$d400
    sta.z __5+1
    lda.z __5
    sta $f3
    lda.z __5+1
    sta $f3+1
    rts
}
