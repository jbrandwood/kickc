// Test address-of - use the pointer to get the value

void main() {
    byte* SCREEN = $400;
    for( byte b: 0..10) {
         byte* bp = &b;
         byte c = *bp +1;
         SCREEN[b] = c;
     }
}

