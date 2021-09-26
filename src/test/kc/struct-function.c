#pragma struct_model(classic)

char * const SCREEN = (char*) 0x0400;

void file(void) {
    SCREEN[0] = 'f';
}

void exit(void) {
    SCREEN[1] = 'x';
}

struct MENU_ITEM {
    char* text;
    void (*code)(void);
};

struct MENU_ITEM menu[] = {
    { "File", &file },
    { "Exit", &exit }
};

void main() {
    for(char i=0;i<2;i++) {
        (*(menu[i].code))();
    }
}
