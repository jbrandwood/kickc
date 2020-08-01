// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal.
//
// This is an iterative solution.

#pragma cpu(csg65ce02)

#include<stdio.h>

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
  queens();
  printf("\n\nsolutions: %lu\n",count);
}

// Generates all valid placements of queens on a NxN board without recursion
// Works exactly like the recursive solution by generating all legal placements af a queen for a specific row taking into consideration the queens already placed on the rows below 
// and then moving on to generating all legal placements on the rows above.
// In practice this works like a depth first tree search where the level in the tree is the row on the board and each branch in the tree is the legal placement of a queen on that row. 
// The solution uses the board itself as a "cursor" moving through all possibilities
// When all columns on a row is exhausted move back down to the lower level and move forward one position until we are done with the last position on the first row
void queens() {
  // The current row where the queen is moving
  char row = 1;
  while(1) {
    // Move the queen forward on the current row
    board[row]++;
    if(board[row]==QUEENS+1) {
      // We moved past the end of the row - reset position and go down to the lower row
      board[row] = 0;
      if(row==1)
        // We are done - exit the search loop!
        break;
      else 
        // Move down one row  
        row--;
    } else {
      // check if the current position on row 1-row is legal  
      if(legal(row, board[row])) {
        // position is legal - move up to the next row
        if(row==QUEENS) {
          // We have a complete legal board - print it - and move forward on top row!
          ++count;
          #ifdef PRINT_SOLUTIONS
          print();
          #endif
        } else {
          // Move up to the next row
          row++;
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
inline char diff(char a, char b) {
  if(a<b)
    return b-a;
  else
    return a-b;
}

// Print the board with a legal placement.
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