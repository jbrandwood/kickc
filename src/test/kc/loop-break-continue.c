// Illustrates both break & continue statements in a loop
// Prints a message ending at NUL skipping all spaces
void main() {
    byte* screen = (char*)$400;
    byte str[] = "hello brave new world";
    for( byte i: 0..255) {
    	if(str[i]==0) break;
    	if(str[i]==' ') continue;
    	*screen++ = str[i];
    }
}
