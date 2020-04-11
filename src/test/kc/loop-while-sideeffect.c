// Test a while()-loop where the condition has a side-effect

char* SCREEN = 0x0400;

void main(void) {
    char i = 7;
    while(i++!=7) {
        SCREEN[i] = i;
    }
    // The condition-evaluation should increment i - even if when it is not met
    (SCREEN)[i] = 'x';
}