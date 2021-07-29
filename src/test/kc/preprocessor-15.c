// Demonstrates a problem with the preprocessor where the syntax error in the number results in an exception instead of a readable error

#define POKE(X,Y) (*(unsigned char*)(X))=Y

void main() {
    POKE(0x123X,1);
}