// Test work-around for boolean comparison false!=false
// https://atariage.com/forums/topic/311788-kickc-optimizing-c-compiler-now-supports-atari-8bit-xlxe/?tab=comments#comment-4644101

#define FALSE 0
#define TRUE 1

void main() {
    char * SCREEN = (char*)0x0400;

    if(FALSE!=FALSE)
        SCREEN[0] = '*';
    if(TRUE!=FALSE)
        SCREEN[1] = '*';


}