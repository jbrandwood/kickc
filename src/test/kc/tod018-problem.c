// Tests a problem with tod018 not calculating types correctly

void main() {
    byte * const D018 = 0xd018;
    byte* const screen = 0x0400;
    byte d018val = >(screen&$3fff);
    *D018 = d018val;
}
