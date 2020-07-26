package dk.camelot64.kickc.asm;

import dk.camelot64.cpufamily6502.AsmClobber;
import dk.camelot64.cpufamily6502.AsmOpcode;
import dk.camelot64.kickc.model.PhiTransitions;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;

/**
 * A chunk of an ASM program. The chunk has a number of methods/attributes that describe the lines of the chunk.
 * Typically each ICL statement becomes a single ASM chunk through the AsmFragment subsystem.
 */
public class AsmChunk {

   /**
    * The lines of the chunk.
    */
   private List<AsmLine> lines;

   /**
    * Index of the chunk.
    */
   private int index;

   /**
    * Index of the ICL statement that the chunk is generated from,
    */
   private Integer statementIdx;

   /**
    * Readable name of the ICL source of the chunk.
    */
   private String source;

   /**
    * Readable name of the fragment used to generate the chunk.
    */
   private String fragment;

   /** If the chunk is part of a complex statement this is the sub-ID used for identifying the part of the statement represented.
    * For PHI transitions (See. {@link PhiTransitions}) this contains the transition ID. For call prepare this holds the parameter. */
   private String subStatementId;

   /** If the chunk is part of a complex statement this is the sub index used for identifying the part of the statement represented.
   * For  PHI transitions this contains the index of the assignment within the transition. For call prepares this is the index of the parameter. */
   private Integer subStatementIdx;

   /** The full name of the containing scope (procedure). */
   private String scopeLabel;

   /** If non-null this overwrites the clobber of the chunk that is calculated by examining the ASM instruction lines. */
   private AsmClobber clobberOverwrite;

   public AsmChunk(int index, ScopeRef scope, Integer statementIdx, String source) {
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

   public AsmClobber getClobberOverwrite() {
      return clobberOverwrite;
   }

   public void setClobberOverwrite(AsmClobber clobberOverwrite) {
      this.clobberOverwrite = clobberOverwrite;
   }

   /**
    * Add a new line just after another line
    *
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
      throw new NoSuchElementException("Item not found " + line);
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

   public String getSubStatementId() {
      return subStatementId;
   }

   public void setSubStatementId(String subStatementId) {
      this.subStatementId = subStatementId;
   }

   public Integer getSubStatementIdx() {
      return subStatementIdx;
   }

   public void setSubStatementIdx(Integer subStatementIdx) {
      this.subStatementIdx = subStatementIdx;
   }

   public String getScopeLabel() {
      return scopeLabel;
   }

   /**
    * Get the number of bytes the chunk occupies in memory.
    * Per default calculated by adding up the bytes of each ASM line in the chunk.
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
    * Get the number of cycles it takes to execute the chunk
    * Per default calculated by adding up the cycles of each ASM line in the chunk.
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
    * Get the registers clobbered when executing the chunk
    * Per default calculated by adding up the clobber of each ASM line in the chunk.
    *
    * @return The registers clobbered
    */
   public AsmClobber getClobber() {
      if(clobberOverwrite != null) {
         return clobberOverwrite;
      }
      AsmClobber clobber = new AsmClobber();
      for(AsmLine line : lines) {
         if(line instanceof AsmInstruction) {
            AsmInstruction asmInstruction = (AsmInstruction) line;
            AsmOpcode asmOpcode = asmInstruction.getAsmOpcode();
            AsmClobber asmClobber = asmOpcode.getClobber();
            clobber.add(asmClobber);
         }
      }
      return clobber;
   }

   /**
    * Get ASM line by index
    *
    * @param idx The index of the line to get
    * @return The line with the passed index. Null if not found inside the chunk.
    */
   public AsmLine getAsmLine(int idx) {
      for(AsmLine asmLine : getLines()) {
         if(asmLine.getIndex() == idx) {
            return asmLine;
         }
      }
      return null;
   }

   public String toString(AsmProgram.AsmPrintState printState, Program program) {
      StringBuffer out = new StringBuffer();
      if(printState.isSourceFileInfo()) {
         if(this.statementIdx != null && program != null) {
            Statement statement = program.getGraph().getStatementByIndex(this.statementIdx);
            if(statement != null) {
               StatementSource source = statement.getSource();
               if(source != null) {
                  if(source.getFileName() != null || source.getLineNumber() != null) {
                     String fileInfo = "";
                     if(source.getFileName() != null)
                        fileInfo += source.getFileName();
                     fileInfo += ":";
                     if(source.getLineNumber() != null)
                        fileInfo += source.getLineNumber();
                     if(!fileInfo.equals(printState.getCurrentFileInfo())) {
                        out.append(printState.getIndent()).append("  // ").append(fileInfo).append("\n");
                        printState.setCurrentFileInfo(fileInfo);
                     }
                  } else {
                     printState.setCurrentFileInfo(null);
                  }
               }
            }
         }
      }
      if(printState.isSourceCodeInfo()) {
         if(this.statementIdx != null && program != null) {
            Statement statement = program.getGraph().getStatementByIndex(this.statementIdx);
            if(statement != null) {
               StatementSource source = statement.getSource();
               if(source != null) {
                  if(source.getCode() != null) {
                     if(!source.getCode().equals(printState.getCurrentCodeInfo())) {
                        printState.setCurrentCodeInfo(source.getCode());
                        out.append(printState.getIndent()).append("  // ");
                        if(source.getCode() != null)
                           out.append(source.getCode().replace("\n", "\n" + printState.getIndent() + "  // "));
                        out.append("\n");
                     }
                  } else {
                     printState.setCurrentCodeInfo(null);
                  }
               }
            }
         }
      }
      if(printState.isSourceIclInfo()) {
         out.append(printState.getIndent()).append("  //");
         if(printState.isSourceChunkIdInfo()) {
            out.append("CHU").append(getIndex());
         }
         if(source != null) {
            out.append(" ").append(source.replace('\r', ' ').replace('\n', ' '));
         }
         if(subStatementId != null) {
            out.append(" [").append(subStatementId);
            if(subStatementIdx != null) {
               out.append("#").append(subStatementIdx);
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
         if(printState.getAsmLineNumber()) {
            out.append("[" + line.getIndex() + "]");
         }
         out.append(printState.getIndent());
         if(shouldIndentAsm(line)) {
            out.append("  ");
         }
         if(line instanceof AsmComment) {
            // Peek forward to find the comment indent
            for(int j = i; j < lines.size(); j++) {
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
    *
    * @param line The line to examine
    * @return true if the line is an instruction or similar.
    */
   private boolean shouldIndentAsm(AsmLine line) {
      return line instanceof AsmInstruction ||
            line instanceof AsmLabelDecl ||
            line instanceof AsmConstant ||
            line instanceof AsmDataNumeric ||
            line instanceof AsmDataFill ||
            line instanceof AsmDataString ||
            line instanceof AsmDataAlignment ||
            (line instanceof AsmInlineKickAsm && !line.getAsm().contains(".pc"));
   }

   @Override
   public String toString() {
      return toString(new AsmProgram.AsmPrintState(true), null);
   }

   public void setSource(String source) {
      this.source = source;
   }
}
