// CX16 CBM Mouse Routines
const word CX16_MOUSE_CONFIG = 0xFF68; // Mouse pointer configuration.
const word CX16_MOUSE_SCAN   = 0xFF71; // ISR routine to scan the mouse state.
const word CX16_MOUSE_GET    = 0xFF6B; // Get the mouse state;

typedef struct {
    int x;
    int y;
    int px;
    int py;
    unsigned char status;
} cx16_mouse_t;

extern __mem cx16_mouse_t cx16_mouse;

void cx16_mouse_config(char visible, char scalex, char scaley);
void cx16_mouse_scan(); 
char cx16_mouse_get();
