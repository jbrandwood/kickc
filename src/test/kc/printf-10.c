// Tests printf function call rewriting
// A simple string - with the printf-sub cuntions in the same file.

__intrinsic void printf(char* format, ...);

char * screen = 0x0400;
char idx = 0;

void printf_str(char* str) {
    while(*str) {
        *screen++ = *str++;
    }
}

// Format specifying how to format a printed string
struct printf_format_string {
    // The minimal number of chars to output (used for padding with spaces or 0).
    char min_length;
    // Justify left instead of right, which is the default.
    char justify_left;
};

// Print a string value using a specific format
// Handles justification and min length
void printf_string(char* str, struct printf_format_string format) {
    printf_str(str);
}


void main() {
    char* name = "Jesper";
    printf("Hello, I am %s. who are you?", name);
}

