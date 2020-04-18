// Calculates the 1000 first primes
// From A Comparison of Language Speed, The Transactor, March 1987, Volume 7, Issue 5
// http://csbruce.com/cbm/transactor/pdfs/trans_v7_i05.pdf

#include <print.h>
#include <multiply.h>
#include <division.h>

#define totalprimes 1000

// Table that is filled with the primes we are finding
unsigned int PRIMES[totalprimes];
// The index of the last prime we put into the PRIME[] table
unsigned int prime_idx;
// The number currently being tested for whether it is a prime
unsigned int potential;
// The index into PRIMES[] used for prime testing. It runs from 2 to test_last for each number tested.
unsigned char test_idx;
// The last index to test. It is the smallest index where PRIMES[test_last] > sqr(potential)
unsigned char test_last;

void main() {
	PRIMES[1] = 2; PRIMES[2] = 3;
	potential = 3; test_last = 2; prime_idx = 2;
	do {
		char p = (char)PRIMES[test_last];
		if(potential > mul8u(p, p)) {
			test_last++;
		}		
		potential +=2; test_idx = 2;
		do {
			div16u8u(potential, (char)PRIMES[test_idx++]);
			if(rem8u == 0) {
				potential +=2; test_idx = 2;
			}
		} while (test_idx<=test_last);
		PRIMES[++prime_idx] = potential;
		print_uint_decimal(potential);
		print_char(' ');
	} while(prime_idx<totalprimes);
}
