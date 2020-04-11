// Library Implementation of the Seriously Fast Multiplication
// See http://codebase64.org/doku.php?id=base:seriously_fast_multiplication
// Utilizes the fact that a*b = ((a+b)/2)^2 - ((a-b)/2)^2

// Initialize the mulf_sqr multiplication tables with f(x)=int(x*x/4)
void mulf_init();

// Prepare for fast multiply with an unsigned byte to a word result
void mulf8u_prepare(byte a);

// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8u_prepare(byte a)
word mulf8u_prepared(byte b);

// Fast multiply two unsigned bytes to a word result
word mulf8u(byte a, byte b);

// Prepare for fast multiply with an signed byte to a word result
inline void mulf8s_prepare(signed byte a);

// Calculate fast multiply with a prepared unsigned byte to a word result
// The prepared number is set by calling mulf8s_prepare(byte a)
signed word mulf8s_prepared(signed byte b);

// Fast multiply two signed bytes to a word result
signed word mulf8s(signed byte a, signed byte b);

// Fast multiply two unsigned words to a double word result
// Done in assembler to utilize fast addition A+X
dword mulf16u(word a, word b);

// Fast multiply two signed words to a signed double word result
// Fixes offsets introduced by using unsigned multiplication
signed dword mulf16s(signed word a, signed word b);