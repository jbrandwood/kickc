char *fileCur;
char *fileTop;
char *filesEnd;
char *file;

void main(void) {
    if (fileTop == filesEnd) --fileTop;
    if (file <= fileCur) --fileCur;
    if (fileCur < fileTop) fileCur = fileTop;
}
