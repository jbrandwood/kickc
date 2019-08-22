// Tests creating a long (32bit) pointer on zeropage for 45GS02 flat memory access
void main() {
    unsigned long long_ptr = 0x12345678;
    char long_ptr_zp = <&long_ptr;
    asm {
        nop
        lda (long_ptr_zp),y
        sta $ff
    }
}