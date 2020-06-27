char *fileCur = 0x1005;
char *fileTop = 0x1010;
char *filesEnd = 0x1010;
char *file = 0x1000;

char * const SCREEN = 0x0400;

void main(void) {
    if (fileTop == filesEnd) --fileTop;
    if (file <= fileCur) --fileCur;
    if (fileCur < fileTop) fileCur = fileTop;

    SCREEN[0] = *fileCur;
}
