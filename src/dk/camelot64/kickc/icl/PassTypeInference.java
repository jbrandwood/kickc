package dk.camelot64.kickc.icl;

/**
 * Pass through the SSA statements inferring types of unresolved variables.
 */
public class PassTypeInference {

   public void inferTypes(StatementSequence sequence, SymbolTable symbols) {
      for (Statement statement : sequence.getStatements()) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            Variable symbol = (Variable) assignment.getLValue();
            if (SymbolTypeBasic.VAR.equals(symbol.getType())) {
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
            return SymbolTypeBasic.BOOLEAN;
         case "+":
         case "-":
         case "*":
         case "/":
            if (type1.equals(SymbolTypeBasic.WORD) || type2.equals(SymbolTypeBasic.WORD)) {
               return SymbolTypeBasic.WORD;
            } else {
               return SymbolTypeBasic.BYTE;
            }
         default:
            throw new RuntimeException("Type inference case not handled "+type1+" "+operator+" "+type2);
      }
   }

   public static SymbolType inferType(RValue rValue) {
      SymbolType type = null;
      if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof ConstantInteger) {
         ConstantInteger rInt = (ConstantInteger) rValue;
         if (rInt.getNumber() < 256) {
            type = SymbolTypeBasic.BYTE;
         } else {
            type = SymbolTypeBasic.WORD;
         }
      } else if (rValue instanceof ConstantString) {
         type = SymbolTypeBasic.STRING;
      } else if (rValue instanceof ConstantBool) {
         type = SymbolTypeBasic.BOOLEAN;
      }
      if(type==null) {
         throw new RuntimeException("Cannot infer type for "+rValue);
      }
      return type;
   }

}
