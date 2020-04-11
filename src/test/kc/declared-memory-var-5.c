// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a memory variable struct value

struct foo {
  char thing1;
  char thing2;
};

__mem __ma struct foo bar = { 'a', 'b' };

void main(void) {
    char* const SCREEN = 0x0400;
	char i=0;
	SCREEN[i++] = bar.thing1;
	SCREEN[i++] = bar.thing2;

}
