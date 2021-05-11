// Test address-of by assigning the affected variable in multiple ways

byte val = 0;

void main() {
    byte* const SCREEN1 = (char*)0x0400;
    byte* const SCREEN2 = SCREEN1+40;
    byte idx = 0;
    SCREEN1[idx] = val;
    SCREEN2[idx++] = '.';
    // Here we have not yet used address-of - so val can be versioned freely
    val = 1;
    SCREEN1[idx] = val;
    SCREEN2[idx++] = '.';
    // Use address-of - hereafter all versions of val must be in the same memory
    byte* ptr = &val;
    // Set value directly
    val = 2;
    SCREEN1[idx] = val;
    SCREEN2[idx++] = *ptr;
    // Set value through pointer
    *ptr = 3;
    SCREEN1[idx] = val;
    SCREEN2[idx++] = *ptr;
    // Set value directly in a call
    setv(4);
    SCREEN1[idx] = val;
    SCREEN2[idx++] = *ptr;
    // Set value through pointer in a call
    setp(ptr, 5);
    SCREEN1[idx] = val;
    SCREEN2[idx++] = *ptr;
}

void setv(byte v) {
    val = v;
}

void setp(byte* p, byte v) {
    *p = v;
}

