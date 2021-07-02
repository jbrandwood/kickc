// Test MAKELONG4()

void main() {
    unsigned long* const SCREEN = (unsigned int*)0x0400;
    for(char lolo=0;lolo<100;lolo++)
        for(char lohi=0;lohi<100;lohi++)
            for(char hilo=0;hilo<100;hilo++)
                for(char hihi=0;hihi<100;hihi++)
                    *SCREEN = MAKELONG4(hihi, hilo, lohi, lolo);
}