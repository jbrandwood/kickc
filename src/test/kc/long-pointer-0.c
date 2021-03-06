// Tests creating a long (32bit) pointer on zeropage for 45GS02 flat memory access
void main() {
    __zp unsigned long long_ptr = 0x12345678;
    const char long_ptr_zp = (char)&long_ptr;
    asm {
        nop
        lda (long_ptr_zp),y
        sta $ff
    }
}