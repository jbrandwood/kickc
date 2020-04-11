// Test a for()-loop where the condition has a side-effect
// Currently not standard C compliant (since the condition is not evaluated before the body)

char* SCREEN = 0x0400;

void main(void) {
    char i;
    for(i=7;i++<7;)
        SCREEN[i] = i;
    // The condition-evaluation should increment i - even if when it is not met - x should end up in 0x0408
    (SCREEN)[i] = 'x';
}