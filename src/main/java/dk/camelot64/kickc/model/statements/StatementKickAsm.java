package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.RValue;

/** Inline KickAssembler code */
public class StatementKickAsm extends StatementBase {

   /** KickAssembler code. */
   private String kickAsmCode;

   /** The absolute address to generate the kick-assembler code at. If null it is generated inline. */
   private RValue location;
   /** The number of bytes generated by the kickassembler code. */
   private Long bytes;
   /** The number of cycles used by the generated kickassembler code. */
   private Long cycles;

   public StatementKickAsm(String kickAsmCode, StatementSource source) {
      super(null, source);
      this.kickAsmCode = kickAsmCode;
   }

   public StatementKickAsm(String kickAsmCode, RValue location, Long bytes, Long cycles, StatementSource source) {
      super(null, source);
      this.kickAsmCode = kickAsmCode;
      this.location = location;
      this.bytes = bytes;
      this.cycles = cycles;
   }

   public RValue getLocation() {
      return location;
   }

   public void setLocation(RValue location) {
      this.location = location;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      StringBuilder txt = new StringBuilder();
      txt.append("kickasm");
      if(location!=null) {
         txt.append("(location ");
         txt.append(location.toString(program));
         txt.append(")");
      }
      txt.append(" {{ ");
      txt.append(kickAsmCode);
      txt.append(" }}");
      return txt.toString();
   }

   public String getKickAsmCode() {
      return kickAsmCode;
   }

   public void setBytes(Long bytes) {
      this.bytes = bytes;
   }

   public Long getBytes() {
      return bytes;
   }

   public void setCycles(Long cycles) {
      this.cycles = cycles;
   }

   public Long getCycles() {
      return cycles;
   }
}
