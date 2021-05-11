// Illustrates how inline kickassembler can reference data from the outside program

byte table[] = "cml!"z;

void main() {
    byte* const SCREEN = (char*)$400;

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