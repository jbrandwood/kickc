// Illustrates a problem with post-incrementing a pointer used in a loop comparison

char MESSAGE[20] = "camelot";

char* const SCREEN = 0x0400;

void main() {
    char* msg = MESSAGE;
    // Error! The post-increment in the following loop is turned into a pre-increment by the compiler.
    while(*msg++) {}
    // Now msg should point right after the zero, since the post increment was executed in the last condition that evaluated to zero.
    *--msg = 'x';
    *++msg = 0;
    // This should append an x at the end of the message - instead it replaces the last char of the message.

    // Print the resulting message - should be "camelotx" - but the error causes it to be "camelox"
    char i=0;
    while(MESSAGE[i]) {
        SCREEN[i] = MESSAGE[i];
        i++;
    }

}
