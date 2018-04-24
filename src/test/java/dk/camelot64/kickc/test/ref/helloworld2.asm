.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
  jsr main
main: {
    lda #<screen
    sta print_spaced.at
    lda #>screen
    sta print_spaced.at+1
    lda #<hello
    sta print_spaced.msg
    lda #>hello
    sta print_spaced.msg+1
    jsr print_spaced
    lda #<screen+$28
    sta print_spaced.at
    lda #>screen+$28
    sta print_spaced.at+1
    lda #<hello
    sta print_spaced.msg
    lda #>hello
    sta print_spaced.msg+1
    jsr print_spaced
    rts
    hello: .text "hello world!@"
}
print_spaced: {
    .label j = 6
    .label msg = 2
    .label at = 4
    lda #0
    sta j
    tax
  b1:
    txa
    tay
    lda (msg),y
    ldy j
    sta (at),y
    tya
    clc
    adc #2
    sta j
    inx
    txa
    tay
    lda (msg),y
    cmp #'@'
    bne b1
    rts
}
