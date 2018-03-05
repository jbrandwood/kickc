package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.model.*;

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
         return getAsmNumber(((ConstantInteger) value).getNumber());
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
         Operator operator = binary.getOperator();
         boolean parenthesis = operator.getPrecedence() > precedence;
         return
               (parenthesis ? "(" : "") +
                     getAsmConstant(program, binary.getLeft(), operator.getPrecedence(), codeScope) +
                     operator.getOperator() +
                     getAsmConstant(program, binary.getRight(), operator.getPrecedence(), codeScope) +
                     (parenthesis ? ")" : "");
      } else if(value instanceof ConstantVarPointer) {
         VariableRef toVar = ((ConstantVarPointer) value).getToVar();
         Variable variable = program.getScope().getVariable(toVar);
         return getAsmParamName(variable, codeScope);
      } else {
         throw new RuntimeException("Constant type not supported " + value);
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
      if(Operator.CAST_BYTE.equals(operator) || Operator.CAST_SBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xff), Operator.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(Operator.CAST_WORD.equals(operator) || Operator.CAST_SWORD.equals(operator) || Operator.CAST_PTRBY.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xffff), Operator.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(Operator.CAST_DWORD.equals(operator) || Operator.CAST_SDWORD.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            // No cast needed
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else {
            return getAsmConstant(program, new ConstantBinary(new ConstantInteger((long)0xffffffff), Operator.BOOL_AND, operand), outerPrecedence, codeScope);
         }
      } else if(Operator.LOWBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || operandType instanceof SymbolTypePointer) {
            return "<" + getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operator.BOOL_AND, new ConstantInteger((long)0xffff)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Unhandled type "+operand);
         }
      } else if(Operator.HIBYTE.equals(operator)) {
         SymbolType operandType = SymbolTypeInference.inferType(program.getScope(), operand);
         if(SymbolType.isByte(operandType) || SymbolType.isSByte(operandType)) {
            return getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isWord(operandType) || SymbolType.isSWord(operandType) || operandType instanceof SymbolTypePointer) {
            return ">" + getAsmConstant(program, operand, outerPrecedence, codeScope);
         } else if(SymbolType.isDWord(operandType) || SymbolType.isSDWord(operandType)) {
            return getAsmConstant(program, new ConstantBinary(operand, Operator.SHIFT_RIGHT, new ConstantInteger((long)16)), outerPrecedence, codeScope);
         } else {
            throw new CompileError("Unhandled type "+operand);
         }
      } else if(Operator.INCREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operator.PLUS, new ConstantInteger((long)1)), outerPrecedence, codeScope);
      } else if(Operator.DECREMENT.equals(operator)) {
         return getAsmConstant(program, new ConstantBinary(operand, Operator.MINUS, new ConstantInteger((long)1)), outerPrecedence, codeScope);
      } else {
         return operator.getOperator() +
               getAsmConstant(program, operand, operator.getPrecedence(), codeScope);
      }
   }

   public static String getAsmNumber(Number number) {
      if(number instanceof Long || number instanceof Integer) {
         if(number.longValue() >= 0L && number.longValue() <= 9L) {
            return String.format("%d", number.longValue());
         } else {
            return String.format("$%x", number.longValue());
         }
      }
      throw new RuntimeException("Unsupported number type " + number);
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
   static String getAsmParamName(Variable boundVar, ScopeRef codeScopeRef) {
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
   private static String getAsmParamName(ConstantVar boundVar, ScopeRef codeScopeRef) {
      ScopeRef varScopeRef = boundVar.getScope().getRef();
      String asmName = boundVar.getAsmName() == null ? boundVar.getLocalName() : boundVar.getAsmName();
      return getAsmParamName(varScopeRef, asmName, codeScopeRef);
   }
}
