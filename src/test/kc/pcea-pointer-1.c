// These pointers lives on zeropage
// KickAss should be able to add .z to the STAs

char * const _s1 = (char*)0xee;
unsigned int * const _s2 = (unsigned int*)0xef;

void main() {
    *_s1 = 7;
    *_s2 = 812;
    *(_s2-1) = 812;
}