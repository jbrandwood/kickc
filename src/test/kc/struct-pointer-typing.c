

struct Block {
	unsigned int data;
	unsigned int next;
	unsigned int prev;
};

struct Block blocks[10];

void main() {
    struct Block* ptr = blocks; 
    for(char i=0;i<10;i++) {
        struct Block* ptr2; 
        ptr2 = (struct Block*)ptr->prev;
        ptr2->next = ptr->next;
        ptr++;
    }
}