// XMega65 Kernal Development Template
// Each function of the kernal is a no-args function
// The functions are placed in the SYSCALLS table surrounded by JMP and NOP

#include <string.h>

#pragma link("xmega65.ld")
#pragma extension("bin")


char* const RASTER = 0xd012;
char* const VIC_MEMORY = 0xd018;
char* const SCREEN = 0x0400;
char* const BG_COLOR = 0xd021;
char* const COLS = 0xd800;
const char BLACK = 0;
const char WHITE = 1;

char MESSAGE[] = "hello world!";

void main() {
    // Initialize screen memory
    *VIC_MEMORY = 0x14;
    // Init screen/colors
    memset(SCREEN, ' ', 40*25);
    memset(COLS, WHITE, 40*25);
    // Print message
    char* sc = SCREEN+40;
    char* msg = MESSAGE;
    while(*msg) {
        *sc++ = *msg++;
    }
    // Loop forever with 2 bars
    while(true) {
        if(*RASTER==54 || *RASTER==66) {
            *BG_COLOR = WHITE;
        } else {
            *BG_COLOR = BLACK;
        }
    }
}

void syscall1() {
    *(SCREEN+79) = '>';
}

void syscall2() {
    *(SCREEN+78) = '<';
}

#pragma data_seg(Syscall)

struct SysCall {
    char xjmp;
    void()* syscall;
    char xnop;
};

const char JMP = 0x4c;
const char NOP = 0xea;

export struct SysCall SYSCALLS[] = {
    { JMP, &syscall1, NOP },
    { JMP, &syscall2, NOP }
    };

export align(0x100) struct SysCall SYSCALL_RESET[] = {
    { JMP, &main, NOP }
};
