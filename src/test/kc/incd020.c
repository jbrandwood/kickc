// Incrementing / decrementing pointer content should result in code modifying the memory location - eg. inc $d020.
// Currently it does not but instead leads to just reading the value a few times.

byte* BG_COLOR = (char*)$d020;
void main() {
    do {
        ++*BG_COLOR;
        (*BG_COLOR)--;
    } while (true);
}