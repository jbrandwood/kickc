// PI in u[4.28] format
const dword PI_u4f28 = $3243f6a9;

void main() {
    byte* SCREEN = $400;
    SCREEN[0] = > > PI_u4f28;
    SCREEN[1] = < > PI_u4f28;
    SCREEN[2] = > < PI_u4f28;
    SCREEN[3] = < < PI_u4f28;
}