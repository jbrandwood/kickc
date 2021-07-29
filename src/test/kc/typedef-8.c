// Test typedef enum

typedef enum BOOL_T {
   FALSE = 0,
   TRUE
} bool_t;

bool_t * SCREEN = (bool_t*)0x0400;

void main() {
    bool_t exe = FALSE;
    *SCREEN = exe;
}