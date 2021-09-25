// Test simple void pointer - void pointer function
  // Commodore 64 PRG executable file
.file [name="pointer-void-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label vb = b
    .label vw = w
    .label vd = d
    .label d = 2
    .label w = 6
    .label b = 8
    // dword d = 0x12345678
    lda #<$12345678
    sta.z d
    lda #>$12345678
    sta.z d+1
    lda #<$12345678>>$10
    sta.z d+2
    lda #>$12345678>>$10
    sta.z d+3
    // word w = 0x1234
    lda #<$1234
    sta.z w
    lda #>$1234
    sta.z w+1
    // byte b = 0x12
    lda #$12
    sta.z b
    // print(vb)
    ldx #0
    lda #<vb
    sta.z print.ptr
    lda #>vb
    sta.z print.ptr+1
    jsr print
    // print(vw)
    lda #<vw
    sta.z print.ptr
    lda #>vw
    sta.z print.ptr+1
    jsr print
    // print(vd)
    lda #<vd
    sta.z print.ptr
    lda #>vd
    sta.z print.ptr+1
    jsr print
    // }
    rts
}
// void print(__zp(9) void *ptr)
print: {
    .label ptr = 9
    // SCREEN[idx++] = *((byte*)ptr)
    ldy #0
    lda (ptr),y
    sta SCREEN,x
    // SCREEN[idx++] = *((byte*)ptr);
    inx
    // }
    rts
}
