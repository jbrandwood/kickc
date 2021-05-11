// Test some complex pointers

void main() {

    // RValue pointer expression (constant)
    byte* screen = (byte*)$400;
    byte a = *(screen+80);

    // RValue pointer expression (variable)
    for(byte i : 0..10) {
        screen[i] = *(screen+40+i);
    }

    // LValue pointer expression (constant - through tmp variable)
    byte* sc2 = screen+81;
    *sc2 = *(screen+121);

    // LValue pointer expression (constant - directly)
    *(screen+82) = *(screen+122);

    // LValue pointer expression (variable - directly)
    for(byte j : 0..10) {
        *(screen+160+j) = *(screen+200+j);
    }

    // Incrementing directly on a word
    ++*(byte*)$d020;
    --*(byte*)($d000+$21);

    // Increment on a const named pointer
    byte* BG_COLOR = (char*)$d020;
    ++*BG_COLOR;


}