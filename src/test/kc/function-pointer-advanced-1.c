// Tests calling advanced functions pointers (with multiple parameters and a return value)

char INPUT[] = { 2, 1, 3, 4, 6, 5 };

char sum(char a, char b);
void cout(char c);
void ln();
void print(char i);

__ma char* line = (char*)0x400;
char idx = 0;

void main() {
    for(char i=0;i<sizeof(INPUT);i++) {
        print(INPUT[i]);
        cout(' ');
    }
    ln();
    exec(&sum);
    ln();
    exec(&min);
    ln();
    exec(&max);
    ln();
    exec(&xor);
}

void exec( char (*collect)(char,char)) {
    cout(' ');
    cout(' ');
    cout(' ');
    char out = INPUT[0];
    for(char i=1;i<sizeof(INPUT);i++) {
        out = (*collect)(out,INPUT[i]);
        print(out);
        cout(' ');
    }
}

char sum(char a, char b) {
    return a+b;
}

char max(char a, char b) {
    if(a>b)
        return a;
    else
        return b;
}

char min(char a, char b) {
    if(a<b)
        return a;
    else
        return b;
}

char xor(char a, char b) {
    return a^b;
}



void cout(char c) {
    line[idx++] = c;
}

void ln() {
    line += 40;
    idx = 0;
}

char HEX[] = "0123456789abcdef";


void print(char i) {
    cout(HEX[i>>4]);
    cout(HEX[i&0x0f]);
}
