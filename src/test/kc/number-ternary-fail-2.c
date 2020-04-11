// Failing number type resolving in ternary operator
// Currently fails in the ternary operator with number-issues if integer literal is not specified!

#include <stdlib.h>

void SolveMaze(char *maze, word width, word height) {

  word count=0;
  word x=3, y=2;
  word forward=0;

  while(x != (width - 2) || y != (height - 2)) {

   maze[y * width + x] = forward ? 2 : 3;
   if ( 1 == 1 ) {
        forward = 1;  // <- HERE
    } else {
	forward = 0;
	count = 0;
    }
  }
}

void main() {

  word width=18 * 2 + 3;
  word height=6 * 2 + 3;
  char *maze;
  maze = malloc(width * height);

  SolveMaze(maze, width, height);

  free(maze);
  asm {loop: jmp loop }
}

