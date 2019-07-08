package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.fragment.AsmFormat;
import dk.camelot64.kickc.model.Program;
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
    *
    * @param kickAsmCode The kickassembler code
    */
   public void addInlinedKickAsm(String kickAsmCode, Long bytes, Long cycles) {
      addLine(new AsmInlineKickAsm(kickAsmCode, bytes, cycles));
   }

   /**
    * Add data array initialized with inline kick assembler code
    *
    * @param label Name of the data
    * @param bytes The number of bytes (from array definition)
    * @param kickAsmCode Kick Assembler code to initialize the data
    */
   public void addDataKickAsm(String label, int bytes, String kickAsmCode) {
      addLine(new AsmDataKickAsm(label, bytes, kickAsmCode));
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

   public String toString(AsmPrintState printState, Program program) {
      StringBuilder out = new StringBuilder();
      for(AsmSegment segment : segments) {
         out.append(segment.toString(printState, program));
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(new AsmPrintState(false), null);
   }

   /**
    * Set the index of the next line
    *
    * @param nextIndex The index of the next line
    */
   public void setNextLineIndex(int nextIndex) {
      this.nextLineIndex = nextIndex;
   }

   /**
    * Get ASM segment by line index
    *
    * @param idx The index of the line to get the segment for
    * @return The segment with the line that has the passed index. Null if not found
    */
   public AsmSegment getAsmSegment(int idx) {
      for(AsmSegment segment : segments) {
         for(AsmLine asmLine : segment.getLines()) {
            if(asmLine.getIndex() == idx) {
               return segment;
            }
         }
      }
      return null;
   }

   public static class AsmPrintState {
      // Output comments with information about the file/line number in the source file
      private boolean sourceFileInfo;
      // Output comments with C-source from the source file
      private boolean sourceCodeInfo;
      // Output comments with ICL-code and the ASM fragment name
      private boolean sourceIclInfo;
      // Output segment ID in the ICL-comment
      private boolean sourceSegmentIdInfo;
      // Output ASM line numbers
      private boolean asmLineNumber;
      // Current indent - used during printing
      private String indent;

      public AsmPrintState(boolean sourceFileInfo, boolean sourceCodeInfo, boolean sourceIclInfo, boolean asmLineNumber) {
         this.sourceFileInfo = sourceFileInfo;
         this.sourceCodeInfo = sourceCodeInfo;
         this.sourceIclInfo = sourceIclInfo;
         this.asmLineNumber = asmLineNumber;
         this.indent = "";
      }

      public AsmPrintState(boolean sourceIclInfo) {
         this(false, false, sourceIclInfo, false);
      }

      public boolean isSourceCodeInfo() {
         return sourceCodeInfo;
      }

      public void setSourceCodeInfo(boolean sourceCodeInfo) {
         this.sourceCodeInfo = sourceCodeInfo;
      }

      public boolean isSourceFileInfo() {
         return sourceFileInfo;
      }

      public void setSourceFileInfo(boolean sourceFileInfo) {
         this.sourceFileInfo = sourceFileInfo;
      }

      public boolean isSourceIclInfo() {
         return sourceIclInfo;
      }

      public boolean isSourceSegmentIdInfo() {
         return sourceSegmentIdInfo;
      }

      public void setSourceSegmentIdInfo(boolean sourceSegmentIdInfo) {
         this.sourceSegmentIdInfo = sourceSegmentIdInfo;
      }

      public void setSourceIclInfo(boolean sourceIclInfo) {
         this.sourceIclInfo = sourceIclInfo;
      }

      public boolean isAsmLineNumber() {
         return asmLineNumber;
      }

      public void setAsmLineNumber(boolean asmLineNumber) {
         this.asmLineNumber = asmLineNumber;
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

      public boolean getAsmLineNumber() {
         return asmLineNumber;
      }
   }


}
