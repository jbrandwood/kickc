package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;

import java.util.List;

/**
 * An array initialized using inline kick-assembler. The array is allocated in the code memory (eg. as a set of .byte's ).
 */
public class ConstantArrayKickAsm implements ConstantArray {

   /** Type of the array elements. */
   private SymbolType elementType;

   /** KickAssembler code generating the data. */
   private String kickAsmCode;

   /** Variables/constants used by the kickasm code. */
   private List<SymbolRef> uses;

   public ConstantArrayKickAsm(SymbolType elementType, String kickAsmCode, List<SymbolRef> uses) {
      this.elementType = elementType;
      this.kickAsmCode = kickAsmCode;
      this.uses = uses;
   }

   public List<SymbolRef> getUses() {
      return uses;
   }

   public void setUses(List<SymbolRef> uses) {
      this.uses = uses;
   }

   @Override
   public SymbolType getType(ProgramScope scope) {
      return new SymbolTypeArray(elementType);
   }

   public SymbolType getElementType() {
      return elementType;
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

   public void setKickAsmCode(String kickAsmCode) {
      this.kickAsmCode = kickAsmCode;
   }

   @Override
   public ConstantLiteral calculateLiteral(ProgramScope scope) {
      throw new ConstantNotLiteral("Cannot calculate literal array");
   }

   @Override
   public String toString() {
      return toString(null);
   }

   @Override
   public String toString(Program program) {
      StringBuilder txt = new StringBuilder();
      txt.append("kickasm");
      if(uses.size()>0) {
         txt.append("( ");
         for(SymbolRef use : uses) {
            txt.append(" uses ");
            txt.append(use.getFullName());
         }
         txt.append(")");
      }
      txt.append(" {{ ");
      txt.append(kickAsmCode);
      txt.append(" }}");
      return txt.toString();
   }

}
