package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.ScopeRef;

public class AsmParameterConstant implements AsmParameter {

   ConstantValue constantExpr;
   ScopeRef codeScope;
   Program program;


   public AsmParameterConstant(ConstantValue constantExpr, ScopeRef codeScope, Program program) {
      this.constantExpr = constantExpr;
      this.codeScope = codeScope;
      this.program = program;
   }

   @Override
   public String getAsm() {
      return AsmFormat.getAsmConstant(program, constantExpr, 99, codeScope);
   }
}
