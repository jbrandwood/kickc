// Example showing how to use KickAsm segments to compile meant to be transfered to zeropage before execution.
// The linker-file defines the ZpCode segment to be on zeropage and does not include it directly in the PRG-file (by excluding it from the Program segment).
// Instead the compiled code is added as an array of chars in "normal" memory - and transferred to zeropage at the start of the program

#pragma link("zpcode.ld")

char* RASTER = (char*)0xd012;
char* BG_COLOR = (char*)0xd020;

void main() {
    asm { sei }
    // Transfer ZP-code to zeropage
    char* zpCode = (char*)&zpLoop;
    for(char i=0;i<20;i++)
        zpCode[i] = zpCodeData[i];         

    while(true) {
        while(*RASTER!=0xff) {}
        // Call code in normal memory
        loop();
        // Call code on zeropage
        zpLoop();
        *BG_COLOR = 0;
    }
}

// Code in "normal" memory
void loop() {
    for(char i:0..100) {
        (*BG_COLOR)--;
    }
}

// Array containing the zeropage code to be transferred to zeropage before execution
char zpCodeData[] = kickasm {{
    .segmentout [segments="ZpCode"]
}};

// Code that will be placed on zeropage
// It won't be output to the PRG-file directly because it is not included in the Program segment in the linker-file.
#pragma code_seg(ZpCode)
void zpLoop() {
    for(char i:0..100) {
        (*BG_COLOR)++;
    }
}
