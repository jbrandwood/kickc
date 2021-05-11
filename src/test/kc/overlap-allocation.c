// Allocates ZP to j/k-variables even though all of i, j, k could be allocates to x and be more efficient.
// Reason: Pass4RegisterUpliftCombinations.isAllocationOverlapping() believes i/j/k variables overlaps insode plot()
byte* SCREEN = (byte*)$400;

void main() {
    for(byte i : 0..10) {
       plot(i);
    }
   for(byte j : 0..10) {
       plot(j);
    }
   for(byte k : 0..10) {
       plot(k);
    }
}

void plot(byte x) {
    SCREEN[x] = '*';
}
