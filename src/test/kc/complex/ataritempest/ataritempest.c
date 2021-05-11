// Atari Tempest ROM Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP

#pragma link("ataritempest.ld")
#pragma extension("bin")
#pragma cpu(ROM6502X)

char* const BG_COLOR = (char*)0xc01a;

#pragma data_seg(RomData)
char MESSAGE[] = "hello world";
#pragma data_seg(RamData)
char SCREEN[50];

void entryPoint() {
    for( char i:0..49)
        SCREEN[i] = MESSAGE[i];
}

void __interrupt(hardware_clobber) nmiHandler() {
    (*BG_COLOR)++;
}

void main() {
    (*BG_COLOR)++;
}

#pragma data_seg(Vectors)
export void()* const VECTORS[] = { &nmiHandler, &entryPoint };
