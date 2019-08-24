// Test binary ANDing pointers by Clay Cowgill

void main() {
    int* pos_ptr = 0x0400;
    byte* vram_ptr = 0x0428;
    for( char i:0..2) {
        *pos_ptr=(int)0x55AA;
        *vram_ptr++=<(*pos_ptr&(int)0xAA55); // stores 0x00
        *vram_ptr++=>*pos_ptr; // stores 0x55
        pos_ptr++;
    }
}