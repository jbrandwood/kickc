// PI in u[4.28] format
const dword PI_u4f28 = $3243f6a9;

void main() {
    byte* SCREEN = (char*)$400;
    SCREEN[0] = BYTE3(PI_u4f28);
    SCREEN[1] = BYTE2(PI_u4f28);
    SCREEN[2] = BYTE1(PI_u4f28);
    SCREEN[3] = BYTE0(PI_u4f28);
}