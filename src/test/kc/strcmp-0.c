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

    assert_cmp(LESS_THAN, strcmp("a","b"), "a<b");
    assert_cmp(LESS_THAN, strcmp("aaa","aab"), "aaa<aab");
    assert_cmp(LESS_THAN, strcmp("aa","aaa"), "aa<aaa");
    assert_cmp(EQUAL, strcmp("x","x"), "x=x");
    assert_cmp(EQUAL, strcmp("qwez","qwez"), "qwez=qwez");
    assert_cmp(GREATER_THAN, strcmp("q","k"), "q>k");
    assert_cmp(GREATER_THAN, strcmp("kkkq","kkkp"), "kkkq>kkkp");
    assert_cmp(GREATER_THAN, strcmp("kkkq","kkk"), "kkkq>kkk");

    assert_cmp(LESS_THAN, strncmp("aaax","aabx", 3), "aaax<aabx (3)");
    assert_cmp(GREATER_THAN, strncmp("qwe","qee", 3), "qwe>qee (2)");
    assert_cmp(EQUAL, strncmp("aab","aac", 2), "aab=aac (2)");
    assert_cmp(EQUAL, strncmp("qwex","qwea", 3), "qwex=qwea (3)");

    for(;;) ;
}


void assert_cmp(signed char expect, signed char actual, char* message) {
    char ok = 0;
    switch(expect) {
        case LESS_THAN:
            BREAK();
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
