// Demonstrates a problem with the preprocessor where a macro with an empty parameter list does not accept an empty list of parameters

#define CLEAR() a=0

void main() {
    char a=1;
    CLEAR();
}