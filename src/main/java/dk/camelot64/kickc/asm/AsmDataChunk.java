package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.StringEncoding;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/** A sequence of data elements to add to the ASM program. */
public class AsmDataChunk {

   interface AsmDataElement {

   }

   /** A single numeric data element. */
   public static class AsmDataNumericElement implements AsmDataElement {

      /** The type of the data element. */
      AsmDataNumeric.Type type;
      /** The value of the data element. */
      String value;
      /** The string encoding used in any char/string value */
      Set<StringEncoding> encoding;

      AsmDataNumericElement(AsmDataNumeric.Type type, String value, Set<StringEncoding> encoding) {
         this.type = type;
         this.value = value;
         this.encoding = encoding;
      }

      public AsmDataNumeric.Type getType() {
         return type;
      }

      public String getValue() {
         return value;
      }

      public Set<StringEncoding> getEncoding() {
         return encoding;
      }
   }

   /** A number of zero data elements. */
   public static class AsmDataZeroFilledElement implements AsmDataElement {

      /** The ASM specifying how the total size in bytes - in ASM-format. */
      String totalSizeBytesAsm;
      /** The type of the element */
      AsmDataNumeric.Type type;
      /** The literal integer number of elements. */
      int numElements;
      /** The string encoding used in any char/string value */
      Set<StringEncoding> encoding;

      AsmDataZeroFilledElement(AsmDataNumeric.Type type, String totalSizeBytesAsm, int numElements, Set<StringEncoding> encoding) {
         this.type = type;
         this.totalSizeBytesAsm = totalSizeBytesAsm;
         this.numElements = numElements;
         this.encoding = encoding;
      }

      public AsmDataNumeric.Type getType() {
         return type;
      }

      String getTotalSizeBytesAsm() {
         return totalSizeBytesAsm;
      }

      public int getNumElements() {
         return numElements;
      }

      public Set<StringEncoding> getEncoding() {
         return encoding;
      }
   }

   /** A string data element. */
   public static class AsmDataStringElement implements AsmDataElement {
      /** The string value. */
      String value;
      /** The string encoding used in the string value */
      Set<StringEncoding> encoding;

      AsmDataStringElement(String value, Set<StringEncoding> encoding) {
         this.value = value;
         this.encoding = encoding;
      }

      public String getValue() {
         return value;
      }

      public Set<StringEncoding> getEncoding() {
         return encoding;
      }
   }

   /** A kickasm data element. */
   public static class AsmDataKickAsmElement implements AsmDataElement {

      /** The size in bytes. */
      int byteSize;
      /** The kickasm code initializing the value. */
      String kickAsmCode;
      /** The string encoding used in the string value */
      Set<StringEncoding> encoding;

      public AsmDataKickAsmElement(int byteSize, String kickAsmCode, Set<StringEncoding> encoding) {
         this.byteSize = byteSize;
         this.kickAsmCode = kickAsmCode;
         this.encoding = encoding;
      }

      public int getByteSize() {
         return byteSize;
      }

      public String getKickAsmCode() {
         return kickAsmCode;
      }

      public Set<StringEncoding> getEncoding() {
         return encoding;
      }
   }

   /** A sequence of data elements. */
   private List<AsmDataElement> elements;

   public AsmDataChunk() {
      this.elements = new ArrayList<>();
   }

   public void addDataNumeric(AsmDataNumeric.Type type, String value, Set<StringEncoding> encoding) {
      elements.add(new AsmDataNumericElement(type, value, encoding));
   }

   public void addDataZeroFilled(AsmDataNumeric.Type type, String totalSizeBytesAsm, int numElements, Set<StringEncoding> encoding) {
      elements.add(new AsmDataZeroFilledElement(type, totalSizeBytesAsm, numElements, encoding));
   }

   public void addDataString(String string, Set<StringEncoding> encoding) {
      elements.add(new AsmDataStringElement(string, encoding));
   }

   public void addDataKickAsm(int byteSize, String kickAsmCode, Set<StringEncoding> encoding) {
      elements.add(new AsmDataKickAsmElement(byteSize, kickAsmCode, encoding));
   }


   public List<AsmDataElement> getElements() {
      return elements;
   }

   /**
    * Add BYTE/WORD/DWORD data declaration to the ASM for a whole chunk of numeric data.
    * Produces 1-N ASM lines depending on the number of and types of data added.
    *
    * @param label The label of the data. Can be null.
    * @param asm The ASM program to add the data to
    */
   public void addToAsm(String label, AsmProgram asm) {
      AsmDataNumeric.Type currentNumericType = null;
      List<String> currentNumericElements = null;
      for(AsmDataChunk.AsmDataElement element : this.getElements()) {
         if(element instanceof AsmDataZeroFilledElement || element instanceof AsmDataStringElement || element instanceof AsmDataKickAsmElement) {
            if(currentNumericElements != null && currentNumericElements.size() > 0) {
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               label = null; // Only output label once
               currentNumericElements = null;
               currentNumericType = null;
            }
         }
         if(element instanceof AsmDataZeroFilledElement) {
            AsmDataZeroFilledElement filledElement = (AsmDataZeroFilledElement) element;
            asm.ensureEncoding(filledElement.getEncoding());
            asm.addDataZeroFilled(label, filledElement.getType(), filledElement.getTotalSizeBytesAsm(), filledElement.getNumElements());
            label = null; // Only output label once
         } else if(element instanceof AsmDataKickAsmElement) {
            AsmDataKickAsmElement kickAsmElement = (AsmDataKickAsmElement) element;
            asm.ensureEncoding(kickAsmElement.getEncoding());
            asm.addDataKickAsm(label, kickAsmElement.getByteSize(), kickAsmElement.getKickAsmCode());
            label = null; // Only output label once
         } else if(element instanceof AsmDataStringElement) {
            AsmDataStringElement stringElement = (AsmDataStringElement) element;
            asm.ensureEncoding(stringElement.getEncoding());
            asm.addDataString(label, stringElement.getValue());
            label = null; // Only output label once
         } else if(element instanceof AsmDataNumericElement) {
            AsmDataNumericElement numericElement = (AsmDataNumericElement) element;
            AsmDataNumeric.Type type = numericElement.getType();
            asm.ensureEncoding(numericElement.getEncoding());
            if(currentNumericType == null) {
               // First element - initialize current
               currentNumericType = type;
               currentNumericElements = new ArrayList<>();
               currentNumericElements.add(numericElement.getValue());
            } else if(currentNumericType.equals(type)) {
               // An element with the same type as the current - add it to the current list
               currentNumericElements.add(numericElement.getValue());
            } else {
               // Another type of element - output the current list and initialize a new list
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               label = null; // Only output label once
               currentNumericType = type;
               currentNumericElements = new ArrayList<>();
               currentNumericElements.add(numericElement.getValue());
            }
         }
      }
      // Output final list if present
      if(currentNumericElements != null && currentNumericElements.size() > 0) {
         asm.addDataNumeric(label, currentNumericType, currentNumericElements);
      }
   }


}
