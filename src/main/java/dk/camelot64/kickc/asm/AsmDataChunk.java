package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.values.ConstantString;

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
      Set<ConstantString.Encoding> encoding;

      AsmDataNumericElement(AsmDataNumeric.Type type, String value, Set<ConstantString.Encoding> encoding) {
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

      public Set<ConstantString.Encoding> getEncoding() {
         return encoding;
      }
   }

   /** A number of identical numerical data elements. */
   public static class AsmDataFilledElement implements AsmDataElement {
      /** The type of the element */
      AsmDataNumeric.Type type;
      /** The ASM specifying how many elements to fill. */
      String sizeAsm;
      /** The literal integer number of elements. */
      int size;
      /** The fill value. */
      String fillValue;
      /** The string encoding used in any char/string value */
      Set<ConstantString.Encoding> encoding;

      AsmDataFilledElement(AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue, Set<ConstantString.Encoding> encoding) {
         this.type = type;
         this.sizeAsm = sizeAsm;
         this.size = size;
         this.fillValue = fillValue;
         this.encoding = encoding;
      }

      public AsmDataNumeric.Type getType() {
         return type;
      }

      String getSizeAsm() {
         return sizeAsm;
      }

      public int getSize() {
         return size;
      }

      String getFillValue() {
         return fillValue;
      }

      public Set<ConstantString.Encoding> getEncoding() {
         return encoding;
      }
   }

   /** A string data elements. */
   public static class AsmDataStringElement implements AsmDataElement {
      /** The string value. */
      String value;
      /** The string encoding used in the string value */
      Set<ConstantString.Encoding> encoding;

      AsmDataStringElement(String value, Set<ConstantString.Encoding> encoding) {
         this.value = value;
         this.encoding = encoding;
      }

      public String getValue() {
         return value;
      }

      public Set<ConstantString.Encoding> getEncoding() {
         return encoding;
      }
   }

   /** A sequence of data elements. */
   private List<AsmDataElement> elements;

   public AsmDataChunk() {
      this.elements = new ArrayList<>();
   }

   public void addDataNumeric(AsmDataNumeric.Type type, String value, Set<ConstantString.Encoding> encoding) {
      elements.add(new AsmDataNumericElement(type, value, encoding));
   }

   public void addDataFilled(AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue, Set<ConstantString.Encoding> encoding) {
      elements.add(new AsmDataFilledElement(type, sizeAsm, size, fillValue, encoding));
   }

   public void addDataString(String string, Set<ConstantString.Encoding> encoding) {
      elements.add(new AsmDataStringElement(string, encoding));
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
         if(element instanceof AsmDataFilledElement) {
            if(currentNumericElements!=null && currentNumericElements.size() > 0) {
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               label = null; // Only output label once
               currentNumericElements = null;
               currentNumericType = null;
            }
            AsmDataFilledElement filledElement = (AsmDataFilledElement) element;
            asm.ensureEncoding(filledElement.getEncoding());
            asm.addDataFilled(label, filledElement.getType(), filledElement.getSizeAsm(), filledElement.getSize(), filledElement.getFillValue());
            label = null; // Only output label once
         } else if(element instanceof AsmDataStringElement) {
            if(currentNumericElements!=null && currentNumericElements.size() > 0) {
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               label = null; // Only output label once
               currentNumericElements = null;
               currentNumericType = null;
            }
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
