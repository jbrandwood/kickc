// Demonstrates problem with conditions using negated struct references

unsigned int* const SCREEN = (char*)0x0400;

struct Setting {
    char len;
    unsigned int* buf;
};

unsigned int seq[] = { 1, 2, 3 };
struct Setting settings[] = { { 3, &seq[0] } };

void main() {
    struct Setting *setting = &settings[0];
    char idx = 0;
    for( char i=0;i<setting->len;i++) {
        SCREEN[i] = setting->buf[i];
    }
}



