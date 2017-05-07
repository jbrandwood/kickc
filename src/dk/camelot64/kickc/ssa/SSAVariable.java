package dk.camelot64.kickc.ssa;

/** An SSA form Variable. SSA form variables come in different flavors:
 * <ul>
 *    <li>Each potential modification of a language variable becomes a separate versioned SSA variable.</li>
 *    <li>Expressions are broken into separate SSA statements, each defining a new temporary/intermediate variable.</li>
 * </ul>
 *
 * Named variables are initially created without serials. These are first added after the basic control blocks have been defined.
 *
 * */
public class SSAVariable implements SSARValue, SSALValue, SSAFragment {

   private String name;

   private Integer serial;

   public SSAVariable(String name) {
      this.name = name;
      this.serial = null;
   }

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
      return name + (serial==null?"":"_"+serial);
   }
}
