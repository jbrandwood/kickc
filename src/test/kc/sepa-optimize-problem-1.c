// Parameter "c" to _copyDigitToAnySprite is passed incorrectly to an unused c_1 in the first call in  _updateLupineSprite

char * const SPR_POTATO_UI = (char *)$0a00;
char * const SPR_LUPINE_UI = (char *)$0a40;
char num2str[3];
char * SCREEN = (char*)0x0400;

__stackcall void xputc(char c) {
    *(SCREEN++) = c;
}

void _updatePotatoSprite() {
    xputc(0);
    _copyDigitToAnySprite(SPR_POTATO_UI, num2str[0]);
}

void _updateLupineSprite() {
    xputc(1);
    _copyDigitToAnySprite(SPR_LUPINE_UI, num2str[0]);
    _copyDigitToAnySprite(SPR_LUPINE_UI, num2str[1]);
}

void _copyDigitToAnySprite(char * pointer, char c){
    if(c == $f0){
        pointer[c] = 0;
    } else {
        pointer[c] = 1;
    }
}

void main() {
    _updatePotatoSprite();
    _updateLupineSprite();
}