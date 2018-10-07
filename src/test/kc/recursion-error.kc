// Test that recursion results in a CompileError, as it is not supported

void main() {
    byte* screen = $400;
    byte f = fib(8);
    *screen = f;
}

// Fibonacci implementation
byte fib(byte n) {
    if(n==0) return 0;
    if(n==1) return 1;
    return fib(n-1)+fib(n-2);
}