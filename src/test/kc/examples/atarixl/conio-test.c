// Example usages of conio for Atari XL target.

#pragma target(atarixl)

#include <atari-xl.h>
#include <printf.h>
#include <conio.h>

void main() {
	// hide the cursor
	cursor(0);

	// change colors
	bgcolor(DARK_ORANGE);
	bordercolor(MEDIUM_BLUE);
	textcolor(WHITE);

	// print some text at a location
	cputsxy(0, 1, "Hello, World!\n");

	// skip a line
	gotoxy(0, 3);

	// set inverse text and use printf to output a string
	revers(1);
	char *name = "Mark";
	printf("Hello, %s - press a key!\n", name);

	// wait for user keypress
	waitkey();

	// clear screen
	clrscr();

	// reset reverse and do some scrolling lines.
	revers(0);
	for(int i: 0..50) {
		printf("Scrolling lines ... %d\n", i);
	}
	waitkey();

	// turn scroll off and do more lines
	scroll(0);
	for(int i: 51..200) {
		printf("Some wrapping lines ... %d\n", i);
	}
	waitkey();

}

void waitkey() {
	while(!kbhit()) ;
	clrkb();
}
