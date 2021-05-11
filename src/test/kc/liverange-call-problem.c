// Live ranges were not functioning properly, when multiple method calls were chained - each modifying different vars.
// w1 and w2 ended up having the same zero-page register as their live range was not propagated properly

word w1 = 0;
word w2 = 0;

void main() {
    incw1();
    incw2();
    incw1();
    incw2();
    word* SCREEN = (char*)$400;
    SCREEN[0] = w1;
    SCREEN[2] = w2;
}

void incw1() {
    w1++;
}

void incw2() {
    w2++;
}
