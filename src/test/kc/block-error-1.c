// Demonstrates error "Block referenced, but not found in program."

void main() {
    for(char i=0;i!=8;i++) {
        char move = 1;
        char pos = 1;
        char vacant = 1;
        do {
            pos += move;
            if(pos) {
                char vacant = 0;
            }
        } while(pos && vacant);
    }
}
