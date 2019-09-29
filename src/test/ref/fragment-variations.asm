// Tests that ASM fragment variations works
// ASM fragment variations "cast" constants to different types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_DWORD = 4
main: {
    .label screen = $400
    .label __0 = 2
    .label __1 = 2
    lda #<$a
    sta.z mul16u.a
    lda #>$a
    sta.z mul16u.a+1
    lda #$a
    sta.z mul16u.mb
    lda #0
    sta.z mul16u.mb+1
    sta.z mul16u.mb+2
    sta.z mul16u.mb+3
    jsr mul16u
    lda.z __0
    sta screen
    lda.z __0+1
    sta screen+1
    lda.z __0+2
    sta screen+2
    lda.z __0+3
    sta screen+3
    lda #<$3e8
    sta.z mul16u.a
    lda #>$3e8
    sta.z mul16u.a+1
    lda #<$3e8
    sta.z mul16u.mb
    lda #>$3e8
    sta.z mul16u.mb+1
    lda #<$3e8>>$10
    sta.z mul16u.mb+2
    lda #>$3e8>>$10
    sta.z mul16u.mb+3
    jsr mul16u
    lda.z __1
    sta screen+1*SIZEOF_DWORD
    lda.z __1+1
    sta screen+1*SIZEOF_DWORD+1
    lda.z __1+2
    sta screen+1*SIZEOF_DWORD+2
    lda.z __1+3
    sta screen+1*SIZEOF_DWORD+3
    rts
}
// mul16u(word zeropage(6) a)
mul16u: {
    .label return = 2
    .label mb = 2
    .label a = 6
    lda.z return
    clc
    adc.z a
    sta.z return
    lda.z return+1
    adc.z a+1
    sta.z return+1
    lda.z return+2
    adc #0
    sta.z return+2
    lda.z return+3
    adc #0
    sta.z return+3
    rts
}
