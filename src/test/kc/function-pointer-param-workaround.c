// Demonstrates work-around for passing parameters to function pointers
#pragma target(c64)

// Save the return address, declare parameter variables
#define PARAM_BEGIN volatile unsigned int ret_addr; char param_char; asm { pla sta ret_addr pla sta ret_addr+1 }

// Restore the return address
#define PARAM_END asm { lda ret_addr+1 pha lda ret_addr pha }

// Declare and pull a char parameter
#define PARAM_CHAR(name)  asm { pla sta param_char } char name=param_char;

// Begin passing parameters using the stack. Declares parameter variables.
#define CALL_BEGIN char param_char;

// Pass a char parameter
#define CALL_CHAR(name) param_char=name; asm { lda param_char pha }

char * const SCREEN1 = 0x0400;
char * const SCREEN2 = 0x0428;

volatile char idx1 = 0;
volatile char idx2 = 0;

void fn1() {
    PARAM_BEGIN;
    PARAM_CHAR(b);
    PARAM_CHAR(c);
    PARAM_END;
    // Function body
    SCREEN1[idx1++] = b;
    SCREEN1[idx1++] = c;
}

void fn2() {
    PARAM_BEGIN;
    PARAM_CHAR(b);
    PARAM_CHAR(c);
    PARAM_END;
    // Function body
    SCREEN2[idx2++] = b;
    SCREEN2[idx2++] = c;
}

void main() {

    void()* fns[2] = { &fn1, &fn2 };

    for(char i='a';i<='p';i++)
        for(char j=0;j<2;j++) {
            CALL_BEGIN;
            CALL_CHAR(i);
            CALL_CHAR(j);
            void()* f = fns[j];
            (*f)();
        }

}