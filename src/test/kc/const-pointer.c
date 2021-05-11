//Test that constant pointers are detected correctly

void main() {
    byte* screen = (byte*)$400;
    byte* NULL = (byte*)$0;
    byte* rem = (byte*)$ff;

    if(rem!=NULL) {
        screen[0] = '*';
    } else {
        screen[0] = '.';
    }
}