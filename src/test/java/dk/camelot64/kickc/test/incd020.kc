// Incrementing / decrementing pointer content should result in code modifying the memory location - eg. inc $d020.
// Currently it does not but instead leads to just reading the value a few times.

byte* BGCOL = $d020;
void main() {
    do {
        ++*BGCOL;
        (*BGCOL)--;
    } while (true);
}