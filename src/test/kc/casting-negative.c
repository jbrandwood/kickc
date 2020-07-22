// Demonstrates problem with Casting of negative signed values
// https://gitlab.com/camelot/kickc/-/issues/496

#include <conio.h>
#include <stdio.h>

void test_casting(signed short signed_short_value) {
  printf("%d\n", signed_short_value);
}

void main() {
  clrscr();
  signed char signed_char_value = -5;
  while (signed_char_value != 0) {
    ++signed_char_value;
    test_casting(signed_char_value);
    //printf("%d\n", (signed short)signed_char_value);
  }
}
