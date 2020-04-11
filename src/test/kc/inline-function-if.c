// Test inlining a slightly complex print function (containing an if)

byte* screen = $400;

void main() {
    screen[0] = toUpper('c',true);
    screen[1] = toUpper('m',false);
}

inline byte toUpper(byte ch, bool bo) {
    byte res = ch;
    if(bo) {
        res += $40;
    }
    return res;
}

