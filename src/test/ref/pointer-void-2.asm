// Test simple void pointer - void pointer function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label d = 4
    .label w = 8
    .label b = $a
    lda #<$12345678
    sta d
    lda #>$12345678
    sta d+1
    lda #<$12345678>>$10
    sta d+2
    lda #>$12345678>>$10
    sta d+3
    lda #<$1234
    sta w
    lda #>$1234
    sta w+1
    lda #$12
    sta b
    ldx #0
    lda #<b
    sta print.ptr
    lda #>b
    sta print.ptr+1
    jsr print
    lda #<w
    sta print.ptr
    lda #>w
    sta print.ptr+1
    jsr print
    lda #<d
    sta print.ptr
    lda #>d
    sta print.ptr+1
    jsr print
    rts
}
// print(void* zeropage(2) ptr)
print: {
    .label ptr = 2
    ldy #0
    lda (ptr),y
    sta SCREEN,x
    inx
    rts
}
