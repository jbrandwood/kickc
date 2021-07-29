// Tests a cast that is not needed
// When assigning a char from an integer


void main() {
    char * screen = (char*)0x0400;
    for(int i=-1000;i<1000;i++) {
        char c = i;
        *(screen++) = c;
    }

}
