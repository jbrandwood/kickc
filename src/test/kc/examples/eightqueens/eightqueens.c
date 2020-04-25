// N Queens Problem in C Using Backtracking
//
// N Queens Problem is a famous puzzle in which n-queens are to be placed on a nxn chess board such that no two queens are in the same row, column or diagonal. 
// In this tutorial I am sharing the C program to find solution for N Queens problem using backtracking. Below animation shows the solution for 8 queens problem using backtracking.
// 
// Author: Neeraj Mishra
// Source: https://www.thecrazyprogrammer.com/2015/03/c-program-for-n-queens-problem-using-backtracking.html

#include<stdio.h>
 
char board[20],count;

#define N 8

void main() {
  printf_cls();
  printf(" - N Queens Problem Using Backtracking -");
  printf("\n\nNumber of Queens:%u",N);
  queen(1);
}
 
// Function to check for proper positioning of queen
__stackcall void queen(char row) {
  __ma char r = row;
  for(__ma char column=1;column<=N;++column) {
    if(place(r,column)) {
      board[r]=column; //no conflicts so place queen
      if(r==N) //dead end
        print(); //printing the board configuration
      else {
        // Push the local vars on the stack (waiting for proper recursion support)
        asm {
          lda column
          pha
          lda r
          pha
        }
        //try queen with next position
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
 
// function to check conflicts
// If no conflict for desired postion returns 1 otherwise returns 0
char place(char row,char column) {
  char i;
  for(i=1;i<=row-1;++i) {
    //checking column and digonal conflicts
    if(board[i]==column)
      return 0;
    else
    if(diff(board[i],column)==diff(i,row))
      return 0;
  }
  return 1; //no conflicts
}

// Find the absolute difference between two unsigned chars
char diff(char a, char b) {
  if(a<b)
    return b-a;
  else
    return a-b;
}

//function for printing the solution
void print() {
  printf("\nSolution %u:\n ",++count);
  for(char i=1;i<=N;++i)
    printf("%u",i);
  for(char i=1;i<=N;++i) {
    printf("\n%u",i);
    for(char j=1;j<=N;++j) {
      //for nxn board
      if(board[i]==j)
        printf("Q"); //queen at i,j position
      else
        printf("-"); //empty slot
    }
  }
}