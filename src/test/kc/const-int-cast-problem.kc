// Test a problem with converting casted constant numbers to fixed type constant integers
byte* const SCREEN = $0400;

void main() {
    for( byte i: 121..122) {
        SCREEN[i] = i>>4;
    }
}
