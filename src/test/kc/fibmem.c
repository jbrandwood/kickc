byte fibs[15];

void main() {
    fibs[0] = 0;
    fibs[1] = 1;
    byte i = 0;
    do {
        fibs[i+2] = fibs[i]+fibs[i+1];
    } while(++i<15);
}