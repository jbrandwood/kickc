// Simple binary multiplication implementation

// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
unsigned int mul8u(char a, char b);

// Multiply of two signed bytes to a signed word
// Fixes offsets introduced by using unsigned multiplication
int mul8s(signed char a, signed char b);

// Multiply a signed byte and an unsigned byte (into a signed word)
// Fixes offsets introduced by using unsigned multiplication
int mul8su(signed char a, char b);

// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
unsigned long mul16u(unsigned int a, unsigned int b);

// Multiply of two signed words to a signed double word
// Fixes offsets introduced by using unsigned multiplication
signed long mul16s(int a, int b);