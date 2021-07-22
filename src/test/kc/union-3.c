// Minimal union with C-Standard behavior - array of union

union Data {
    char b;
    unsigned w;
};

struct Data datas[10];

char* const SCREEN = (char*)0x0400;

void main() {
    for(char i=0;i<10;i++) {
        datas[i].w = 0x1230+i;
    }

    for(char i=0;i<10;i++) {
        SCREEN[i] = datas[i].b;
    }

}