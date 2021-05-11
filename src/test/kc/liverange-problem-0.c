// Error where the compiler is reusing the same ZP for two byte* variables.
// SCREEN_1 and SCREEN_2 are both allocated to ZP: 4
// Problem is that outside main() scope statements have zero call-paths and then isStatementAllocationOverlapping() never checks liveranges
// CallPath code must be rewritten to use @begin as the outermost call instead of main()

byte* MEM = (char*)0x0400;
byte* malloc() {
    return ++MEM;
}

byte* SCREEN_1 = malloc();
byte* SCREEN_2 = malloc();

void main() {
    *SCREEN_1 = 0;
    *SCREEN_2 = 0;
}

