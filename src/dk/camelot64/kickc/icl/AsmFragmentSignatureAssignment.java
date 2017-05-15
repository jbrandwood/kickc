package dk.camelot64.kickc.icl;

/** Assembler Fragemnt Signature for an assignment  */
public class AsmFragmentSignatureAssignment extends AsmFragmentSignature {

   public AsmFragmentSignatureAssignment(StatementAssignment assignment, SymbolTable symbols) {
      super(symbols);
      setSignature(assignment.getLValue(), assignment.getRValue1(), assignment.getOperator(), assignment.getRValue2());
   }

   public AsmFragmentSignatureAssignment(LValue lValue, RValue rValue, SymbolTable symbols) {
      super(symbols);
      setSignature(lValue, null, null, rValue);
   }

   private void setSignature(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
      StringBuilder signature = new StringBuilder();
      signature.append(bind(lValue));
      signature.append("=");
      if (rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if (operator != null) {
         signature.append(operator.getOperator());
      }
      signature.append(bind(rValue2));
      setSignature(signature.toString());
   }


}
