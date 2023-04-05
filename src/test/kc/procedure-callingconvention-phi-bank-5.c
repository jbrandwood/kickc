
// The linker specification of the different segments.
#pragma link("procedure-callingconvention-phi-bank-5.ld")

// The target computer platform is the Commander X16,
// which implements banking in ram between 0xA0000 and 0xBFFF,
// and in rom between 0xC000 and 0xFFFF.
#pragma target(cx16)

char *const SCREEN = (char *)0x0400; // Just for test purposes.

#pragma code_seg(Bank1) // The sequent functions will be addressed specified by segment bank1 in the linker.
#pragma bank(ram, 1)    // The sequent functions will be banked using call method ram in bank number 1.

// Function declarations
char func_ram_bank1_a(char a, char b);
char __bank(ram, 1) func_ram_bank1_b(char a, char b);
char func_ram_bank1_c(char a, char b);
char func_ram_bank1_d(char a, char b);
char func_ram_bank1_e(char a, char b);
char func_ram_bank1_f(char a, char b);
char func_rom_bank2_a(char a, char b);
char __bank(rom, 2) func_rom_bank2_b(char a, char b);
char func_rom_bank2_c(char a, char b);
char func_rom_bank2_d(char a, char b);
char func_rom_bank2_e(char a, char b);
char func_rom_bank2_f(char a, char b);
char func_main_a(char a, char b);
char func_main_b(char a, char b);

// Functional code

char func_ram_bank1_a(char a, char b) { 
    return a + b; 
}

char func_ram_bank1_c(char a, char b) { 
    return func_ram_bank1_a(a, b);               // Non banked call in ram bank 1. 
}

char func_ram_bank1_d(char a, char b) { 
    return func_rom_bank2_a(a, b);               // Banked call from ram bank 1 to rom bank 2.
}

char func_ram_bank1_e(char a, char b) { 
    return func_rom_bank2_b(a, b);               // Banked call from ram bank 1 to rom bank 2.
}

char func_ram_bank1_f(char a, char b) { 
    return func_main_a(a, b);                    // Non banked call from ram bank 1 to main memory.
}


#pragma code_seg(Bank2) // The sequent functions will be addressed specified by segment bank2 in the linker.
#pragma bank(rom, 2)    // The sequent functions will be banked using call method rom in bank number 2.

char func_rom_bank2_a(char a, char b) { 
    return a + b;
}

char func_rom_bank2_c(char a, char b) {
    return func_ram_bank1_a(a, b);              // Banked call from rom bank 2 to ram bank 1.
}

char func_rom_bank2_d(char a, char b) {
    return func_rom_bank2_a(a, b);              // Non banked call in rom bank 2.
}

char func_rom_bank2_e(char a, char b) { 
    return func_rom_bank2_b(a, b);              // Non Banked call in rom bank 2.
}

char func_rom_bank2_f(char a, char b) {
    return func_main_a(a, b);                   // Non banked call from rom bank 2 to main memory.
}


#pragma nobank(dummy) // The sequent functions will consider no banking calculations anymore.

// The __bank directive declares this function to be banked using call method ram in bank number 1 of banked ram.
char __bank(ram, 1) func_ram_bank1_b(char a, char b) { 
    return a + b; 
}

// The __bank directive declares this function to be banked using call method rom in bank number 2 of banked rom.
char __bank(rom, 2) func_rom_bank2_b(char a, char b) { 
    return a + b; 
}

#pragma code_seg(Code) // The sequent functions will be addressed in the default main memory location (segment Code).

// Allocated in main memory.
char func_main_a(char a, char b) {
    return func_ram_bank1_e(a, b); // Banked call to ram in bank 1 from main memory.
}

// Allocated in main memory.
char func_main_b(char a, char b) {
    return func_rom_bank2_e(a, b); // Banked call to rom in bank 2 from main memory.
}

// Practically this means that the main() function is placed in main memory ...

void main(void) {
    SCREEN[0] = func_ram_bank1_a('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_ram_bank1_b('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_ram_bank1_c('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_ram_bank1_d('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_ram_bank1_e('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_ram_bank1_f('0', 7); // Banked call to ram in bank 1 from main memory.
    SCREEN[0] = func_rom_bank2_a('0', 7); // Banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_rom_bank2_b('0', 7); // Banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_rom_bank2_c('0', 7); // Banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_rom_bank2_d('0', 7); // Banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_rom_bank2_e('0', 7); // banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_rom_bank2_f('0', 7); // banked call to rom in bank 2 from main memory.
    SCREEN[0] = func_main_a('0', 7);  // Near call in main memory from main memory.
    SCREEN[0] = func_main_b('0', 7);  // Near call in main memory from main memory.
}
