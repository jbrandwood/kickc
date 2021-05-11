// Range-based for does not recognize symbolic constants.
// The following should work but gives a not-constant exception

void main() {
    byte* const BITMAP = (byte*)$2000;
    for(byte* b : BITMAP+$1fff..BITMAP) {
       *b = $5a;
    }
}