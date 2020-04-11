// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value - containing a fixed size array

struct foo {
  char thing1;
  char thing2;
  char thing3[12];
};

__mem __ma  struct foo bar = { 'a', 'b', "qwe" };

void main(void) {
	struct foo* barp = &bar;
    char* const SCREEN = 0x0400;
	char i=0;
	SCREEN[i++] = barp->thing1;
	SCREEN[i++] = barp->thing2;
	for( char j: 0..11)
	    SCREEN[i++] = barp->thing3[j];

}
