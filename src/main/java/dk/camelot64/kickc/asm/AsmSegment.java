package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.PhiTransitions;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;

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

   /** The full name of the containing scope (procedure). */
   private String scopeLabel;

   public AsmSegment(int index, ScopeRef scope, Integer statementIdx, String source) {
      this.lines = new ArrayList<>();
      this.scopeLabel = scope.getFullName();
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

   /**
    * Add a new line just after another line
    * @param line The line to look for. If it is not found an Exception is thrown
    * @param add The line to add
    */
   public void addLineAfter(AsmLine line, AsmLine add) {
      ListIterator<AsmLine> it = lines.listIterator();
      while(it.hasNext()) {
         AsmLine asmLine = it.next();
         if(line.equals(asmLine)) {
            it.add(add);
            return;
         }
      }
      throw new NoSuchElementException("Item not found "+line);
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
      this.fragment = fragment;
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

   public String getScopeLabel() {
      return scopeLabel;
   }

   /**
    * Get the number of bytes the segment occupies in memory.
    * Per default calculated by adding up the bytes of each ASM line in the segment.
    *
    * @return The number of bytes
    */
   public int getBytes() {
      int bytes = 0;
      for(AsmLine line : lines) {
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
      for(AsmLine line : lines) {
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
      for(AsmLine line : lines) {
         if(line instanceof AsmInstruction) {
            AsmInstruction asmInstruction = (AsmInstruction) line;
            AsmInstructionType asmInstructionType = asmInstruction.getType();
            AsmClobber asmClobber = asmInstructionType.getClobber();
            clobber.add(asmClobber);
         }
      }
      return clobber;
   }

   /**
    * Get ASM line by index
    * @param idx The index of the line to get
    * @return The line with the passed index. Null if not found inside the segment.
    */
   public AsmLine getAsmLine(int idx) {
      for(AsmLine asmLine : getLines()) {
         if(asmLine.getIndex() == idx) {
            return asmLine;
         }
      }
      return null;
   }


   public String toString(AsmProgram.AsmPrintState printState) {
      StringBuffer out = new StringBuffer();
      if(printState.isComments()) {
         out.append(printState.getIndent()).append("//SEG").append(getIndex());
         if(source != null) {
            out.append(" ").append(source.replace('\r', ' ').replace('\n', ' '));
         }
         if(phiTransitionId != null) {
            out.append(" [").append(phiTransitionId);
            if(phiTransitionAssignmentIdx != null) {
               out.append("#").append(phiTransitionAssignmentIdx);
            }
            out.append("]");
         }
         if(fragment != null) {
            out.append(" -- ");
            out.append(fragment).append(" ");
         }
         out.append("\n");
      }
      for(int i = 0; i < lines.size(); i++) {
         AsmLine line = lines.get(i);
         if(line instanceof AsmScopeEnd) {
            printState.decIndent();
         }
         if(printState.getLineIdx()) {
            out.append("["+line.getIndex()+"]");
         }
         out.append(printState.getIndent());
         if(shouldIndentAsm(line)) {
            out.append("  ");
         }
         if(line instanceof AsmComment) {
            // Peek forward to find the comment indent
            for(int j=i;j<lines.size();j++) {
               AsmLine peek = lines.get(j);
               if(peek instanceof AsmScopeBegin) {
                  break;
               } else if(shouldIndentAsm(peek)) {
                  out.append("  ");
                  break;
               }
            }
         }
         out.append(line.getAsm() + "\n");
         if(line instanceof AsmScopeBegin) {
            printState.incIndent();
         }
      }
      return out.toString();
   }

   /**
    * Should this ASM line be indented a few spaces.
    * Instructions, variables and similar ASM is indented slightly more than other ASM.
    * @param line The line to examine
    * @return true if the line is an instruction or similar.
    */
   private boolean shouldIndentAsm(AsmLine line) {
      return line instanceof AsmInstruction || line instanceof AsmLabelDecl || line instanceof AsmConstant || line instanceof AsmDataNumeric || line instanceof AsmDataFill || line instanceof AsmDataString || line instanceof AsmDataAlignment || line instanceof AsmInlineKickAsm;
   }

   @Override
   public String toString() {
      return toString(new AsmProgram.AsmPrintState(true, false));
   }

   public void setSource(String source) {
      this.source = source;
   }
}
