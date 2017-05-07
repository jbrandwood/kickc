package dk.camelot64.kickc.ssa;

/** A label representing a target of a jump in SSA code */
public class SSAJumpLabel {

   private String name;

   public SSAJumpLabel(String name) {
      this.name = name;
   }

   @Override
   public String toString() {
      return name;
   }
}
