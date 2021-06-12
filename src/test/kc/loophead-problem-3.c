// Program where loop-head optimization produces wrong return value
// Reported by Richard-William Loerakker

#include <c64.h>
#include <multiply.h>

void main() {
    dword result = mul16u(4,123);
    word kaputt = WORD0(result);
    *BORDER_COLOR = BYTE0(kaputt);
    *BG_COLOR = BYTE1(kaputt);
}