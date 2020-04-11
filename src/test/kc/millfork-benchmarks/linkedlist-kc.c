#include "benchcommon.c"

struct node {
    struct node* next;
    unsigned int value;
};

struct node  heap[4000];

unsigned int free_;
struct node* root;

void init(void) {
    free_ = 0;
    root = 0;
}

struct node* alloc() {
    struct node* result;
    result = heap + free_;
    free_++;
    return result;
}

void prepend(unsigned int x) {
    struct node* new;
    new = alloc();
    new->next = root; 
    new->value = x; 
    root = new;
}

unsigned int sum(void) {
    struct node* current;
    unsigned int s;
    s = 0;
    current = root;
    while (current) {
        s += current->value;
        current = current->next;
    }
    return s;
}

void main(void) {
    unsigned int i;
    unsigned char c;
    start();
    for(c : 0..4) {
        init();
        for(i : 0..2999) {
            prepend(i);
        }
        print_char((byte)sum());
    }
    end();
}