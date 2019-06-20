// Test auto-casting of call-parameters
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const w = $1234
    lda #<$1234
    sta print.w
    lda #>$1234
    sta print.w+1
    ldx #0
    jsr print
    lda #<w
    sta print.w
    lda #>w
    sta print.w+1
    jsr print
    lda #<$12*$100+$34
    sta print.w
    lda #>$12*$100+$34
    sta print.w+1
    jsr print
    rts
}
// print(word zeropage(2) w)
print: {
    .label w = 2
    txa
    asl
    tay
    lda w
    sta SCREEN,y
    lda w+1
    sta SCREEN+1,y
    inx
    rts
}
