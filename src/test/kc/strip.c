// Tests of strip() function from https://news.ycombinator.com/item?id=12080871

unsigned char msg1[] = "hello world!";
unsigned char msg2[] = "goodbye blue sky!";

void main() {
    strip(msg1, ' ');
    print(msg1);
    strip(msg2, 'y');
    print(msg2);
}

void strip(unsigned char *p, unsigned char c) {
    unsigned char *dest=p;
    do {
        if(*p!=c) *dest++=*p;
    } while(*p++!=0);
}

unsigned char* screen = $400;

void print(unsigned char* msg) {
    do {
        *screen++ = *msg++;
    } while(*msg!=0);
}