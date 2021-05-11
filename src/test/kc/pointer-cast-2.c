// Tests casting pointer types to other pointer types

void main() {
    {
    byte* const ub_screen = (char*)$400;
    byte ub = 0xff;
    signed byte* sb_ptr = (signed byte*) &ub;
    *sb_ptr = 1;
    *ub_screen = ub;
    }

    {
    signed byte* const sb_screen = (signed byte*)$428;
    signed byte sb = (signed byte)0x7f;
    byte* ub_ptr = (byte*) &sb;
    *ub_ptr = 1;
    *sb_screen = sb;
    }

}