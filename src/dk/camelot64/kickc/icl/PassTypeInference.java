package dk.camelot64.kickc.icl;

/**
 * Pass through the SSA statements inferring types of unresolved variables.
 */
public class PassTypeInference {

   public void inferTypes(StatementSequence sequence, SymbolTable symbols) {
      for (Statement statement : sequence.getStatements()) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getLValue();
            if (lValue instanceof Variable) {
               Variable symbol = (Variable) lValue;
               if (SymbolTypeBasic.VAR.equals(symbol.getType())) {
                  // Unresolved symbol - perform inference
                  Operator operator = assignment.getOperator();
                  if (operator == null || assignment.getRValue1() == null) {
                     // Copy operation or Unary operation
                     RValue rValue = assignment.getRValue2();
                     SymbolType subType = inferType(rValue);
                     SymbolType type = inferType(operator, subType);
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
   }

   private SymbolType inferType(Operator operator, SymbolType subType) {
      if(operator==null) {
         return subType;
      }
      String op = operator.getOperator();
      switch (op) {
         case "*":
            if(subType instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) subType).getElementType();
            } else {
               throw new RuntimeException("Type error: Dereferencing a non-pointer "+subType);
            }
         default:
            return subType;
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
            if (type1 instanceof SymbolTypePointer && (type2.equals(SymbolTypeBasic.BYTE) || type2.equals(SymbolTypeBasic.WORD))) {
               return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
            }
            if (type1 instanceof SymbolTypePointer && type2 instanceof SymbolTypePointer) {
               SymbolType elmType1 = ((SymbolTypePointer) type1).getElementType();
               SymbolType elmType2 = ((SymbolTypePointer) type2).getElementType();
               return inferType(elmType1, operator, elmType2);
            }
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*":
            if(type1==null && type2 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type2).getElementType();
            }
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*idx":
            if(type1 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type1).getElementType();
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "/":
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "<<":
         case ">>":
            if (SymbolTypeBasic.WORD.equals(type1)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         default:
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
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
      if (type == null) {
         throw new RuntimeException("Cannot infer type for " + rValue);
      }
      return type;
   }

}
