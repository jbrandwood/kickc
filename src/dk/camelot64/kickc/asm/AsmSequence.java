package dk.camelot64.kickc.asm;

import java.util.ArrayList;
import java.util.List;

/** A sequence of assembler code. */
public class AsmSequence {

   private List<AsmStatement> sequence;

   public AsmSequence() {
      this.sequence = new ArrayList<>();
   }

   public List<AsmStatement> getSequence() {
      return sequence;
   }

   public void addAsm(String asm) {
      sequence.add(new AsmStatement(asm));
   }

   public class AsmStatement {
      private String asm;

      public AsmStatement(String asm) {
         this.asm = asm;
      }

      public String getAsm() {
         return asm;
      }

      @Override
      public String toString() {
         return asm ;
      }
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (AsmStatement asmStatement : sequence) {
         out.append(asmStatement+"\n");
      }
      return out.toString();
   }
}
