// Test simple void pointer - void pointer function
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label d = 4
    .label w = 8
    .label b = $a
    // d = 0x12345678
    lda #<$12345678
    sta.z d
    lda #>$12345678
    sta.z d+1
    lda #<$12345678>>$10
    sta.z d+2
    lda #>$12345678>>$10
    sta.z d+3
    // w = 0x1234
    lda #<$1234
    sta.z w
    lda #>$1234
    sta.z w+1
    // b = 0x12
    lda #$12
    sta.z b
    // print(&b)
    ldx #0
    lda #<b
    sta.z print.ptr
    lda #>b
    sta.z print.ptr+1
    jsr print
    // print(&w)
    lda #<w
    sta.z print.ptr
    lda #>w
    sta.z print.ptr+1
    jsr print
    // print(&d)
    lda #<d
    sta.z print.ptr
    lda #>d
    sta.z print.ptr+1
    jsr print
    // }
    rts
}
// print(void* zp(2) ptr)
print: {
    .label ptr = 2
    // SCREEN[idx++] = *((byte*)ptr)
    ldy #0
    lda (ptr),y
    sta SCREEN,x
    // SCREEN[idx++] = *((byte*)ptr);
    inx
    // }
    rts
}
