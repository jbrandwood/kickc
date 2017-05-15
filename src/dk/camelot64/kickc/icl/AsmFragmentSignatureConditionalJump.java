package dk.camelot64.kickc.icl;

/** Assembler Fragment Signature for a conditional jump */
public class AsmFragmentSignatureConditionalJump extends AsmFragmentSignature {
   public AsmFragmentSignatureConditionalJump(StatementConditionalJump conditionalJump, SymbolTable symbols) {
      super(symbols);
      StringBuilder signature = new StringBuilder();
      signature.append(bind(conditionalJump.getCondition()));
      signature.append("?");
      signature.append(bind(conditionalJump.getDestination()));
      setSignature(signature.toString());
   }
}
