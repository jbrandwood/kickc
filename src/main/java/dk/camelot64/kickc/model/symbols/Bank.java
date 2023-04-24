package dk.camelot64.kickc.model.symbols;

/**
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
 * <p><br>Your C-code can be augmented with 3 new directives, that define which function(s) will be declared as banked:
 *
 * <br><ul>
 *   <li><b>#pragma bank( <i>area</i>, <i>number</i> )</b> directive, defines for sequent functions
 *   the the <b><i>area</i></b> and the bank <b><i>number</i></b>.</li>
 *   <li>A new <b>#pragma nobank( dummy )</b> directive, resets the calculation of banking
 *   for the sequent functions.</li>
 *   <li><b>__bank( <i>area</i>, <i>number</i> )</b> directive, defines for one function a
 *   target bank <b><i>area</i></b> and <b><i>number</i></b>.</li>
 * </ul>
 * <p>Examples of bank areas are different RAM and/or ROM areas at different
 * zones in the linear memory addressing space, and may or may not overlap.
 * Each banking area has its own configuration in the target computer platform and
 * operate independently from each other.<br>
 * For example, the Commander X16 has 256 RAM bank between 0xA000 and 0xBFFF and
 * 256 ROM banks from 0xC000 till 0xFFFF. Each RAM bank is configured through zero page $00
 * and each ROM bank is configured through zero page $01.
 * The compiler configures for you these registers, depending on the configured banking area of the function,
 * when a banked call is required.</p>
 *
 * <p><br>There are different types of function calls that can be implemented, depending on:
 * <ul>
 *     <li>the banked location of either or both the caller and/or the called function.</li>
 *     <li>the banking area of either or both the caller and the called function.</li>
 * </ul>
 *
 * <p>The <b>types of (banked) function call implementations</b> are:
 * <ul>
 *     <li><b>near</b> - jump to subroutine without any implementation of banking logic.</li>
 *     <li><b>close</b> - jump to subroutine with inline banking implementation logic.</li>
 *     <li><b>far</b> - jump to subroutine using a specific trampoline banking implementation logic.</li>
 * </ul>
 * Depending on the target platform of the system the <b>far</b> calls are likely the most complex
 * and will consume the most CPU cycles. Therefore, careful design of the program flow and the
 * placement of the functions in the banks need to be done, to avoid as much as possible these far calls.
 *
 * <p><br>The exact rules when <b>near</b>, <b>close</b> and <b>far</b> calls are implemented by the compiler,
 * can be summarized in the following 6 cases:
 *
 * <ul>
 *     <li><b>case #1</b> - If the caller function is <b>not banked</b>,<br>
 *     and the called function is <b>not banked</b>,<br>
 *     then a <b>near</b> call will be implemented.</li>
 *     <li><b>case #2</b> - If the caller function is <b>not banked</b>,<br>
 *     and the called function is <b>banked</b> in any bank in any banking area</b>,<br>
 *     then a <b>close</b> call will be implemented.</li>
 *     <li><b>case #3</b> - If the caller function is <b>banked</b> in any bank in any banking area,<br>
 *     and the called function is <b>not banked</b>,<br>
 *     then a <b>near</b> call will be implemented.</li>
 *     <li><b>case #4</b> - If the caller function is <b>banked</b>,<br>
 *     and the called function is <b>banked</b>,<br>
 *     and both functions are <b>in the same bank</b> and <b>in the same bank area</b>,<br>
 *     then a <b>near</b> call will be implemented.</li>
 *     <li><b>case #5</b> - If the caller function is <b>banked</b>,<br>
 *     and the called function is <b>banked</b>,<br>
 *     and both functions are <b>in a different bank</b> but <b>in the same bank area</b>,<br>
 *     then a <b>far</b> call will be implemented.</li>
 *     <li><b>case #6</b> - If the caller function is <b>banked</b>,<br>
 *     and the called function is <b>banked</b>,<br>
 *     and both functions are <b>in any bank</b> but <b>in a different bank area</b>,<br>
 *     then the a <b>close</b> call will be implemented.</li>
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
 * <p>
 * The KickC compiler contains several test cases and examples which demonstrate the usage of the banking system.
 *
 * @param bankArea The bankable area name.
 * @param bankNumber The bank number.
 */
public record Bank(String bankArea, Long bankNumber) {

   /**
    * Creates a new Bank which collects the necessary data to handle banking.
    * For example, on the Commander X16, RAM is banked from address 0xA000 till 0xBFFF.
    * Zeropage 0x00 configures this banked RAM, with a number from 0x00 till 0xff.
    * So "Banked RAM" is is a bankArea, and the bank is a configurable bank number in the bankArea.
    *
    * @param bankArea A bank area is a memory range that is banked on a target platform.
    * @param bankNumber A bank is a number that defines a bank configuration in a bank area.
    */
   public Bank {
   }

   /** The common/shared bank which is always visible. */
   public static Bank COMMON = new Bank("", 0L);

   /**
    * Is this the common/shared bank which is always visible.
    * @return True if this is the common bank
    */
   public boolean isCommon() {
      return COMMON.equals(this);
   }

   @Override
   public String toString() {
      if(isCommon()) {
         return "";
      } else {
         return "__bank(" + this.bankArea() + ", " + this.bankNumber() + ") ";
      }
   }

   /** The bank distance between a caller and callee, which will determine the type of call needed. */
   public enum CallingDistance {
      /** Caller and callee are both in the same bank or in the common bank. No bank change is needed.  */
      NEAR,
      /** Caller is in the common bank or a different banking area. A direct bank change is needed. */
      CLOSE,
      /** Caller and callee are different banks of the same banking area. A trampoline bank change is needed. */
      FAR;

      public static CallingDistance forCall(Bank from, Bank to) {
         if(to.isCommon()) {
            // NEAR: call to the common bank
            return NEAR;
         } else if(to.equals(from)) {
            // NEAR: call to the same bank in the same banking area
            return NEAR;
         } else if(from.isCommon()) {
            // CLOSE: call from common bank to any bank
            return CLOSE;
         } else if(!from.bankArea().equals(to.bankArea())) {
            // CLOSE: from one banking area to another
            return CLOSE;
         } else {
            // FAR:   banked to different bank in same bank area
            return FAR;
         }
      }

      @Override
      public String toString() {
         return name().toLowerCase();
      }

   }
}
