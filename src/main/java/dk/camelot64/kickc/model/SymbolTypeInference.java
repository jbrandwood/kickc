package dk.camelot64.kickc.model;

/** Type inference of expressions (rValues & unary/binary operators) */
public class SymbolTypeInference {

   public static SymbolType inferType(Operator operator, SymbolType subType) {
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
         case "<":
         case ">":
            if(subType instanceof SymbolTypePointer || SymbolTypeBasic.WORD.equals(subType)) {
               return SymbolTypeBasic.BYTE;

            }
         default:
            return subType;
      }
   }

   public static SymbolType inferType(SymbolType type1, Operator operator, SymbolType type2) {
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
            if (type1.equals(SymbolTypeBasic.STRING) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.STRING;
            } else if (type1.equals(SymbolTypeBasic.STRING) && SymbolTypeBasic.STRING.equals(type2)) {
            return SymbolTypeBasic.STRING;
         }
         case "-":
            // Also continues "+"
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
            } else if (SymbolTypeBasic.SBYTE.equals(type1) && SymbolTypeBasic.SBYTE.equals(type2)) {
               return SymbolTypeBasic.SBYTE;
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
            } else if (SymbolTypeBasic.SBYTE.equals(type1) && SymbolTypeBasic.SBYTE.equals(type2)) {
               return SymbolTypeBasic.SBYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*idx":
            if(type1 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type1).getElementType();
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "/":
            if (type1 instanceof SymbolTypePointer && SymbolTypeBasic.BYTE.equals(type2)) {
               return type1;
            }
         case "&":
         case "|":
         case "^":
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

   public static SymbolType inferType(ProgramScope programScope, RValue rValue) {
      SymbolType type = null;
      if (rValue instanceof VariableRef) {
         Variable variable = programScope.getVariable((VariableRef) rValue);
         type = variable.getType();
      } else if (rValue instanceof ConstantRef) {
         ConstantVar constVar = programScope.getConstant((ConstantRef) rValue);
         type = constVar.getType();
      } else if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof ConstantInteger) {
         ConstantInteger rInt = (ConstantInteger) rValue;
         return rInt.getType(programScope);
      } else if (rValue instanceof ConstantString) {
         type = SymbolTypeBasic.STRING;
      } else if (rValue instanceof ConstantChar) {
         type = SymbolTypeBasic.BYTE;
      } else if (rValue instanceof ConstantBool) {
         type = SymbolTypeBasic.BOOLEAN;
      } else if (rValue instanceof ConstantUnary) {
         ConstantUnary constUnary = (ConstantUnary) rValue;
         SymbolType subType = inferType(programScope, constUnary.getOperand());
         return inferType(constUnary.getOperator(), subType);
      } else if (rValue instanceof ConstantBinary) {
         ConstantBinary constBin = (ConstantBinary) rValue;
         SymbolType leftType = inferType(programScope, constBin.getLeft());
         SymbolType rightType = inferType(programScope, constBin.getRight());
         return inferType(leftType, constBin.getOperator(), rightType);
      } else if(rValue instanceof PointerDereferenceSimple) {
         SymbolType pointerType = inferType(programScope, ((PointerDereferenceSimple) rValue).getPointer());
         if(pointerType instanceof SymbolTypePointer) {
            return ((SymbolTypePointer) pointerType).getElementType();
         } else {
            throw new RuntimeException("Cannot infer pointer element type from pointer type "+pointerType);
         }
      }
      if (type == null) {
         throw new RuntimeException("Cannot infer type for " + rValue);
      }
      return type;
   }
}
