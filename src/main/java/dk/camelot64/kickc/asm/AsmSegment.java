package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.PhiTransitions;

import java.util.ArrayList;
import java.util.List;

/**
 * A segment of an ASM program. The segment has a number of methods/attributes that describe the lines of the segment.
 * Typically each ICL statement becomes a single ASM segment through the AsmFragment subsystem.
 */
public class AsmSegment {

   /**
    * The lines of the segment.
    */
   private List<AsmLine> lines;

   /**
    * Index of the segment.
    */
   private int index;

   /**
    * Index of the ICL statement that the segment is generated from,
    */
   private Integer statementIdx;

   /**
    * Readable name of the ICL source of the segment.
    */
   private String source;

   /**
    * Readable name of the fragment used to generate the segment.
    */
   private String fragment;

   /** If the segment represents a PHI transition (See. {@link PhiTransitions}) this contains the transition ID. */
   private String phiTransitionId;

   /** If the segment is an assignment in a PHI transition this contains the index of the assignment within the transition. */
   private Integer phiTransitionAssignmentIdx;

   public AsmSegment(int index, Integer statementIdx, String source) {
      this.lines = new ArrayList<>();
      this.index = index;
      this.statementIdx = statementIdx;
      this.source = source;
   }

   public List<AsmLine> getLines() {
      return lines;
   }

   public void addLine(AsmLine line) {
      lines.add(line);
   }

   public int getIndex() {
      return index;
   }

   public Integer getStatementIdx() {
      return statementIdx;
   }

   public String getSource() {
      return source;
   }

   public void setFragment(String fragment) {
      this.fragment  = fragment;
   }

   public String getPhiTransitionId() {
      return phiTransitionId;
   }

   public void setPhiTransitionId(String phiTransitionId) {
      this.phiTransitionId = phiTransitionId;
   }

   public Integer getPhiTransitionAssignmentIdx() {
      return phiTransitionAssignmentIdx;
   }

   public void setPhiTransitionAssignmentIdx(Integer phiTransitionAssignmentIdx) {
      this.phiTransitionAssignmentIdx = phiTransitionAssignmentIdx;
   }

   /**
    * Get the number of bytes the segment occupies in memory.
    * Per default calculated by adding up the bytes of each ASM line in the segment.
    *
    * @return The number of bytes
    */
   public int getBytes() {
      int bytes = 0;
      for (AsmLine line : lines) {
         bytes += line.getLineBytes();
      }
      return bytes;
   }

   /**
    * Get the number of cycles it takes to execute the segment
    * Per default calculated by adding up the cycles of each ASM line in the segment.
    *
    * @return The number of cycles
    */
   public double getCycles() {
      double cycles = 0.0;
      for (AsmLine line : lines) {
         cycles += line.getLineCycles();
      }
      return cycles;
   }

   /**
    * Get the registers clobbered when executing the segment
    * Per default calculated by adding up the clobber of each ASM line in the segment.
    *
    * @return The registers clobbered
    */
   public AsmClobber getClobber() {
      AsmClobber clobber = new AsmClobber();
      for (AsmLine line : lines) {
         if (line instanceof AsmInstruction) {
            AsmInstruction asmInstruction = (AsmInstruction) line;
            AsmInstructionType asmInstructionType = asmInstruction.getType();
            AsmClobber asmClobber = asmInstructionType.getClobber();
            clobber.add(asmClobber);
         }
      }
      return clobber;
   }

   public String toString(AsmProgram.AsmPrintState printState) {
      StringBuffer out = new StringBuffer();
      if (printState.isComments()) {
         out.append(printState.getIndent()).append("//SEG").append(getIndex());
         if (source != null) {
            out.append(" ").append(source);
         }
         if(phiTransitionId!=null) {
            out.append(" [").append(phiTransitionId);
            if(phiTransitionAssignmentIdx!=null) {
               out.append("#").append(phiTransitionAssignmentIdx);
            }
            out.append("]");
         }
         if (fragment!=null) {
            out.append(" -- ");
            out.append(fragment).append(" ");
         }
         out.append("\n");
      }
      for (AsmLine line : lines) {
         if (line instanceof AsmComment && !printState.isComments()) {
            if (!((AsmComment) line).getComment().contains("Fragment")) {
               continue;
            }
         }
         if(line instanceof AsmScopeEnd) {
            printState.decIndent();
         }
         out.append(printState.getIndent());
         if (line instanceof AsmComment || line instanceof AsmInstruction || line instanceof AsmLabelDecl || line instanceof AsmConstant || line instanceof AsmDataNumeric|| line instanceof AsmDataString) {
            out.append("  ");
         }
         out.append(line.getAsm() + "\n");
         if(line instanceof AsmScopeBegin) {
            printState.incIndent();
         }
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(new AsmProgram.AsmPrintState(true));
   }

}
