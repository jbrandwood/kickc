// Test adding a signed word to a pointer
// Fragment pbuz1=pbuc1_plus_vwsz1.asm supplied by Richard-William Loerakker

char* SCREEN = (char*)0x0400+40*10;

void main() {
    for (signed word i : -10..10 ) {
        char* sc = SCREEN + i;
        *sc = (char)i;
    }
}