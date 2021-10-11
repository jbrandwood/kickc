// Illustrates how inline kickassembler can reference data from the outside program

char table[] = "cml!";
void main() {
    char* const SCREEN = (char*)0x400;
    kickasm(uses SCREEN, uses table) {{
        ldx #0
        !:
        lda table,x
        sta SCREEN+1,x
        inx
        cpx #4
        bne !-
    }}
}



