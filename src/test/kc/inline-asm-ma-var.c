// Test access to __ma variable from inline ASM

char * const SCREEN = 0x0400; 

void main() {
    __ma char value = 0;
    for(char i=0;i<10;i++) {

        value += i;

        asm {
            lda #$55
            eor value
            sta SCREEN
        }
    }    
}
