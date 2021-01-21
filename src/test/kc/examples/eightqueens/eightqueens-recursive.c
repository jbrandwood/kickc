// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.  
//
// This is a recursive solution

#include <stdio.h>
#include <conio.h>

#define QUEENS 8
#define PRINT_SOLUTIONS

// The board. board[i] holds the column position of the queen on row i. 
char board[20];

// The number of found solutions
unsigned long count = 0; 

void main() {
  clrscr();
  printf(" - n queens problem using backtracking -");
  printf("\nnumber of queens:%u",QUEENS);
  queen(1);
  printf("\n\nsolutions: %lu.\n",count);
}
 
// Generates all valid placements of queens on a NxN board recursively
// Works by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then recursively generating all legal placements on the rows above.  
__stackcall void queen(char row) {
  __ma char r = row;
  for(__ma char column=1;column<=QUEENS;++column) {
    if(legal(r,column)) {
      //no conflicts so place queen
      board[r]=column; 
      if(r==QUEENS) {
        // A solution! Print the board configuration
        count++;
        #ifdef PRINT_SOLUTIONS
        print(); 
        #endif
      } else {
        // Perform recussive placement on rows above
        // Push the local vars on the stack (waiting for proper recursion support)
        asm {
          lda column
          pha
          lda r
          pha
        }
        // Do recursion        
        queen(r+1);
        // Pop the local vars on the stack (waiting for proper recursion support)
        asm {
          pla 
          sta r
          pla 
          sta column
        }
      }
    }
  }
}
 
// Checks is a placement of the queen on the board is legal.
// Checks the passed (row, column) against all queens placed on the board on lower rows.
// If no conflict for desired position returns 1 otherwise returns 0
char legal(char row,char column) {
  for(char i=1;i<=row-1;++i) {
    if(board[i]==column)
      // The same column is a conflict.
      return 0;
    else
    if(diff(board[i],column)==diff(i,row))
      // The same diagonal is a conflict.
      return 0;
  }
  // Placement is legal
  return 1;
}

// Find the absolute difference between two unsigned chars
char diff(char a, char b) {
  if(a<b)
    return b-a;
  else
    return a-b;
}

// Print the board with a legal placement. Also increments the solution count.
void print() {
  gotoxy(0,5);
  printf("\n#%lu:\n ",count);
  for(char i=1;i<=QUEENS;++i)
    printf("%x",i);
  for(char i=1;i<=QUEENS;++i) {
    printf("\n%x",i);
    for(char j=1;j<=QUEENS;++j) {
      if(board[i]==j)
        printf("Q");
      else
        printf("-");
    }
  }
}