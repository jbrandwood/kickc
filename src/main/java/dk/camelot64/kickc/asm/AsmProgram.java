package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * A 6502 assembler program
 */
public class AsmProgram {

   /**
    * The segments of the program. The segments hold the ASM lines.
    */
   private List<AsmSegment> segments;

   /**
    * The index of the next segment.
    */
   private int nextSegmentIndex;

   /**
    * The index of the next line.
    */
   private int nextLineIndex;

   public AsmProgram() {
      this.segments = new ArrayList<>();
      this.nextLineIndex = 0;
      this.nextSegmentIndex = 0;
   }

   public Collection<AsmSegment> getSegments() {
      return segments;
   }

   public AsmSegment startSegment(ScopeRef scopeRef, Integer statementIndex, String source) {
      AsmSegment segment = new AsmSegment(nextSegmentIndex++, scopeRef, statementIndex, source);
      segments.add(segment);
      return segment;
   }

   public AsmSegment getCurrentSegment() {
      return segments.get(segments.size() - 1);
   }

   public void addLine(AsmLine line) {
      line.setIndex(nextLineIndex++);
      getCurrentSegment().addLine(line);
   }

   public void addComment(String comment, boolean isBlock) {
      addLine(new AsmComment(comment, isBlock));
   }

   public AsmLabel addLabel(String label) {
      AsmLabel asmLabel = new AsmLabel(label);
      addLine(asmLabel);
      return asmLabel;
   }

   public void addScopeBegin(String label) {
      addLine(new AsmScopeBegin(label));
   }

   public void addScopeEnd() {
      addLine(new AsmScopeEnd());
   }

   public AsmInstruction addInstruction(String mnemonic, AsmAddressingMode addressingMode, String parameter, boolean zp) {
      AsmInstructionType instructionType = AsmInstructionSet.getInstructionType(mnemonic, addressingMode, zp);
      AsmInstruction instruction = new AsmInstruction(instructionType, parameter);
      addLine(instruction);
      return instruction;
   }

   public void addLabelDecl(String name, int address) {
      addLabelDecl(name, AsmFormat.getAsmNumber(address));
   }

   public void addLabelDecl(String name, String value) {
      addLine(new AsmLabelDecl(name, value));
   }

   /**
    * Add a constant declararion to the ASM
    *
    * @param name The name of the constant
    * @param value The value of the constant
    */
   public void addConstant(String name, String value) {
      addLine(new AsmConstant(name, value));
   }

   /**
    * Add a BYTE/WORD/DWORD data declaration tot the ASM
    *
    * @param label The label of the data
    * @param type The type of the data
    * @param asmElements The value of the elements
    */
   public void addDataNumeric(String label, AsmDataNumeric.Type type, List<String> asmElements) {
      addLine(new AsmDataNumeric(label, type, asmElements));
   }

   /**
    * Add a FILL data declaration to the ASM
    *
    * @param label The label of the data
    * @param type The type of the data
    * @param size The size of data to fill
    */
   public void addDataFilled(String label, AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue) {
      addLine(new AsmDataFill(label, type, sizeAsm, size, fillValue));
   }

   /**
    * Add a string data declaration to the ASM
    *
    * @param label The label of the data
    * @param value The value of the string
    */
   public void addDataString(String label, String value) {
      addLine(new AsmDataString(label, value));
   }

   /**
    * Add data alignment to the ASM
    *
    * @param alignment The number to align the address of the next data to
    */
   public void addDataAlignment(String alignment) {
      addLine(new AsmDataAlignment(alignment));
   }

   /**
    * Add inlines kick assembler code
    * @param kickAsmCode The kickassembler code
    */
   public void addInlinedKickAsm(String kickAsmCode, Long bytes, Long cycles) {
      addLine(new AsmInlineKickAsm(kickAsmCode, bytes, cycles));
   }

   /**
    * Get the number of bytes the segment occupies in memory.
    * Calculated by adding up the bytes of each ASM segment in the program.
    *
    * @return The number of bytes
    */
   public int getBytes() {
      int bytes = 0;
      for(AsmSegment segment : segments) {
         bytes += segment.getBytes();
      }
      return bytes;
   }

   /**
    * Get the number of cycles it takes to execute the segment
    * Calculated by adding up the cycles of each ASM segments in the program.
    *
    * @return The number of cycles
    */
   public double getCycles() {
      double cycles = 0.0;
      for(AsmSegment segment : segments) {
         cycles += segment.getCycles();
      }
      return cycles;
   }


   /**
    * Get the CPU registers clobbered by the instructions of the fragment
    *
    * @return The clobbered registers
    */
   public AsmClobber getClobber() {
      AsmClobber clobber = new AsmClobber();
      for(AsmSegment segment : segments) {
         clobber.add(segment.getClobber());
      }
      return clobber;
   }

   public String toString(boolean comments) {
      return toString(new AsmPrintState(comments, false));
   }

   public String toString(boolean comments, boolean lineIdx) {
      return toString(new AsmPrintState(comments, lineIdx));
   }


   public String toString(AsmPrintState printState) {
      StringBuilder out = new StringBuilder();
      for(AsmSegment segment : segments) {
         out.append(segment.toString(printState));
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(true);
   }

   /**
    * Set the index of the next line
    * @param nextIndex The index of the next line
    */
   public void setNextLineIndex(int nextIndex) {
      this.nextLineIndex = nextIndex;
   }

   /**
    * Get ASM segment by line index
    * @param idx The index of the line to get the segment for
    * @return The segment with the line that has the passed index. Null if not found
    */
   public AsmSegment getAsmSegment(int idx) {
      for(AsmSegment segment : segments) {
         for(AsmLine asmLine : segment.getLines()) {
            if(asmLine.getIndex()==idx) {
               return segment;
            }
         }
      }
      return null;
   }

   static class AsmPrintState {
      boolean comments;
      boolean lineIdx;
      String indent;

      public AsmPrintState(boolean comments, boolean lineIdx) {
         this.comments = comments;
         this.lineIdx = lineIdx;
         this.indent = "";
      }

      public boolean isComments() {
         return comments;
      }

      public void incIndent() {
         this.indent = this.indent + "  ";
      }

      public void decIndent() {
         if(this.indent.length() >= 2) {
            this.indent = this.indent.substring(0, this.indent.length() - 2);
         }
      }

      public String getIndent() {
         return indent;
      }

      public boolean getLineIdx() {
         return lineIdx;
      }
   }


}
