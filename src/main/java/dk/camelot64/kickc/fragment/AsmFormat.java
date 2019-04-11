package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Procedure;
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
    * @param precedence The precedence of the outer expression operator. Used to generate perenthesis when needed.
    * @param codeScope The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @return The ASM string representing the constant value
    */
   public static String getAsmConstant(Program program, ConstantValue value, int precedence, ScopeRef codeScope) {
      if(value instanceof ConstantRef) {
         ConstantVar constantVar = program.getScope().getConstant((ConstantRef) value);
         String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
         return getAsmParamName(constantVar.getScope().getRef(), asmName, codeScope);
      } else if(value instanceof ConstantInteger) {
         return getAsmNumber(((ConstantInteger) value).getValue());
      } else if(value instanceof ConstantBool) {
         return getAsmBool(((ConstantBool) value).getBool());
      } else if(value instanceof ConstantChar) {
         return "'" + ((ConstantChar) value).getValue() + "'";
      } else if(value instanceof ConstantString) {
         return "\"" + ((ConstantString) value).getValue() + "\"";
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
            return getAsmParamName((Variable) symbol, codeScope);
         } else if(symbol instanceof Procedure) {
            return getAsmParamName((Procedure) symbol, codeScope);
         } else {
            throw new RuntimeException("Unhandled symbol type "+symbol);
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
         return "mod("+
               getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
               "," +
               getAsmConstant(program, right, operator.getPrecedence(), codeScope)+
               ")";
      }  else {
         return getAsmConstant(program, left, operator.getPrecedence(), codeScope) +
               operator.getOperator() +
               getAsmConstant(program, right, operator.getPrecedence(), codeScope);
      }
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
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xff), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(operator instanceof OperatorCastPtr || Operators.CAST_WORD.equals(operator) || Operators.CAST_SWORD.equals(operator) ) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || SymbolType.isByte(operandType) || SymbolType.isSByte(operandType) || operandType instanceof SymbolTypePointer) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xffff), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(Operators.CAST_DWORD.equals(operator) || Operators.CAST_SDWORD.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xffffffffL), Operators.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(Operators.LOWBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || operandType instanceof SymbolTypePointer || SymbolType.STRING.equals(operandType)) {
            return "<" + getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_AND, new ConstantInteger((long)0xffff)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Unhandled type "+operand);
         }
      } else if(Operators.HIBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            return getAsmConstant(program, new ConstantInteger(0l), outerPrecedence, codeScope);
         } else if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || operandType instanceof SymbolTypePointer || SymbolType.STRING.equals(operandType)) {
            return ">" + getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.SHIFT_RIGHT, new ConstantInteger((long)16)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Unhandled type "+operand);
         }
      } else if(Operators.INCREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.PLUS, new ConstantInteger((long)1)), outerPrecedence, codeScope);
      } else if(Operators.DECREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operators.MINUS, new ConstantInteger((long)1)), outerPrecedence, codeScope);
      } else if(Operators.BOOL_NOT.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long)0xff)), outerPrecedence, codeScope);
         } else if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || operandType instanceof SymbolTypePointer || SymbolType.STRING.equals(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long)0xffff)), outerPrecedence, codeScope);
         } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operators.BOOL_XOR, new ConstantInteger((long)0xffffffff)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Unhandled type "+operand);
         }
      } else {
         return operator.getOperator() +
               getAsmConstant(program, operand, operator.getPrecedence(), codeScope);
      }
   }

   /** String format for all numbers < $100 for speeding up the compilation. */
   private static String SHORT_ASM_NUMBERS[] = {
         "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "$a", "$b", "$c", "$d", "$e", "$f",
         "$10", "$11", "$12", "$13", "$14", "$15", "$16", "$17", "$18", "$19", "$1a", "$1b", "$1c", "$1d", "$1e", "$1f",
         "$20", "$21", "$22", "$23", "$24", "$25", "$26", "$27", "$28", "$29", "$2a", "$2b", "$2c", "$2d", "$2e", "$2f",
         "$30", "$31", "$32", "$33", "$34", "$35", "$36", "$37", "$38", "$39", "$3a", "$3b", "$3c", "$3d", "$3e", "$3f",
         "$40", "$41", "$42", "$43", "$44", "$45", "$46", "$47", "$48", "$49", "$4a", "$4b", "$4c", "$4d", "$4e", "$4f",
         "$50", "$51", "$52", "$53", "$54", "$55", "$56", "$57", "$58", "$59", "$5a", "$5b", "$5c", "$5d", "$5e", "$5f",
         "$60", "$61", "$62", "$63", "$64", "$65", "$66", "$67", "$68", "$69", "$6a", "$6b", "$6c", "$6d", "$6e", "$6f",
         "$70", "$71", "$72", "$73", "$74", "$75", "$76", "$77", "$78", "$79", "$7a", "$7b", "$7c", "$7d", "$7e", "$7f",
         "$80", "$81", "$82", "$83", "$84", "$85", "$86", "$87", "$88", "$89", "$8a", "$8b", "$8c", "$8d", "$8e", "$8f",
         "$90", "$91", "$92", "$93", "$94", "$95", "$96", "$97", "$98", "$99", "$9a", "$9b", "$9c", "$9d", "$9e", "$9f",
         "$a0", "$a1", "$a2", "$a3", "$a4", "$a5", "$a6", "$a7", "$a8", "$a9", "$aa", "$ab", "$ac", "$ad", "$ae", "$af",
         "$b0", "$b1", "$b2", "$b3", "$b4", "$b5", "$b6", "$b7", "$b8", "$b9", "$ba", "$bb", "$bc", "$bd", "$be", "$bf",
         "$c0", "$c1", "$c2", "$c3", "$c4", "$c5", "$c6", "$c7", "$c8", "$c9", "$ca", "$cb", "$cc", "$cd", "$ce", "$cf",
         "$d0", "$d1", "$d2", "$d3", "$d4", "$d5", "$d6", "$d7", "$d8", "$d9", "$da", "$db", "$dc", "$dd", "$de", "$df",
         "$e0", "$e1", "$e2", "$e3", "$e4", "$e5", "$e6", "$e7", "$e8", "$e9", "$ea", "$eb", "$ec", "$ed", "$ee", "$ef",
         "$f0", "$f1", "$f2", "$f3", "$f4", "$f5", "$f6", "$f7", "$f8", "$f9", "$fa", "$fb", "$fc", "$fd", "$fe", "$ff"
   };

   public static String getAsmNumber(Number number) {
      if(number instanceof Long || number instanceof Integer) {
         // Use cached small numbers. */
         if(number.longValue() >= 0L && number.longValue() <= 255L) {
            return SHORT_ASM_NUMBERS[number.intValue()];
         } else {
            return String.format("$%x", number.longValue());
         }
      }
      throw new RuntimeException("Unsupported number type " + number);
   }

   /**
    * Get the ASM code for a boolean value
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
    * Get the ASM parameter for a specific bound constant/ variable
    *
    * @param varScopeRef The scope containing the var/const
    * @param asmName The ASM name of the variable (local name or specific ASM name).
    * @param codeScopeRef The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    * @return The ASM parameter to use in the ASM code
    */
   static String getAsmParamName(ScopeRef varScopeRef, String asmName, ScopeRef codeScopeRef) {
      if(!varScopeRef.equals(codeScopeRef) && varScopeRef.getFullName().length() > 0) {
         String param = varScopeRef.getFullName() + "." + asmName
               .replace('@', 'b')
               .replace(':', '_')
               .replace("#", "_")
               .replace("$", "_");
         //param = ""+((Registers.RegisterZp) register).getZp();
         return param;
      } else {
         String param = asmName.replace('@', 'b').replace(':', '_').replace("#", "_").replace("$", "_");
         //param = ""+((Registers.RegisterZp) register).getZp();
         return param;
      }
   }

   /**
    * Get the ASM parameter for a specific bound variable
    *
    * @param boundVar The variable
    * @return The ASM parameter to use in the ASM code
    */
   public static String getAsmParamName(Variable boundVar, ScopeRef codeScopeRef) {
      ScopeRef varScopeRef = boundVar.getScope().getRef();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParamName(varScopeRef, asmName, codeScopeRef);
   }

   /**
    * Get the ASM parameter for a specific bound constant
    *
    * @param boundVar The constant
    * @return The ASM parameter to use in the ASM code
    */
   public static String getAsmParamName(ConstantVar boundVar, ScopeRef codeScopeRef) {
      ScopeRef varScopeRef = boundVar.getScope().getRef();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParamName(varScopeRef, asmName, codeScopeRef);
   }

   /**
    * Get the ASM parameter for a specific bound constant
    *
    * @param boundProc The constant
    * @return The ASM parameter to use in the ASM code
    */
   private static String getAsmParamName(Procedure boundProc, ScopeRef codeScopeRef) {
      ScopeRef procScopeRef = boundProc.getScope().getRef();
      String asmName = boundProc.getLocalName();
      return getAsmParamName(procScopeRef, asmName, codeScopeRef);
   }

}
