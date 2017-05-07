package dk.camelot64.kickc.ssa;

/**
 * Pass through the SSA statements inferring types of unresolved variables.
 */
public class PassTypeInference {

   public void inferTypes(SSASequence sequence, SymbolManager symbols) {
      for (SSAStatement statement : sequence.getStatements()) {
         if (statement instanceof SSAStatementAssignment) {
            SSAStatementAssignment assignment = (SSAStatementAssignment) statement;
            Symbol symbol = (Symbol) assignment.getlValue();
            if (SymbolType.VAR.equals(symbol.getType())) {
               // Unresolved symbol - perform inference
               SSAOperator operator = assignment.getOperator();
               if (operator == null || assignment.getRValue1() == null) {
                  // Copy operation or Unary operation
                  SSARValue rValue = assignment.getRValue2();
                  SymbolType type = inferType(rValue);
                  symbol.setInferredType(type);
               } else {
                  // Binary operation
                  SymbolType type1 = inferType(assignment.getRValue1());
                  SymbolType type2 = inferType(assignment.getRValue2());
                  SymbolType type = inferType(type1, operator, type2);
                  symbol.setInferredType(type);
               }
            }
         }
      }
   }

   private SymbolType inferType(SymbolType type1, SSAOperator operator, SymbolType type2) {
      String op = operator.getOperator();
      switch (op) {
         case "==":
         case "<":
         case "<=":
         case "=<":
         case ">":
         case ">=":
         case "=>":
         case "<>":
         case "!=":
         case "&&":
         case "||":
         case "and":
         case "or":
            return SymbolType.BOOLEAN;
         case "+":
         case "-":
         case "*":
         case "/":
            if (type1.equals(SymbolType.WORD) || type2.equals(SymbolType.WORD)) {
               return SymbolType.WORD;
            } else {
               return SymbolType.BYTE;
            }
         default:
            return SymbolType.VAR;
      }
   }

   private SymbolType inferType(SSARValue rValue) {
      SymbolType type = SymbolType.VAR;
      if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof SSAConstantInteger) {
         SSAConstantInteger rInt = (SSAConstantInteger) rValue;
         if (rInt.getNumber() < 256) {
            type = SymbolType.BYTE;
         } else {
            type = SymbolType.WORD;
         }
      } else if (rValue instanceof SSAConstantString) {
         type = SymbolType.STRING;
      } else if (rValue instanceof SSAConstantBool) {
         type = SymbolType.BOOLEAN;
      }
      return type;
   }

}
