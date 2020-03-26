// Inner increment is not being done properly (screen++)

const word CHAR_COUNTS[0x100];

void main() {
    // Count the number of the different chars on the screen
    byte* screen = 0x0400;
    for( word i:0..999) {
        CHAR_COUNTS[*screen++]++;
    }
}



