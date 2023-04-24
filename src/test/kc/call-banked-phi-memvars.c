/**
 * Test banked calls with memory variables.
 * The parameters & return should end up in the shared/common bank.
 */

#pragma link("call-banked-phi.ld")
#pragma var_model(mem)

int* const SCREEN = (int*)0x0400;

#pragma code_seg(Code)
#pragma nobank
void main(void) {
    for(char i=0;i<5; i++) {
        SCREEN[i] = plus(100, (int)i);
        SCREEN[10+i] = plus(200, (int)i);
    }
}

#pragma code_seg(RAM_Bank1)
#pragma data_seg(RAM_Bank1)
#pragma bank(cx16_ram, 1)
int plus(int a,  int b) {
    int r = 2;
    r += a;
    r += b;
    r += a;
    r += b;
    return r;
}
