package dk.camelot64.kickc.model.values;

/** A reference to a procedure */
public class ProcedureRef extends CallingScopeRef implements RValue {

   public ProcedureRef(String fullName) {
      super(fullName);
   }

   /**
    * Get the label of the block where the procedure code starts
    *
    * @return The label of the code block
    */
   public LabelRef getLabelRef() {
      return new LabelRef(getFullName());
   }

   /**
    * Get the label of the block containing the final procedure return
    *
    * @return The label of the code block
    */
   public LabelRef getReturnBlock() {
      return new LabelRef(getFullName() + "::" + SymbolRef.PROCEXIT_BLOCK_NAME);
   }
}
