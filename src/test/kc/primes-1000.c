// Calculates the 1000 first primes
// From A Comparison of Language Speed, The Transactor, March 1987, Volume 7, Issue 5
// http://csbruce.com/cbm/transactor/pdfs/trans_v7_i05.pdf

#include <c64-print.h>
#include <multiply.h>
#include <division.h>

#define totalprimes 1000

int testnum, primeptr, lasttest, lastprime;
int primenum[totalprimes];

void main() {
	primenum[1] = 2; primenum[2] = 3;
	testnum = 3; lasttest = 2; lastprime = 2;
	do {
		int p = primenum[lasttest];
		if(testnum > (int)mul16s(p, p)) {
			lasttest++;
		}		
		testnum +=2; primeptr = 2;
		do {
			div16s(testnum, primenum[primeptr++]);
			if(rem16s == 0) {
				testnum +=2; primeptr = 2;
			}
		} while (primeptr<=lasttest);
		primenum[++lastprime] = testnum;
		print_sint_decimal(testnum);
		print_char(' ');
	} while(lastprime<totalprimes);
}
