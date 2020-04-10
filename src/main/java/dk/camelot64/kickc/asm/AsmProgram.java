package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.StringEncoding;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * A 6502 assembler program
 */
public class AsmProgram {

   /**
    * The chunks of the program. The chunks hold the ASM lines.
    */
   private List<AsmChunk> chunks;

   /**
    * The index of the next chunk.
    */
   private int nextChunkIndex;

   /**
    * The index of the next line.
    */
   private int nextLineIndex;

   /** The current encoding used for printing strings. */
   private StringEncoding currentEncoding = StringEncoding.SCREENCODE_MIXED;

   public AsmProgram() {
      this.chunks = new ArrayList<>();
      this.nextLineIndex = 0;
      this.nextChunkIndex = 0;
   }

   public Collection<AsmChunk> getChunks() {
      return chunks;
   }

   public AsmChunk startChunk(ScopeRef scopeRef, Integer statementIndex, String source) {
      AsmChunk chunk = new AsmChunk(nextChunkIndex++, scopeRef, statementIndex, source);
      chunks.add(chunk);
      return chunk;
   }

   public AsmChunk getCurrentChunk() {
      return chunks.get(chunks.size() - 1);
   }

   public void addLine(AsmLine line) {
      line.setIndex(nextLineIndex++);
      getCurrentChunk().addLine(line);
      if(line instanceof AsmSetEncoding)
         currentEncoding = ((AsmSetEncoding) line).getEncoding();
   }

   /**
    * Get the current encoding used for strings/chars
    * @return The encoding
    */
   public StringEncoding getCurrentEncoding() {
      return currentEncoding;
   }

   public void ensureEncoding(Collection<StringEncoding> encodings) {
      if(encodings == null || encodings.size() == 0) return;
      if(encodings.size() > 1) {
         throw new CompileError("Different character encodings in one ASM statement not supported!");
      }
      // Size is 1 - grab it!
      StringEncoding encoding = encodings.iterator().next();
      if(!getCurrentEncoding().equals(encoding)) {
         addLine(new AsmSetEncoding(encoding));
      }
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

   public void addLabelDecl(String name, String value) {
      addLine(new AsmLabelDecl(name, value));
   }

   /**
    * Add a constant declaration to the ASM
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
    * @param numElements The size of data to fill
    */
   public void addDataFilled(String label, AsmDataNumeric.Type type, String totalSizeBytesAsm, int numElements, String fillValue) {
      addLine(new AsmDataFill(label, type, totalSizeBytesAsm, numElements, fillValue));
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
    * Get the number of bytes the program occupies in memory.
    * Calculated by adding up the bytes of each ASM chunk in the program.
    *
    * @return The number of bytes
    */
   public int getBytes() {
      int bytes = 0;
      for(AsmChunk chunk : chunks) {
         bytes += chunk.getBytes();
      }
      return bytes;
   }

   /**
    * Get the number of cycles it takes to execute the program
    * Calculated by adding up the cycles of each ASM chunks in the program.
    *
    * @return The number of cycles
    */
   public double getCycles() {
      double cycles = 0.0;
      for(AsmChunk chunk : chunks) {
         cycles += chunk.getCycles();
      }
      return cycles;
   }


   /**
    * Get the CPU registers clobbered by the instructions of the program
    *
    * @return The clobbered registers
    */
   public AsmClobber getClobber() {
      AsmClobber clobber = new AsmClobber();
      for(AsmChunk chunk : chunks) {
         clobber.add(chunk.getClobber());
      }
      return clobber;
   }

   public String toString(AsmPrintState printState, Program program) {
      StringBuilder out = new StringBuilder();
      for(AsmChunk chunk : chunks) {
         out.append(chunk.toString(printState, program));
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
    * Get ASM chunk by line index
    *
    * @param idx The index of the line to get the chunk for
    * @return The chunk with the line that has the passed index. Null if not found
    */
   public AsmChunk getAsmChunk(int idx) {
      for(AsmChunk chunk : chunks) {
         for(AsmLine asmLine : chunk.getLines()) {
            if(asmLine.getIndex() == idx) {
               return chunk;
            }
         }
      }
      return null;
   }

   /**
    * Get information about the size of the program
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append("SIZE ASM chunks "+ getChunks().size()).append("\n");
      AtomicInteger numLines = new AtomicInteger();
      getChunks().stream().forEach(asmChunk -> numLines.addAndGet(asmChunk.getLines().size()));
      sizeInfo.append("SIZE ASM lines "+ numLines).append("\n");
      return sizeInfo.toString();
   }

   public static class AsmPrintState {
      // Output comments with information about the file/line number in the source file
      private boolean sourceFileInfo;
      // Output comments with C-source from the source file
      private boolean sourceCodeInfo;
      // Output comments with ICL-code and the ASM fragment name
      private boolean sourceIclInfo;
      // Output chunk ID in the ICL-comment
      private boolean sourceChunkIdInfo;
      // Output ASM line numbers
      private boolean asmLineNumber;
      // Current indent - used during printing
      private String indent;
      // The current value of code info. Set/get during printing to avoid duplicate source code info comment lines.
      private String currentCodeInfo;
      // The current value of file info. Set/get during printing to avoid duplicate source code info comment lines.
      private String currentFileInfo;

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

      public boolean isSourceChunkIdInfo() {
         return sourceChunkIdInfo;
      }

      public void setSourceChunkIdInfo(boolean sourceChunkIdInfo) {
         this.sourceChunkIdInfo = sourceChunkIdInfo;
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

      public String getCurrentCodeInfo() {
         return currentCodeInfo;
      }

      public void setCurrentCodeInfo(String currentCodeInfo) {
         this.currentCodeInfo = currentCodeInfo;
      }

      public String getCurrentFileInfo() {
         return currentFileInfo;
      }

      public void setCurrentFileInfo(String currentFileInfo) {
         this.currentFileInfo = currentFileInfo;
      }
   }


}
