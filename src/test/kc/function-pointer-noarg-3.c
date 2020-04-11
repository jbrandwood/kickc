// Tests creating and assigning pointers to non-args no-return functions - plus inline kickasm-based calling

void main() {
    byte* const SCREEN = $400;

    void()* f;

    byte i = 0;
    while(true) {
        ++i;
        if((i&1)==0) {
            f = &fn1;
        } else {
            f = &fn2;
        }
        kickasm(uses f) {{
            jsr ff
        }}
    }
}

kickasm {{
ff:
    jmp (main.f)
}}

void fn1() {
    byte* const BORDERCOL = $d020;
    (*BORDERCOL)++;
}

void fn2() {
    byte* const BGCOL = $d021;
    (*BGCOL)++;
}