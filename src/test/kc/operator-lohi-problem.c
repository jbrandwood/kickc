// Illustrates problem with constant evaluation of lo/hi-operator
// $20000 /$400 results in a byte value - confusing the lo/hi-evaluation
// which currently relies on getting the type from the literal value.
// A fix could be adding support for "declared" types for constant literal values
// - enabling the lo/hi to know that their operand is a word (from the cast).

byte* const SCREEN = $400;

void main() {
    dword dw = $2000;
    word w1 = < dw;
    word w2 = < (dw+1);

    SCREEN[0] = <w1;
    SCREEN[1] = >w1;

    SCREEN[3] = <w2;
    SCREEN[4] = >w2;

}