// Test an empty statement ';'

void main() {
    // Start with an empty statement
    ;
    // Fill screen with '*'. Body is an empty statement.
    for( char * screen = 0x0400; screen<0x400+1000; (*screen++)='*') ;
    // End with two empty statements
    ; ;
}