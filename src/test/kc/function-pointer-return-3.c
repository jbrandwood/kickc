// Calling a function pointer with return value
// Calling a function pointer inside a struct without *


struct Task {
    char param;
    void (*handler)(char);
};

char * const RASTER = (char*)0xd012;
char * const BORDER = (char*)0xd020;
char * const BACKGROUND = (char*)0xd021;

void set_border(char col) {
    *BORDER = col;
}

void set_bg(char col) {
    *BACKGROUND = col;
}

void run(struct Task* task) {
    task->handler(task->param);
}

struct Task tasks[] = {
    { 0, &set_border },
    { 0, &set_bg },
    { 1, &set_border },
    { 2, &set_bg }
};


void main() {
    for(;;) {
        for(char i=0; i < sizeof(tasks)/sizeof(struct Task); i++) {
            run(tasks+i);
        }
    }
}