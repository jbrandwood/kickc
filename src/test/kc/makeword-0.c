// Test MAKEWORD()

void main() {
    unsigned int* const SCREEN = (unsigned int*)0x0400;
    for(char lo=0;lo<100;lo++)
        for(char hi=0;hi<100;hi++) {
            unsigned int i = MAKEWORD(hi, lo);
            *SCREEN = i;
        }

}