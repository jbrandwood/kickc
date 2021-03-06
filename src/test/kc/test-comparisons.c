#include <c64-print.h>

void main() {
    print_cls();
    byte a = 7;
    for( byte i : 0..4 ) {
        byte r;
        byte b = $ce-a;
        byte cs[5] = { $07, $c7, $37, $97, $67 };
        r = '-'; if(a<b) r='+'; printu(a, "< ", b, r);
        r = '-'; if(a<$37) r='+'; printu(a, "< ", $37, r);
        r = '-'; if(a<cs[i]) r='+'; printu(a, "< ", cs[i], r);
        r = '-'; if(a<a) r='+'; printu(a, "< ", a, r);
        print_ln();
        r = '-'; if(a>b) r='+'; printu(a, "> ", b, r);
        r = '-'; if(a>$37) r='+'; printu(a, "> ", $37, r);
        r = '-'; if(a>cs[i]) r='+'; printu(a, "> ", cs[i], r);
        r = '-'; if(a>a) r='+'; printu(a, "> ", a, r);
        print_ln();
        r = '-'; if(a<=b) r='+'; printu(a, "<=", b, r);
        r = '-'; if(a<=$37) r='+'; printu(a, "<=", $37, r);
        r = '-'; if(a<=cs[i]) r='+'; printu(a, "<=", cs[i], r);
        r = '-'; if(a<=a) r='+'; printu(a, "<=", a, r);
        print_ln();
        r = '-'; if(a>=b) r='+'; printu(a, ">=", b, r);
        r = '-'; if(a>=$37) r='+'; printu(a, ">=", $37, r);
        r = '-'; if(a>=cs[i]) r='+'; printu(a, ">=", cs[i], r);
        r = '-'; if(a>=a) r='+'; printu(a, ">=", a, r);
        print_ln();
        r = '-'; if(a==b) r='+'; printu(a, "==", b, r);
        r = '-'; if(a==$37) r='+'; printu(a, "==", $37, r);
        r = '-'; if(a==cs[i]) r='+'; printu(a, "==", cs[i], r);
        r = '-'; if(a==a) r='+'; printu(a, "==", a, r);
        print_ln();
        a=a+$30;
    }
    do {
        // nothing;
    } while(true);
}


void printu(byte a, byte* op, byte b, byte res) {
    print_char(' ');
    print_uchar(a);
    print_str(op);
    print_uchar(b);
    print_char(' ');
    print_char(res);
}
