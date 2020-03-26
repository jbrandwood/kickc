byte* SCREEN = $0400;

byte ch = 'a';
byte num = 1;
byte str[] = "bc" "d" "e";
byte nums[] = { 2, 3, 4, 5};

void main() {
    SCREEN[0] = ch;
    SCREEN[2] = num;
    for(byte i : 0..3) {
        SCREEN[4+i] = str[i];
        SCREEN[9+i] = nums[i];
    }
}