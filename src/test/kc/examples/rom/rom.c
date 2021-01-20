// Demonstrates how to code a ROM
// The rom.ld linker file declares segments for RomCode and RomData. 
// It also declares a TestRom segment used for testing the ROM calls.This ensures that the compiler does not optimize them away.

#pragma target(asm6502)
#pragma link("rom.ld")
#pragma extension("bin")
#pragma start_address(0xf000)

#pragma code_seg(RomCode)
#pragma data_seg(RomData)

// A stack based ROM function that will transfer all parameters and return values through the stack.
__stackcall char call1(char param1, char param2) {
    return param1+param2;
}

// A memory based ROM function that will transfer all parameters and return values through zeropage.
__ma char call2(__ma char param1, __ma char param2) {
    return param1+param2;
}

// A "normal" optimized ROM function that will transfer parameters and return value through registers or zeropage.
char call3(char param1, char param2) {
    return param1+param2;
}

// These calls are thrown away when assembling but needed to make sure the compiler does not optimize the ROM functions away.
// To make sure the functions are generated into the final code they must be calling them with different values for each parameter and the return value must used in some way.
#pragma code_seg(TestRom)
void main() {
    char* ptr = 0xfe;
    *ptr = call1(1,2);
    *ptr = call1(3,4);
    *ptr = call2(1,2);
    *ptr = call2(3,4);
    *ptr = call3(1,2);
    *ptr = call3(3,4);
}