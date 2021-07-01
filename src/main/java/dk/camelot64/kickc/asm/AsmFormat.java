package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

/** Formatting of numbers, constants, names and more for KickAssembler */
public class AsmFormat {

   /**
    * Get ASM code for a constant value
    *
    * @param value The constant value
    * @param precedence The precedence of the outer expression operator. Used to generate parenthesis when needed.
    * @param codeScope The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @return The ASM string representing the constant value
    */
   public static String getAsmConstant(Program program, ConstantValue value, int precedence, ScopeRef codeScope) {
      if(value instanceof ConstantRef) {
         Variable constantVar = program.getScope().getConstant((ConstantRef) value);
         return getAsmSymbolName(program, constantVar, codeScope);
      } else if(value instanceof ConstantInteger) {
         return getAsmNumber(((ConstantInteger) value).getValue());
      } else if(value instanceof ConstantBool) {
         return getAsmBool(((ConstantBool) value).getBool());
      } else if(value instanceof ConstantChar) {
         ConstantChar constantChar = (ConstantChar) value;
         String escapedChar = constantChar.getCharEscaped();
         return "'" + escapedChar + "'";
      } else if(value instanceof ConstantString) {
         String stringValue = ((ConstantString) value).getValue();
         String escapedString = ((ConstantString) value).getStringEscaped();
         boolean hasEscape = !stringValue.equals(escapedString);
         return (hasEscape ? "@" : "") + "\"" + escapedString + "\"";
      } else if(value instanceof ConstantUnary) {
         ConstantUnary unary = (ConstantUnary) value;
         Operator operator = unary.getOperator();
         boolean parenthesis = operator.getPrecedence() > precedence;
         return (parenthesis ? "(" : "") +
               getAsmConstantUnary(program, codeScope, operator, unary.getOperand(), precedence) +
               (parenthesis ? ")" : "");
      } else if(value instanceof ConstantBinary) {
         ConstantBinary binary = (ConstantBinary) value;
         OperatorBinary operator = binary.getOperator();
         boolean parenthesis = operator.getPrecedence() > precedence;
         return
               (parenthesis ? "(" : "") +
                     getAsmConstantBinary(program, binary.getLeft(), operator, binary.getRight(), codeScope) +
                     (parenthesis ? ")" : "");
      } else if(value instanceof ConstantPointer) {
         return getAsmNumber(((ConstantPointer) value).getValue());
      } else if(value instanceof ConstantSymbolPointer) {
         SymbolRef toSym = ((ConstantSymbolPointer) value).getToSymbol();
         Symbol symbol = program.getScope().getSymbol(toSym);
         if(symbol instanceof Variable) {
            return getAsmSymbolName(program, symbol, codeScope);
         } else if(symbol instanceof Procedure) {
            return getAsmSymbolName(program, symbol, codeScope);
         } else {
            throw new RuntimeException("Unhandled symbol type " + symbol);
         }
      } else if(value instanceof ConstantCastValue) {
         ConstantCastValue castValue = (ConstantCastValue) value;
         OperatorUnary castOperator = Operators.getCastUnary(castValue.getToType());
         ConstantUnary castUnary = new ConstantUnary(castOperator, castValue.getValue());
         return getAsmConstant(program, castUnary, precedence, codeScope);
      } else {
         throw new RuntimeException("Constant type not supported " + value);
      }
   }

   /**
    * Get ASM for a binary constant expression
    *
    * @param program The program
    * @param left The left operand of the expression
    * @param operator The binary operator
    * @param left The left operand of the expression
    * @param codeScope The scope containing the code being generated.
    * @return
    */
   private static String getAsmConstantBinary(Program program, ConstantValue left, OperatorBinary operator, ConstantValue right, ScopeRef codeScope) {

      if(Operators.MODULO.equals(operator)) {
         // Remainder operator % not supported by KickAss - use modulo function instead
         return "mod(" +
               getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
               "," +
               getAsmConstant(program, right, operator.getPrecedence(), codeScope) +
               ")";
      }

      if(Operators.WORD.equals(operator)) {
         return
               getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
                     "*$100+" +
                     getAsmConstant(program, right, operator.getPrecedence(), codeScope)
               ;
      }

      if(Operators.DWORD.equals(operator)) {
         return
               getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
                     "*$10000+" +
                     getAsmConstant(program, right, operator.getPrecedence(), codeScope)
               ;
      }

      // Handle non-associative operators - only handle right side since parser is left-associative A-B-C = (A-B)-C
      boolean rightParenthesis = false;
      if(!operator.isAssociative()) {
         if(right instanceof ConstantBinary && ((ConstantBinary) right).getOperator().equals(operator)) {
            // Right sub-expression is also binary with the same non-associative operator
            rightParenthesis = true;
         }
      }

      return getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
            operator.getOperator() +
            (rightParenthesis ? "(" : "") + getAsmConstant(program, right, operator.getPrecedence(), codeScope) + (rightParenthesis ? ")" : "");
   }

   /**
    * Get ASM code for a constant unary expression
    *
    * @param program The program
    * @param codeScope The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @param operator The unary operator
    * @param operand The operand of the unary expression
    * @return The ASM string representing the constant value
    */
   private static String getAsmConstantUnary(Program program, ScopeRef codeScope, Operator operator, ConstantValue operand, int outerPrecedence) {
      if(Operators.CAST_BYTE.equals(operator) || Operators.CAST_SBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.BYTE.equals(operandType) || SymbolType.SBYTE.equals(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         }
         try {
            ConstantLiteral constantLiteral = operand.calculateLiteral(program.getScope());
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_BYTE.equals(operator) && SymbolType.BYTE.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_SBYTE.equals(operator) && SymbolType.SBYTE.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
         } catch(ConstantNotLiteral e) {
            // Not literal - do the cast
         }
         // Cast is needed
         return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) 0xff), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
      } else if(operator instanceof OperatorCastPtr || Operators.CAST_WORD.equals(operator) || Operators.CAST_SWORD.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.WORD.equals(operandType) || SymbolType.SWORD.equals(operandType) || SymbolType.BYTE.equals(operandType) || SymbolType.SBYTE.equals(operandType) || operandType instanceof SymbolTypePointer) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         }
         try {
            ConstantLiteral constantLiteral = operand.calculateLiteral(program.getScope());
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_WORD.equals(operator) && SymbolType.WORD.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_SWORD.equals(operator) && SymbolType.SWORD.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
            if(constantLiteral instanceof ConstantInteger && (operator instanceof OperatorCastPtr) && SymbolType.WORD.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
         } catch(ConstantNotLiteral e) {
            // Not literal - do the cast
         }
         // Cast is needed
         return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) 0xffff), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
      } else if(Operators.CAST_DWORD.equals(operator) || Operators.CAST_SDWORD.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.DWORD.equals(operandType) || SymbolType.SDWORD.equals(operandType) || SymbolType.WORD.equals(operandType) || SymbolType.SWORD.equals(operandType) || SymbolType.BYTE.equals(operandType) || SymbolType.SBYTE.equals(operandType) || operandType instanceof SymbolTypePointer) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         }
         try {
            ConstantLiteral constantLiteral = operand.calculateLiteral(program.getScope());
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_DWORD.equals(operator) && SymbolType.DWORD.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
            if(constantLiteral instanceof ConstantInteger && Operators.CAST_SDWORD.equals(operator) && SymbolType.SDWORD.contains(((ConstantInteger) constantLiteral).getValue())) {
               // No cast needed
               return getAsmConstant(program, operand, outerPrecedence, codeScope);
            }
         } catch(ConstantNotLiteral e) {
            // Not literal - do the cast
         }
         // Cast is needed
         return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) 0xffffffffL), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
      } else if(Operators.BYTE0.equals(operator)) {
         // Parenthesis is never needed since operator "<" has the lowest precedence
         return "<" + getAsmConstant(program, operand, operator.getPrecedence(), codeScope);
      } else if(Operators.BYTE1.equals(operator)) {
         // Parenthesis is never needed since operator ">" has the lowest precedence
         return ">" + getAsmConstant(program, operand, operator.getPrecedence(), codeScope);
      } else if(Operators.BYTE2.equals(operator)) {
         // Parenthesis is never needed since operator "<" has the lowest precedence
         return "<" + getAsmConstant(program, new ConstantBinary(operand, Operators.SHIFT_RIGHT, new ConstantInteger((long) 16)), outerPrecedence, codeScope);
      } else if(Operators.BYTE3.equals(operator)) {
         // Parenthesis is never needed since operator ">" has the lowest precedence
         return ">" + getAsmConstant(program, new ConstantBinary(operand, Operators.SHIFT_RIGHT, new ConstantInteger((long) 16)), outerPrecedence, codeScope);
      } else if(Operators.WORD0.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_AND, new ConstantInteger((long) 0xffff)), outerPrecedence, codeScope);
      } else if(Operators.WORD1.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.SHIFT_RIGHT, new ConstantInteger((long) 16)), outerPrecedence, codeScope);
      } else if(Operators.INCREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.PLUS, new ConstantInteger((long) 1)), outerPrecedence, codeScope);
      } else if(Operators.DECREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.MINUS, new ConstantInteger((long) 1)), outerPrecedence, codeScope);
      } else if(Operators.BOOL_NOT.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.BYTE.equals(operandType) || SymbolType.SBYTE.equals(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long) 0xff)), outerPrecedence, codeScope);
         } else if(SymbolType.WORD.equals(operandType) || SymbolType.SWORD.equals(operandType) || operandType instanceof SymbolTypePointer) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long) 0xffff)), outerPrecedence, codeScope);
         } else if(SymbolType.DWORD.equals(operandType) || SymbolType.SDWORD.equals(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long) 0xffffffff)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Operator _bnot_ cannot handle " + operand.toString(program));
         }
      } else if(Operators.POS.equals(operator)) {
         return getAsmConstant(program, operand, outerPrecedence, codeScope);
      } else if(Operators.NEG.equals(operator) && operand instanceof ConstantUnary) {
         return operator.getOperator() + "(" + getAsmConstant(program, operand, operator.getPrecedence(), codeScope) + ")";
      } else if(Operators.NEG.equals(operator) && operand instanceof ConstantInteger && ((ConstantInteger) operand).getInteger() < 0) {
         return operator.getOperator() + "(" + getAsmConstant(program, operand, operator.getPrecedence(), codeScope) + ")";
      } else {
         return operator.getOperator() +
               getAsmConstant(program, operand, operator.getPrecedence(), codeScope);
      }
   }
   
   public static String getAsmNumber(Number number) {
      if(number instanceof Long || number instanceof Integer) {
         if(number.longValue() < 0) {
            return "-" + getAsmNumber(-number.longValue());
         } else if(number.longValue()<10){
            return String.format("%d", number.longValue());
         } else {
            return String.format("$%x", number.longValue());
         }
      }
      throw new RuntimeException("Unsupported number type " + number);
   }

   /**
    * Get the ASM code for a boolean value
    *
    * @param bool the boolean vallue
    * @return "0" / "1"
    */
   private static String getAsmBool(Boolean bool) {
      if(bool) {
         return "1";
      } else {
         return "0";
      }
   }

   /**
    * Get the ASM name for referencing a specific bound constant/ variable
    *
    * @param program The program
    * @param symbol The symbol being referenced
    * @param codeScopeRef The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @return The ASM parameter to use in the ASM code
    */
   public static String getAsmSymbolName(Program program, Symbol symbol, ScopeRef codeScopeRef) {
      ScopeRef symbolScopeRef = symbol.getScope().getRef();
      String asmName = symbol.getLocalName();
      if(symbol instanceof Variable && ((Variable) symbol).getAsmName() != null)
         asmName = ((Variable) symbol).getAsmName();
      if(!symbolScopeRef.equals(codeScopeRef)) {
         if(symbolScopeRef.getFullName().length() > 0)
            // Reference to symbol in another scope
            return asmFix(symbolScopeRef.getFullName() + "." + asmName);
         else {
            // Check if the local code scope has a symbol with the same name
            final Scope codeScope = program.getScope().getScope(codeScopeRef);
            if(codeScope.getLocalSymbol(symbol.getLocalName()) != null)
               // Explicit reference to global symbol
               return "@" + asmFix(asmName);
            else
               // Implicit reference to global symbol
               return asmFix(asmName);
         }
      } else {
         // Reference to local symbol
         return asmFix(asmName);
      }
   }

   /**
    * Fix characters in an ASM parameter/label name. Handles '@:$#'
    *
    * @param source The source string
    * @return The fixed string
    */
   public static String asmFix(String source) {
      StringBuilder result = new StringBuilder();
      char[] sourceChars = source.toCharArray();
      for(char sourceChar : sourceChars) {
         switch(sourceChar) {
            case '@':
               result.append("__b");
               break;
            case ':':
            case '#':
               result.append('_');
               break;
            case '$':
               result.append("__");
               break;
            default:
               result.append(sourceChar);
         }
      }
      return result.toString();
   }


}
