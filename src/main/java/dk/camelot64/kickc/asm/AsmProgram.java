package dk.camelot64.kickc.asm;

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

   public AsmSegment startSegment(Integer statementIndex, String source) {
      AsmSegment segment = new AsmSegment(nextSegmentIndex++, statementIndex, source);
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

   public void addComment(String comment) {
      addLine(new AsmComment(comment));
   }

   public void addLabel(String label) {
      addLine(new AsmLabel(label));
   }

   public void addScopeBegin(String label) {
      addLine(new AsmScopeBegin(label));
   }

   public void addScopeEnd() {
      addLine(new AsmScopeEnd());
   }

   public void addInstruction(String mnemonic, AsmAddressingMode addressingMode, String parameter, boolean zp) {
      AsmInstructionType instructionType = AsmInstructionSet.getInstructionType(mnemonic, addressingMode, zp);
      addLine(new AsmInstruction(instructionType, parameter));
   }

   public void addLabelDecl(String name, int address) {
      addLine(new AsmLabelDecl(name, address));
   }

   /**
    * Add a constant declararion to the ASM
    * @param name The name of the constant
    * @param value The value of the constant
    */
    public void addConstant(String name, String value) {
       addLine(new AsmConstant(name, value));
    }

   /**
    * Add a BYTE/WORD/DWORD data declaration tot the ASM
    * @param label The label of the data
    * @param type The type of the data
    * @param asmElements The value of the elements
    */
   public void addDataNumeric(String label, AsmDataNumeric.Type type, List<String> asmElements) {
      addLine(new AsmDataNumeric(label, type, asmElements));
   }

   /**
    * Add a FILL data declaration to the ASM
    * @param label The label of the data
    * @param type The type of the data
    * @param size The size of data to fill
    */
   public void addDataFilled(String label, AsmDataNumeric.Type type, int size, String fillValue) {
      addLine(new AsmDataFill(label, type, size, fillValue));
   }


   /**
    * Add a string data declaration tot the ASM
    * @param label The label of the data
    * @param value The value of the string
    */
   public void addDataString(String label, String value) {
      addLine(new AsmDataString(label, value));
   }


   /**
    * Get the number of bytes the segment occupies in memory.
    * Calculated by adding up the bytes of each ASM segment in the program.
    *
    * @return The number of bytes
    */
   public int getBytes() {
      int bytes = 0;
      for (AsmSegment segment : segments) {
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
      for (AsmSegment segment : segments) {
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
      for (AsmSegment segment : segments) {
         clobber.add(segment.getClobber());
      }
      return clobber;
   }

   public String toString(boolean comments) {
      return toString(new AsmPrintState(comments));
   }

   public String toString(AsmPrintState printState) {
      StringBuilder out = new StringBuilder();
      for (AsmSegment segment : segments) {
         out.append(segment.toString(printState));
      }
      return out.toString();
   }

   static class AsmPrintState {
      boolean comments;
      String indent;

      public AsmPrintState(boolean comments) {
         this.comments = comments;
         this.indent = "";
      }

      public boolean isComments() {
         return comments;
      }

      public void incIndent() {
         this.indent = this.indent + "  ";
      }

      public void decIndent() {
         if(this.indent.length()>=2) {
            this.indent = this.indent.substring(0, this.indent.length() - 2);
         }
      }

      public String getIndent() {
         return indent;
      }

   }


   @Override
   public String toString() {
      return toString(true);
   }


}
