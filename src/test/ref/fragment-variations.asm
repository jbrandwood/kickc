// Tests that ASM fragment variations works
// ASM fragment variations "cast" constants to different types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_DWORD = 4
main: {
    .label screen = $400
    .label _0 = 2
    .label _1 = 2
    lda #<$a
    sta mul16u.a
    lda #>$a
    sta mul16u.a+1
    lda #<$a
    sta mul16u.mb
    lda #>$a
    sta mul16u.mb+1
    lda #<$a>>$10
    sta mul16u.mb+2
    lda #>$a>>$10
    sta mul16u.mb+3
    jsr mul16u
    lda _0
    sta screen
    lda _0+1
    sta screen+1
    lda _0+2
    sta screen+2
    lda _0+3
    sta screen+3
    lda #<$3e8
    sta mul16u.a
    lda #>$3e8
    sta mul16u.a+1
    lda #<$3e8
    sta mul16u.mb
    lda #>$3e8
    sta mul16u.mb+1
    lda #<$3e8>>$10
    sta mul16u.mb+2
    lda #>$3e8>>$10
    sta mul16u.mb+3
    jsr mul16u
    lda _1
    sta screen+1*SIZEOF_DWORD
    lda _1+1
    sta screen+1*SIZEOF_DWORD+1
    lda _1+2
    sta screen+1*SIZEOF_DWORD+2
    lda _1+3
    sta screen+1*SIZEOF_DWORD+3
    rts
}
// mul16u(word zeropage(6) a)
mul16u: {
    .label return = 2
    .label mb = 2
    .label a = 6
    lda return
    clc
    adc a
    sta return
    lda return+1
    adc a+1
    sta return+1
    lda return+2
    adc #0
    sta return+2
    lda return+3
    adc #0
    sta return+3
    rts
}
