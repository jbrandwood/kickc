package dk.camelot64.kickc.ssa;

/** Manages creation of new variables from declarations or temporary (intermediate) */
public class SSAVariableManager {

   private int nxtTemporaryId = 1;

   public SSAVariable generateIntermediateVariable() {
      return new SSAVariable("@", nxtTemporaryId++);
   }

}
