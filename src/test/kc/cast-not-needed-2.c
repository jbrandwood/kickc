// Tests a cast that is not needed

byte* screens[] = { (byte*)$0400, (byte*)$1400 };

void main() {
    byte* screen;
    screen = getScreen(0);
    *spritePtr(screen) = $22;
}

inline byte* getScreen(byte id) {
    return screens[id];
}

inline byte* spritePtr(byte* screen) {
    return (byte*)(screen+$378);
}