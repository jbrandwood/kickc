// Calling a function pointer with parameters
// Reference the function without &

char * const RASTER = (char*)0xd012;
char * const BORDER = (char*)0xd020;

char fn1() {
    return *RASTER;
}

char fn2() {
    return 0;
}

void set_border(char (*fn)(void)) {
    // Call pointer to a function without *
    *BORDER = fn();
}

void main() {
    for(;;) {
        // Create pointer to function without &
        set_border(fn1);
        set_border(fn2);
    }
}