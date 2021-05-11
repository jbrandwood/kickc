// Error cleaning up unused blocks


void main() {
    while(true) {
        menu();
    }
}

void menu() {
    while(true) {
        mode();
        return;
     }
}

byte a = 0;
byte *B = (byte *)$1000;

void mode() {
    while(true) {
        if(*B == 0) {
            a = *B;
        }
    }
}

