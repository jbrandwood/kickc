/**
 * @file cx16-banking-1.c
 * @author your name (you@domain.com)
 * @brief This program demonstrates a simple example of a banked call.
 * @version 0.1
 * @date 2023-04-05
 * 
 * @copyright Copyright (c) 2023
 * 
 */

// The linker specification of the different segments.
#pragma link("cx16-banking.ld")
#pragma var_model(mem)

#include <cx16.h>
#include <conio.h>
#include <printf.h>

// The target computer platform is the Commander X16,
// which implements banking in ram between 0xA0000 and 0xBFFF,
// and in ram between 0xC000 and 0xFFFF.
#pragma target(cx16)

// Functional code

#pragma code_seg(Bank1) // The sequent functions will be addressed specified by segment bank1 in the linker.
#pragma bank(cx16_ram, 1)    // The sequent functions will be banked using call method ram in bank number 1.

char add_a(char a) { 
    printf("add_a(%02x), ", bank_get_bram());
    return a+1; 
}

char add_c(char a) { 
    printf("add_c(%02x), ", bank_get_bram());
    return add_a(a)+1;               // Non banked call in ram bank 1. 
}

char add_d(char a) { 
    printf("add_d(%02x), ",bank_get_bram());
    return mul_a(a)+1;               // Banked call fram ram bank 1 to ram bank 2.
}

char add_e(char a) { 
    printf("add_e(%02x), ",bank_get_bram());
    return mul_b(a)+1;               // Banked call fram ram bank 1 to ram bank 2.
}

char add_f(char a) { 
    printf("add_f(%02x), ",bank_get_bram());
    return add_m(a)+1;                    // Non banked call fram ram bank 1 to main memory.
}


#pragma code_seg(Bank2) // The sequent functions will be addressed specified by segment bank2 in the linker.
#pragma bank(cx16_ram, 2)    // The sequent functions will be banked using call method ram in bank number 2.

char mul_a(char m) { 
    printf("mul_a(%02x), ",bank_get_bram());
    return m * 2;
}

char mul_c(char m) {
    printf("mul_c(%02x), ",bank_get_bram());
    return add_a(m)*2;              // Banked call fram ram bank 2 to ram bank 1.
}

char mul_d(char m) {
    printf("mul_d(%02x), ",bank_get_bram());
    return mul_a(m)*2;              // Non banked call in ram bank 2.
}

char mul_e(char a) { 
    printf("mul_e(%02x), ",bank_get_bram());
    return mul_b(a)*2;              // Non Banked call in ram bank 2.
}

char mul_f(char m) {
    printf("mul_f(%02x), ",bank_get_bram());
    return add_m(m)*2;                   // Non banked call fram ram bank 2 to main memory.
}


#pragma nobank // The sequent functions will consider no banking calculations anymore.

#pragma code_seg(Bank1) // The sequent functions will be addressed specified by segment bank1 in the linker.
// The __bank directive declares this function to be banked using call method ram in bank number 1 of banked ram.
char __bank(cx16_ram, 1) add_b(char a) {
    printf("add_b(%02x), ",bank_get_bram());
    return a+1; 
}

#pragma code_seg(Bank2) // The sequent functions will be addressed specified by segment bank1 in the linker.
// The __bank directive declares this function to be banked using call method ram in bank number 2 of banked ram.
char __bank(cx16_ram, 2) mul_b(char m) {
    printf("mul_b(%02x), ",bank_get_bram());
    return m*2; 
}

#pragma code_seg(Code) // The sequent functions will be addressed in the default main memory location (segment Code).

// Allocated in main memory.
char add_m(char a) {
    printf("add_m(%02x), ",bank_get_bram());
    return add_e(a)+1; // Banked call to ram in bank 1 fram main memory.
}

// Allocated in main memory.
char mul_m(char m) {
    printf("mul_m(%02x), ",bank_get_bram());
    return mul_e(m)*2; // Banked call to ram in bank 2 fram main memory.
}


// Practically this means that the main() function is placed in main memory ...

void load_bank(char bank, char *file) {
    bank_set_bram(bank);
    cbm_k_setnam(file);
    cbm_k_setlfs(1,8,2);
    cbm_k_load((char*)0xA000, 0);
    cbm_k_close(1);
} 

void main(void) {

    clrscr();
    
    load_bank(1, "BANK1.BIN");
    load_bank(2, "BANK2.BIN");

    bank_set_bram(0);

    asm{.byte $db}
    printf("result = %u\n", add_a(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_b(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_c(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_d(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_e(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_f(1)); // Banked call to ram in bank 1 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_a(1)); // Banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_b(1)); // Banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_c(1)); // Banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_d(1)); // Banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_e(1)); // banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_f(1)); // banked call to ram in bank 2 fram main memory.
    asm{.byte $db}
    printf("result = %u\n", add_m(1));  // Near call in main memory fram main memory.
    asm{.byte $db}
    printf("result = %u\n", mul_m(1));  // Near call in main memory fram main memory.
}
