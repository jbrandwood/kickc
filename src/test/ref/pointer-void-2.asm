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
    sta.z d
    lda #>$12345678
    sta.z d+1
    lda #<$12345678>>$10
    sta.z d+2
    lda #>$12345678>>$10
    sta.z d+3
    lda #<$1234
    sta.z w
    lda #>$1234
    sta.z w+1
    lda #$12
    sta.z b
    ldx #0
    lda #<b
    sta.z print.ptr
    lda #>b
    sta.z print.ptr+1
    jsr print
    lda #<w
    sta.z print.ptr
    lda #>w
    sta.z print.ptr+1
    jsr print
    lda #<d
    sta.z print.ptr
    lda #>d
    sta.z print.ptr+1
    jsr print
    rts
}
// print(void* zp(2) ptr)
print: {
    .label ptr = 2
    ldy #0
    lda (ptr),y
    sta SCREEN,x
    inx
    rts
}
