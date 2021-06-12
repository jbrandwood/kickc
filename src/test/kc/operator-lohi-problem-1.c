// Illustrates problem with constant evaluation of lo/hi-operator
// $20000 /$400 results in a byte value - confusing the lo/hi-evaluation
// which currently relies on getting the type from the literal value.
// A fix could be adding support for "declared" types for constant literal values
// - enabling the lo/hi to know that their operand is a word (from the cast).

const dword DVAL = $20000;
byte* const SCREEN = (char*)$400;

void main() {
     SCREEN[0] = BYTE0((word)(DVAL/$400));
     SCREEN[1] = BYTE1((word)(DVAL/$400));
}