package dk.camelot64.kickc.icl;

/** A reference to a procedure */
public class ProcedureRef extends SymbolRef {

   public ProcedureRef(String fullName) {
      super(fullName);
   }

   public LabelRef getLabelRef() {
      return new LabelRef(getFullName());
   }
}
