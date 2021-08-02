// Test the __export directive usable for ensuring a data variable is always added to the output - even if it is never used

char* SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = 'x';
}

__export char MESSAGE[] = "camelot!";
