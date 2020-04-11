// Tests casting pointer types to other pointer types

void main() {
    signed byte* const sb_screen = $400;
    signed byte sb = (signed byte)0xff;
    *sb_screen = sb;
}