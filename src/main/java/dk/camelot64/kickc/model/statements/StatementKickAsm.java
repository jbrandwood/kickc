package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;

/** Inline KickAssembler code */
public class StatementKickAsm extends StatementBase {

   /** KickAssembler code. */
   private String kickAsmCode;

   /** The absolute address to generate the kick-assembler code at. If null it is generated inline. */
   private Long location;

   public StatementKickAsm(String kickAsmCode, StatementSource source) {
      super(null, source);
      this.kickAsmCode = kickAsmCode;
   }

   public StatementKickAsm(String kickAsmCode, Long location, StatementSource source) {
      super(null, source);
      this.kickAsmCode = kickAsmCode;
      this.location = location;
   }

   public Long getLocation() {
      return location;
   }

   public void setLocation(Long location) {
      this.location = location;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder txt = new StringBuilder();
      txt.append("kickasm {{ ");
      txt.append(kickAsmCode);
      txt.append(" }}");
      return txt.toString();
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

}
