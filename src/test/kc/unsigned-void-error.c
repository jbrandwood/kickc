// Tests that unsigned void produces an error

void main() {
    getNull();
}

unsigned void* getNull() {
    return (byte*) 0;
}


