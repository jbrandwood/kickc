
byte b[3];
byte c[] = {'c', 'm', 'l'};
byte d[] = "cml"z;

byte* SCREEN = $400;

void main() {
    b[0] = 'c';
    *SCREEN = b[0];
    *(SCREEN+1) = c[1];
    *(SCREEN+2) = d[2];
}