package dk.camelot64.kickc.ssa;

/** An SSA form Variable. SSA form variables come in different flavors:
 * <ul>
 *    <li>Each potential modification of a language variable becomes a separate versioned SSA variable.</li>
 *    <li>Expressions are broken into separate SSA statements, each defining a new temporary/intermediate variable.</li>
 * </ul>*/
public class SSAVariable implements SSARValue, SSALValue {

   private String name;

   private int serial;

   public SSAVariable(String name, int serial) {
      this.name = name;
      this.serial = serial;
   }

   public String getName() {
      return name;
   }

   public int getSerial() {
      return serial;
   }

   @Override
   public String toString() {
      return name + '_' + serial;
   }
}
