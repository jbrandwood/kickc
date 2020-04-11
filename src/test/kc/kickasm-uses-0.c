// Tests that inline kickasm uses clause makes the compiler treat the variable in a special way
// Always allocate memory for the variable (do not allow it to be turned into a constant)

char color = 7;

void main() {

    kickasm(uses color) {{
        lda color
        sta $d020
    }}

}