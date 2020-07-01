// Demonstrates problem with pointer to pointer

unsigned int** p1;
unsigned int** p2;

void main() {
    **p1 = **p2;
}