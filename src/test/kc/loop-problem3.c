// A loop that compiles to a wrong sequence - skipping the initilization

void main() {
    for(;;)
        for(char* sc = 0x0400;sc<0x0800; sc++)
            (*sc)++;
}