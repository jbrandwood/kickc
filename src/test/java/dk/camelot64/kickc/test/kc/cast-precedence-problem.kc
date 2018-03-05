// Tests that casting inside constants in the output handles precedence between cast and + correctly - should generate the following KA-expression ($ff & sumw>>1)+1

void main() {
    byte* SCREEN = $400;
    byte min = 10;
    byte max = 200;
    word sumw = min+max;
    byte midw = (byte)(sumw>>1)+1;
    SCREEN[0] = midw;
    byte sumb = min+max;
    byte midb = (sumb>>1)+1;
    SCREEN[1] = midb;
    byte* BGCOL = $d021;
    if(SCREEN[0]==SCREEN[1]) {
        *BGCOL = 5;
    } else {
        *BGCOL = 2;
    }
}
