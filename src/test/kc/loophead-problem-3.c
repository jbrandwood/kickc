// Program where loop-head optimization produces wrong return value
// Reported by Richard-William Loerakker

#include <c64.c>
#include <multiply.c>

void main() {
    dword result = mul16u(4,123);
    word kaputt = <result;
    *BORDERCOL = <kaputt;
    *BGCOL = >kaputt;
}