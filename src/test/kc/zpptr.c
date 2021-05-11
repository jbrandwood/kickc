void main() {
    byte* zpptr = (byte*)$1000;
    for(byte j : 0..10) {
        for(byte i : 0..10) {
            for(byte k : 0..10) {
                byte* zpptr2 = zpptr+i;
                word w = (word)j;
                // Testing byte* = byte* + word;
                zpptr2 = zpptr2 + w;
                *zpptr2 = k;
            }
        }
    }
}