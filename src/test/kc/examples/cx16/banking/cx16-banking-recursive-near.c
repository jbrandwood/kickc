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
#pragma var_model(mem)

#include <cx16.h>
#include <conio.h>
#include <printf.h>
#include <kernal.h>

// The target computer platform is the Commander X16,
// which implements banking in ram between 0xA0000 and 0xBFFF,
// and in ram between 0xC000 and 0xFFFF.
#pragma target(cx16)

char __stackcall plus(char a, char b) {
    if (a > 0) {
        return a + plus(a - b, b);
    } else {
        return 0;
    }
}

void main(void) {

    char result = plus(4, 1);
    printf("result = %u\n", result);
}

