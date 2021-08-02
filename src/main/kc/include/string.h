/// @file
/// C standard library string.h
///
/// Functions to manipulate C strings and arrays.
#include <stddef.h>

/// Copy block of memory (forwards)
/// Copies the values of num chars from the location pointed to by source directly to the memory block pointed to by destination.
void* memcpy( void* destination, void* source, size_t num );

/// Move block of memory
/// Copies the values of num chars from the location pointed by source to the memory block pointed by destination. Copying takes place as if an intermediate buffer were used, allowing the destination and source to overlap.
void* memmove( void* destination, void* source, size_t num );

/// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
void *memset(void *str, char c, size_t num);

/// Copies the C string pointed by source into the array pointed by destination, including the terminating null character (and stopping at that point).
char* strcpy( char* destination, char*  source );

/// Copies up to n characters from the string pointed to, by src to dest.
/// In a case where the length of src is less than that of n, the remainder of dest will be padded with null bytes.
/// @param dst − This is the pointer to the destination array where the content is to be copied.
/// @param src − This is the string to be copied.
/// @param n − The number of characters to be copied from source.
/// @return The destination
char *strncpy(char *dst, const char *src, size_t n);

/// Computes the length of the string str up to but not including the terminating null character.
size_t strlen(char *str);

/// Searches for the first occurrence of the character c (an unsigned char) in the first n bytes of the string pointed to, by the argument str.
/// @param str The memory to search
/// @param c A character to search for
/// @param n  The number of bytes to look through
/// @return A pointer to the matching byte or NULL if the character does not occur in the given memory area.
void *memchr(const void *str, char c, size_t n);