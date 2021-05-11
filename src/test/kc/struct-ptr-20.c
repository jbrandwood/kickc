// Demonstrates problem with conditions using negated struct references

char* const SCREEN = (char*)0x0400;

struct Setting {
    char off;
    char id;
};

const struct Setting settings[] = {
    { 0, 'a' },
    { 1, 'b' },
    { 0, 'c' }
};

void main() {
    char idx = 0;
    char len = (char) (sizeof(settings) / sizeof(struct Setting));
    for(struct Setting* setting = settings; setting<settings+len; setting++) {
        if (! setting->off) {
            SCREEN[idx++] = setting->id;
        }
    }
}

