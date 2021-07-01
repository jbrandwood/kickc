// Test MAKELONG()

void main() {
    unsigned long* const SCREEN = (unsigned int*)0x0400;
    for(unsigned int lo=0;lo<100;lo++)
        for(unsigned int hi=0;hi<100;hi++) {
            unsigned long i = MAKELONG(hi, lo);
            *SCREEN = i;
        }

}