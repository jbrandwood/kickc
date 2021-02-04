/*
 * Find greatest common denominator using subtraction-based Euclidian algorithm
 * See https://en.wikipedia.org/wiki/Euclidean_algorithm
 * Based on facebook post from
 */

#include <c64-print.h>

void main () {
    print_cls();
    print_euclid(128,2);
    print_euclid(169,69);
    print_euclid(155,55);
    print_euclid(199,3);
    print_euclid(91,26);
    print_euclid(119,187);
}

void  print_euclid(unsigned char a, unsigned char b) {
    print_uchar(a);
    print_char(' ');
    print_uchar(b);
    print_char(' ');
    print_uchar(euclid(a,b));
    print_ln();
}

unsigned char euclid(unsigned char a, unsigned char b) {
	while (a!=b) {
		if(a>b) {
			a=a-b;
		} else {
			b=b-a;
		}
	}
	return a;
}
