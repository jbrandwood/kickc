// Illustrates problem with negating a constant negative number
// KickAsm requires parenthesis for double negation to work

signed char * const SCREEN = (signed char*)0x0400;

void main() {
    printneg(-4);
}

void printneg(signed char c) {
    c = -c;
    SCREEN[0] = c;
}