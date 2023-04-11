/**
 * @file call-banked-phi-case-1-near-0.c
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @author Jesper Gravgaard
 * @brief Test a procedure with calling convention PHI - case #1.
 * @version 0.1
 * @date 2023-04-11
 * 
 * @copyright Copyright (c) 2023
 * 
 * The following cases exist in banked calling implementations:
 * 
 *   - case #1 - unbanked to unbanked and no banking areas
 *   - case #2 - unbanked to banked to any bank area
 *   - case #3 - banked to unbanked from any bank area
 *   - case #4 - banked to same bank in same bank area
 *   - case #5 - banked to different bank in same bank area
 *   - case #6 - banked to any bank between different bank areas
 * 
 * This brings us to the call types:
 * 
 *   - near = case #1, #3, #4
 *   - close = case #2, #6
 *   - far = case #5 
 * 
 */

#pragma link("call-banked-phi.ld")

char* const SCREEN = (char*)0x0400;

#pragma code_seg(Code)
void main(void) {
    SCREEN[0] = plus('0', 7); // near call
}

#pragma code_seg(Code)
char plus(char a, char b) {
    return a+b;
}
