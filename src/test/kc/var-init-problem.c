// Variables without initialization causes problems when compiling


char* screen;

void main() {
    screen = (char*)$400;
    *screen = 'a';
}