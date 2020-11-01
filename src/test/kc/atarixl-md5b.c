// 8 bit converted md5 calculator

void main() {
    for(char* s=0x0400;s<0x0800;s++) *s=' ';
	md5();
	for(;;) ;
}

__ma char * line = 0x0400;
__ma char idx = 0;
char HEX[] = "0123456789abcdef";

void print(char i, char a, char b, char c) {
        print32(i);
        print32(a); 
        print32(b); 
        print32(c); 
        println();
}

inline void print32(char l) {
    line[idx++] = HEX[l/0x10];
    line[idx++] = HEX[l&0x0f];
    line[idx++] = ' ';
}

inline void println() {
    line += 40;
    idx=0;
}

void md5() {
    char a = 0x67;
    char b = 0xef;
    char c = 0x98;
    for(char i = 0; i<4; i++) {
        print(i, a, b, c);
        if(i&1) a++;
        char temp = c;
        c = b;
        b = b + 1; 
        a = temp;
        print(i, a, b, c);
    }
}
