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
#pragma link("cx16-banking-1.ld")
#pragma var_model(mem)

#include <cx16.h>
#include <conio.h>
#include <printf.h>
#include <kernal.h>

#include "cx16-banking-0.h"


// The target computer platform is the Commander X16,
// which implements banking in ram between 0xA0000 and 0xBFFF,
// and in ram between 0xC000 and 0xFFFF.
#pragma target(cx16)

char* const SCREEN = (char*)0x0400;

#pragma code_seg(Bank1) // The sequent functions will be addressed specified by segment bank1 in the linker.
#pragma bank(ram, 1)    // The sequent functions will be banked using call method ram in bank number 1.

char __stackcall plus(char a, char b) {
    return a+b;
}

#pragma code_seg(Code) // The sequent functions will be addressed in the default main memory location (segment Code).
#pragma nobank(dummy) // The sequent functions will consider no banking calculations anymore.

void load_bank(char bank, char *file) {
    bank_set_bram(bank);
    cbm_k_setnam(file);
    cbm_k_setlfs(1,8,2);
    cbm_k_load((char*)0xA000, 0);
    cbm_k_close(1);
} 

void main(void) {

    load_bank(1, "BANK1.BIN");

    SCREEN[0] = plus('0', 7);
}

