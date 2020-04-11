#pragma reserve(0x16)
#pragma encoding(petscii_mixed)
char strTemp[] = "v=X";
int main(void){
    strTemp[2] = 'e';
    strTemp[3] = 0;
    asm {
        ldy #0
        loop:
        lda strTemp,y
        beq done
        jsr $FFD2
        iny
        jmp loop
    done:
    }
    return 0;
}