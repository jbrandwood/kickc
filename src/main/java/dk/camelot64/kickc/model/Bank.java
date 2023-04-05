package dk.camelot64.kickc.model;



/**
 *
 * <p>
 * Specific target computer platforms implement a memory layout that can be banked either in ram or rom.
 * This class models the capability to calculate which function call implementations are banked and which not.
 * <br>Since banking implementations are specific to the target computer platform,
 * specific assembler fragments are available in the compiler,
 * that model the implementation of the banking, depending on:
 *
 * <ul>
 * <li>the computer target computer <b><i>platform</i></b>.</li>
 * <li>the bank <b><i>method</i></b> of function call implementation at the call location.</li>
 * </ul>
 *
 * <p>The <b></b><i>method</i></b> can implement different banking implementations,
 * depending on the required function call speed,
 * the banking routine availability in the kernal (rom) of the target computer <b><i>platform</i></b>
 * or even using specific designed banking routines by kickc to provide alternatives for banking methods.
 * The <b><i>method</i></b> and the <b><i>platform</i></b> are the key combinations that select the fragments
 * in kickc to generate the banked function call implementations used by the compiler.
 *
 * <p>Your C-code can be augmented with 3 new directives, that define which function(s) will be declared as banked:
 *
 * <br><ul>
 *   <li><b>#pragma bank( <i>method</i>, <i>number</i> )</b> directive, defines for sequent functions
 *   the target bank <b><i>number</i></b> and the <b><i>method</i></b> for the banked function call implementations.</li>
 *   <li>A new <b>#pragma nobank( dummy )</b> directive, resets the calculation of banking for sequent functions
 *   not to calculate any banking for these functions.</li>
 *   <li>A new <b>__bank( <i>method</i>, <i>number</i> )</b> directive, defines for one function a
 *   target bank <b><i>number</i></b> and the <b><i>method</i></b> for the banked function call implementation.</li>
 * </ul>
 *
 * <p>The compiler decides automatically the function call implementation, which can be either banked or not.
 * And if the function call implementation is banked, it should use the specified bank number to implement
 * the banked function call.
 * The rules can be summarized as follows:
 *
 * <ul>
 *     <li>If a function is declared <b>not banked</b>, and the function call location is <b>not banked</b>,
 *     the function call implementation will be <b>not banked</b>.</li>
 *     <li>If a function is declared <b>banked</b>, and the function call location is not <b>banked</b>,
 *     the function call implementation will be <b>banked</b>.</li>
 *     <li>If a function is declared <b>not banked</b>, and the function call location is <b>banked</b>,
 *     the function call implementation will be <b>not banked</b>.</li>
 *     <li>If a function is declared <b>banked</b>, and the function call location is <b>banked</b>,
 *     but the function call location is within the same bank,
 *     the function call implementation will be <b>not banked</b>.</li>
 *     <li>If a function is declared <b>banked</b>, and the function call location is <b>banked</b>,
 *     but the function call location is <b>not within the same bank</b>,
 *     the function call implementation will be <b>banked</b>.</li>
 * </ul>
 *
 * <p>The usage of <b>#pragma code_seg( <i>segment</i> )</b> directive
 * is very important! The <b>#pragma code_seg( <i>segment</i> )</b> directive utilization
 * in harmony with the <b>#pragma bank( <i>method</i>, <i>number</i> )</b> directive
 * makes the overall banking implementation work for your program.
 *
 * <p>
 * <ul>
 *     <li>KickC uses the <b>#pragma code_seg( <i>segment</i> )</b> directive to calculate the
 *         <b>addressing</b> of the allocation of the function code within main or banked memory.</li>
 *     <li>KickC uses the <b>#pragma bank( <i>method</i>, <i>number</i> )</b> directive or
 *         <b>__bank( <i>method</i>, <i>number</i> )</b> directive to calculate the function call implementation
 *         at the function calling locations!</li>
 * </ul>
 *
 * <p>
 * The best way to describe the usage with a comprehensive example, documenting the different use cases
 * how the compiler decides which functions are banked or not,
 * and how the resulting banked function call code will be generated.
 * <p>
 * The example implements several functions in various forms to allocate the code in main memory
 * using segment <b>Code</b> and within 3 banked memory locations, using segments <b>Bank1</b>, <b>Bank2</b>, <b>Bank3</b>.
 * In order to ensure a good understanding of the example, the usage of these code segments in harmony with the
 * banking directives must be described, which is absolutely necessary to master,
 * in order to make banked function calls work.
 *
 * <p>
 * <ul>
 *     <li>The #pragma directive <b>code_seg( Code )</b> defines the sequent function code to be allocated
 *     within main (not banked) memory, defined within segment <b>Code<><b/> by the linker.</li>
 *     <li>The #pragma directive <b>code_seg( Bank1 )</b> defines the sequent function code to be allocated
 *     within banked memory, defined within segment <b>Bank1</b> by the linker.</li>
 *     <li>The #pragma directive <b>code_seg( Bank2 )</b> defines the sequent function code to be allocated
 *     within banked memory, defined within segment <b>Bank2</b> by the linker.</li>
 *     <li>The #pragma directive <b>code_seg( Bank3 )</b> defines the sequent function code to be allocated
 *     within banked memory, defined within segment <b>Bank3</b> by the linker.</li>
 * </ul>
 *
 * Note that the <b>Code</b> segment is the default location in KickC where the code is placed by the linker.
 *
 * Find below the code example, which is also the program procedure-callingconvention-phi-bank-5.c
 *
 * <pre>
 *
 * // The linker specification of the different segments.
 * #pragma link("procedure-callingconvention-phi-bank-5.ld")
 *
 * // The target computer platform is the Commander X16,
 * // which implements banking in ram between 0xA0000 and 0xBFFF,
 * // and in rom between 0xC000 and 0xFFFF.
 * #pragma target(cx16)
 *
 * char *const SCREEN = (char *)0x0400; // Just for test purposes.
 *
 * #pragma code_seg(Bank1) // The sequent functions will be addressed specified by segment bank1 in the linker.
 * #pragma bank(ram, 1)    // The sequent functions will be banked using call method ram in bank number 1.
 *
 * // Function declarations
 * char func_ram_bank1_a(char a, char b);
 * char __bank(ram, 1) func_ram_bank1_b(char a, char b);
 * char func_ram_bank1_c(char a, char b);
 * char func_ram_bank1_d(char a, char b);
 * char func_ram_bank1_e(char a, char b);
 * char func_ram_bank1_f(char a, char b);
 * char func_rom_bank2_a(char a, char b);
 * char __bank(rom, 2) func_rom_bank2_b(char a, char b);
 * char func_rom_bank2_c(char a, char b);
 * char func_rom_bank2_d(char a, char b);
 * char func_rom_bank2_e(char a, char b);
 * char func_rom_bank2_f(char a, char b);
 * char func_main_a(char a, char b);
 * char func_main_b(char a, char b);
 *
 * // Functional code
 *
 * char func_ram_bank1_a(char a, char b) {
 *     return a + b;
 * }
 *
 * char func_ram_bank1_c(char a, char b) {
 *     return func_ram_bank1_a(a, b);               // Non banked call in ram bank 1.
 * }
 *
 * char func_ram_bank1_d(char a, char b) {
 *     return func_rom_bank2_a(a, b);               // Banked call from ram bank 1 to rom bank 2.
 * }
 *
 * char func_ram_bank1_e(char a, char b) {
 *     return func_rom_bank2_b(a, b);               // Banked call from ram bank 1 to rom bank 2.
 * }
 *
 * char func_ram_bank1_f(char a, char b) {
 *     return func_main_a(a, b);                    // Non banked call from ram bank 1 to main memory.
 * }
 *
 *
 * #pragma code_seg(Bank2) // The sequent functions will be addressed specified by segment bank2 in the linker.
 * #pragma bank(rom, 2)    // The sequent functions will be banked using call method rom in bank number 2.
 *
 * char func_rom_bank2_a(char a, char b) {
 *     return a + b;
 * }
 *
 * char func_rom_bank2_c(char a, char b) {
 *     return func_ram_bank1_a(a, b);              // Banked call from rom bank 2 to ram bank 1.
 * }
 *
 * char func_rom_bank2_d(char a, char b) {
 *     return func_rom_bank2_a(a, b);              // Non banked call in rom bank 2.
 * }
 *
 * char func_rom_bank2_e(char a, char b) {
 *     return func_rom_bank2_b(a, b);              // Non Banked call in rom bank 2.
 * }
 *
 * char func_rom_bank2_f(char a, char b) {
 *     return func_main_a(a, b);                   // Non banked call from rom bank 2 to main memory.
 * }
 *
 *
 * #pragma nobank(dummy) // The sequent functions will consider no banking calculations anymore.
 *
 * // The __bank directive declares this function to be banked using call method ram in bank number 1 of banked ram.
 * char __bank(ram, 1) func_ram_bank1_b(char a, char b) {
 *     return a + b;
 * }
 *
 * // The __bank directive declares this function to be banked using call method rom in bank number 2 of banked rom.
 * char __bank(rom, 2) func_rom_bank2_b(char a, char b) {
 *     return a + b;
 * }
 *
 * #pragma code_seg(Code) // The sequent functions will be addressed in the default main memory location (segment Code).
 *
 * // Allocated in main memory.
 * char func_main_a(char a, char b) {
 *     return func_ram_bank1_e(a, b); // Banked call to ram in bank 1 from main memory.
 * }
 *
 * // Allocated in main memory.
 * char func_main_b(char a, char b) {
 *     return func_rom_bank2_e(a, b); // Banked call to rom in bank 2 from main memory.
 * }
 *
 * // Practically this means that the main() function is placed in main memory ...
 *
 * void main(void) {
 *     SCREEN[0] = func_ram_bank1_a('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_ram_bank1_b('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_ram_bank1_c('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_ram_bank1_d('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_ram_bank1_e('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_ram_bank1_f('0', 7); // Banked call to ram in bank 1 from main memory.
 *     SCREEN[0] = func_rom_bank2_a('0', 7); // Banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_rom_bank2_b('0', 7); // Banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_rom_bank2_c('0', 7); // Banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_rom_bank2_d('0', 7); // Banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_rom_bank2_e('0', 7); // banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_rom_bank2_f('0', 7); // banked call to rom in bank 2 from main memory.
 *     SCREEN[0] = func_main_a('0', 7);  // Near call in main memory from main memory.
 *     SCREEN[0] = func_main_b('0', 7);  // Near call in main memory from main memory.
 * }
 * </pre>
 */
public class Bank {

   private final String bankArea; // The bank method to apply.
   private Long bank; // The bank number.

   public Bank(String bankArea, Long bank) {
      this.bankArea = bankArea;
      this.bank = bank;
   }

   public String getBankArea() {
      return bankArea;
   }

   public Long getBank() {
      return bank;
   }

   public void setBank(Long bank) {
      this.bank = bank;
   }
}
