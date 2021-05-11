
char ARR1[0x130];

char ARR2[] = { 1, 2, 3 };

void main() {
    unsigned i = sizeof(ARR1);
    ARR1[i-1] = 0;
    char j = (char)sizeof(ARR2);
    ARR2[j-1] = 0;
}
