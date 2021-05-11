// Test rewriting of constant comparisons for pointers

void main() {
    byte* const screen = (byte*)$0400;
    for(byte* sc =screen;sc<=screen+999;sc++) *sc='a';

    byte* const cols = (byte*)$d800;
    for(byte* cc =cols+999;cc>cols-1;cc--) *cc=2;

}