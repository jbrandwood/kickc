// Tests procedures using global variables (should not fail)
byte* SCREEN = (byte*)$400;
void main() {
   *SCREEN = 1;
}