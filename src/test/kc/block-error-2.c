// Demonstrates error "Sequence does not contain all blocks from the program."

void main() {
    char move = 1;
    char pos = 1;
    char vacant = 1;
    do {
        pos += move;
        if(pos)
            vacant = 0;
    } while(pos && vacant);
}
