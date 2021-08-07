/// Test strcmp()

#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <6502.h>

#define LESS_THAN -1
#define EQUAL 0
#define GREATER_THAN 1

void assert_cmp(signed char expect, signed char actual, char* message);

void main() {

    assert_cmp(LESS_THAN, strcmp("a","b"), "a<b strcmp()");
    assert_cmp(LESS_THAN, strcmp("aaa","aab"), "aaa<aab strcmp()");
    assert_cmp(LESS_THAN, strcmp("aa","aaa"), "aa<aaa strcmp()");
    assert_cmp(EQUAL, strcmp("x","x"), "x=x strcmp()");
    assert_cmp(EQUAL, strcmp("qwez","qwez"), "qwez=qwez strcmp()");
    assert_cmp(GREATER_THAN, strcmp("q","k"), "q>k strcmp()");
    assert_cmp(GREATER_THAN, strcmp("kkkq","kkkp"), "kkkq>kkkp strcmp()");
    assert_cmp(GREATER_THAN, strcmp("kkkq","kkk"), "kkkq>kkk strcmp()");

    assert_cmp(LESS_THAN, strncmp("aaax","aabx", 3), "aaax<aabx strncmp(3)");
    assert_cmp(GREATER_THAN, strncmp("qwe","qee", 3), "qwe>qee strncmp(2)");
    assert_cmp(EQUAL, strncmp("aab","aac", 2), "aab=aac strncmp(2)");
    assert_cmp(EQUAL, strncmp("qwex","qwea", 3), "qwex=qwea strncmp(3)");
    assert_cmp(LESS_THAN, strncmp("aa","aacx", 3), "aa<aacx strncmp(3)");

    assert_cmp(LESS_THAN, memcmp("aa","aba", 2), "aa<ab memcmp(2)");
    assert_cmp(EQUAL, memcmp("x","x", 2), "x=x memcmp(2)");
    assert_cmp(EQUAL, memcmp("xy","xz", 1), "xy=xz memcmp(1)");
    assert_cmp(GREATER_THAN, memcmp("qwez","qwex",4), "qwez>qwex memcmp(4)");

    for(;;) ;
}

void assert_cmp(signed char expect, signed char actual, char* message) {
    char ok = 0;
    switch(expect) {
        case LESS_THAN:
            ok = (char)(actual<0);
            break;
        case EQUAL:
            ok = (char)(actual==0);
            break;
        case GREATER_THAN:
            ok = (char)(actual>0);
            break;
    }

    if(ok) {
        textcolor(GREEN);
        printf("ok! %s\n", message);
    } else {
        textcolor(RED);
        printf("Assert failed. expected:%d actual:%d. %s\n", expect, actual, message);
    }
}
