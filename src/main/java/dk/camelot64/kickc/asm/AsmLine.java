package dk.camelot64.kickc.asm;

/** A line of 6502 assembler code */
public interface AsmLine {

   int getLineBytes();

   double getLineCycles();

   String getAsm();

   int getIndex();

   void setIndex(int index);
}
