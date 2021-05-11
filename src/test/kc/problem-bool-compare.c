// Test boolean comparison false!=false
// https://atariage.com/forums/topic/311788-kickc-optimizing-c-compiler-now-supports-atari-8bit-xlxe/?tab=comments#comment-4644101

void main() {
    char * SCREEN = (char*)0x0400;

    if(false!=false)
        SCREEN[0] = '*';
    if(true!=false)
        SCREEN[1] = '*';


}