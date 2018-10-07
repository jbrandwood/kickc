// Tests that immediate zero values are reused - even when assigning to words
void main() {
    byte i = 0;
    word w = (word)0;
    for ( byte j : 0..10) {
        i = j;
        w = w + j;
    }
}