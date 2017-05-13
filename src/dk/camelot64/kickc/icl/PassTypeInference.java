package dk.camelot64.kickc.icl;

/**
 * Pass through the SSA statements inferring types of unresolved variables.
 */
public class PassTypeInference {

   public void inferTypes(StatementSequence sequence, SymbolTable symbols) {
      for (Statement statement : sequence.getStatements()) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            Variable symbol = (Variable) assignment.getlValue();
            if (SymbolType.VAR.equals(symbol.getType())) {
               // Unresolved symbol - perform inference
               Operator operator = assignment.getOperator();
               if (operator == null || assignment.getRValue1() == null) {
                  // Copy operation or Unary operation
                  RValue rValue = assignment.getRValue2();
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

   private SymbolType inferType(SymbolType type1, Operator operator, SymbolType type2) {
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

   public static SymbolType inferType(RValue rValue) {
      SymbolType type = SymbolType.VAR;
      if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof ConstantInteger) {
         ConstantInteger rInt = (ConstantInteger) rValue;
         if (rInt.getNumber() < 256) {
            type = SymbolType.BYTE;
         } else {
            type = SymbolType.WORD;
         }
      } else if (rValue instanceof ConstantString) {
         type = SymbolType.STRING;
      } else if (rValue instanceof ConstantBool) {
         type = SymbolType.BOOLEAN;
      }
      return type;
   }

}
