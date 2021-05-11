char *fileCur = (char*)0x1005;
char *fileTop = (char*)0x1010;
char *filesEnd = (char*)0x1010;
char *file = (char*)0x1000;

char * const SCREEN = (char*)0x0400;

void main(void) {
    if (fileTop == filesEnd) --fileTop;
    if (file <= fileCur) --fileCur;
    if (fileCur < fileTop) fileCur = fileTop;

    SCREEN[0] = *fileCur;
}
