// Demonstrates a problem with inner indexes into arrays where the elemt size>1

unsigned int v[5];
unsigned int x[5];

void main() {
    for(char i=0;i<5;i++)
        x[i] += ( v[i] += 5 );
}