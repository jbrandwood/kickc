byte* SCREEN= $400;
byte line = $40;
byte ch = line;

void main() {
    ln();
    ch++;
    ln();
    ch++;
    ln();
    *SCREEN = ch;
    *(SCREEN+40) = line;
}

void ln() {
    line = line + $2;
    ch = line;
}





