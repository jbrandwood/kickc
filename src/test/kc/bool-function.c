// Test a function taking boolean parameter and returning boolean result

void main() {
    byte* screen = $400;
    for(byte i: 0..100) {
        if( isSet(i, (i&1)==0)) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

// Determine whether to set a char to '*.
// Returns true if i&8!=0 or b=true
bool isSet(byte i, bool b) {
    return b || ((i&8)!=0);
}