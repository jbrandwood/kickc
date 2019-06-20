// Test simple void pointer - void pointer function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label vb = b
    .label vw = w
    .label vd = d
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
    lda #<vb
    sta print.ptr
    lda #>vb
    sta print.ptr+1
    jsr print
    lda #<vw
    sta print.ptr
    lda #>vw
    sta print.ptr+1
    jsr print
    lda #<vd
    sta print.ptr
    lda #>vd
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
