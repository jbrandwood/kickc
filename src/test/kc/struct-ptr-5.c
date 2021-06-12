// Minimal struct - simple linked list implemented using pointers

struct Entry {
    byte value;
    struct Entry* next;
};

struct Entry* ENTRIES = (struct Entry*)0x1000;

void main() {
    // Create a few (non-linear) linked entries
    struct Entry* entry0 = ENTRIES;
    struct Entry* entry1 = ENTRIES+1;
    struct Entry* entry2 = ENTRIES+2;

    entry0->next = entry2;
    entry0->value = 1;
    entry2->next = entry1;
    entry2->value = 2;
    entry1->next = (struct Entry*)0;
    entry1->value = 3;

    // Run through the linked list
    byte* const SCREEN = (byte*)0x0400;
    byte idx = 0;

    struct Entry* entry = ENTRIES;
    while(entry) {
        SCREEN[idx++] = '0'+entry->value;
        SCREEN[idx++] = BYTE0(entry->next);
        SCREEN[idx++] = BYTE1(entry->next);
        SCREEN[idx++] = ' ';
        entry = entry->next;
    }


}