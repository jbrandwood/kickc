#include <c64-print.h>

void main() {
	print_cls();
	for(unsigned long i=0;i<3330;i+=333) {
		print_ulong_decimal(i*555);
		print_ln();
	}
}
