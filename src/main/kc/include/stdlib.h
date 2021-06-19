/// @file
/// C standard library stdlib.h
/// Implementation of functions found int C stdlib.h / stdlib.c
#include <string.h>

/// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
/// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
void* malloc(unsigned int size);

/// A block of memory previously allocated by a call to malloc is deallocated, making it available again for further allocations.
/// If ptr is a null pointer, the function does nothing.
void free(void* ptr);

/// Allocates memory and returns a pointer to it. Sets allocated memory to zero.
/// - nitems − This is the number of elements to be allocated.
/// - size − This is the size of elements.
void *calloc(size_t nitems, size_t size);

/// Searches an array of nitems unsigned ints, the initial member of which is pointed to by base, for a member that matches the value key.
/// - key - The value to look for
/// - items - Pointer to the start of the array to search in
/// - num - The number of items in the array
/// Returns pointer to an entry in the array that matches the search key
unsigned int* bsearch16u(unsigned int key, unsigned int* items, char num);

/// The different supported radix
enum RADIX { BINARY=2, OCTAL=8, DECIMAL=10, HEXADECIMAL=16 };

/// Converts unsigned number value to a string representing it in RADIX format.
/// If the leading digits are zero they are not included in the string.
/// - value : The number to be converted to RADIX
/// - buffer : receives the string representing the number and zero-termination.
/// - radix : The radix to convert the number to (from the enum RADIX)
void utoa(unsigned int value, char* buffer, enum RADIX radix);

/// Converts unsigned number value to a string representing it in RADIX format.
/// If the leading digits are zero they are not included in the string.
/// - value : The number to be converted to RADIX
/// - buffer : receives the string representing the number and zero-termination.
/// - radix : The radix to convert the number to (from the enum RADIX)
void ultoa(unsigned long value, char* buffer, enum RADIX radix);

/// Converts the string argument str to an integer.
int atoi(const char *str);

/// Returns the absolute value of int x.
int abs(int x);

/// Returns the absolute value of long int x.
long labs(long x);

/// The maximal random value
#define RAND_MAX 65335

/// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
unsigned int rand();

/// Seeds the random number generator used by the function rand.
void srand(unsigned int seed);