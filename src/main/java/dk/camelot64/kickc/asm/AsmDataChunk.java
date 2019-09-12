package dk.camelot64.kickc.asm;

import java.util.ArrayList;
import java.util.List;

/** A sequence of data elements to add to the ASM program. */
public class AsmDataChunk {

   public interface AsmDataElement {

   }

   /** A single numeric data element. */
   public static class AsmDataNumericElement implements AsmDataElement {
      /** The type of the data element. */
      AsmDataNumeric.Type type;
      /** The value of the data element. */
      String value;

      public AsmDataNumericElement(AsmDataNumeric.Type type, String value) {
         this.type = type;
         this.value = value;
      }

      public AsmDataNumeric.Type getType() {
         return type;
      }

      public String getValue() {
         return value;
      }
   }

   /** A number of identical numerical data elements. */
   public static class AsmDataFilledElement implements AsmDataElement {
      AsmDataNumeric.Type type;
      String sizeAsm;
      int size;
      String fillValue;

      public AsmDataFilledElement(AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue) {
         this.type = type;
         this.sizeAsm = sizeAsm;
         this.size = size;
         this.fillValue = fillValue;
      }

      public AsmDataNumeric.Type getType() {
         return type;
      }

      public String getSizeAsm() {
         return sizeAsm;
      }

      public int getSize() {
         return size;
      }

      public String getFillValue() {
         return fillValue;
      }
   }

   /** A string data elements. */
   public static class AsmDataStringElement implements AsmDataElement {
      String value;

      public AsmDataStringElement(String value) {
         this.value = value;
      }

      public String getValue() {
         return value;
      }

   }

   /** A sequence of data elements. */
   List<AsmDataElement> elements;

   public AsmDataChunk() {
      this.elements = new ArrayList<>();
   }

   public void addDataNumeric(AsmDataNumeric.Type type, String value) {
      elements.add(new AsmDataNumericElement(type, value));
   }

   public void addDataFilled(AsmDataNumeric.Type type, String sizeAsm, int size, String fillValue) {
      elements.add(new AsmDataFilledElement(type, sizeAsm, size, fillValue));
   }

   public void addDataString(String string) {
      elements.add(new AsmDataStringElement(string));
   }

   public List<AsmDataElement> getElements() {
      return elements;
   }

   /**
    * Add BYTE/WORD/DWORD data declaration to the ASM for a whole chunk of numeric data.
    * Produces 1-N ASM lines depending on the number of and types of data added.
    *
    * @param label The label of the data. Can be null.
    * @param dataChunk The chunk of numeric data to add.
    */
   public void addToAsm(String label, AsmProgram asm) {
      AsmDataNumeric.Type currentNumericType = null;
      List<String> currentNumericElements = null;
      for(AsmDataChunk.AsmDataElement element : this.getElements()) {
         if(element instanceof AsmDataFilledElement) {
            if(currentNumericElements.size()>0) {
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               currentNumericElements = null;
               currentNumericType = null;
            }
            AsmDataFilledElement filledElement = (AsmDataFilledElement) element;
            asm.addDataFilled(label, filledElement.getType(), filledElement.getSizeAsm(), filledElement.getSize(), filledElement.getFillValue());
            label = null; // Only output label once
         }  else if(element instanceof AsmDataStringElement) {
            if(currentNumericElements.size()>0) {
               asm.addDataNumeric(label, currentNumericType, currentNumericElements);
               currentNumericElements = null;
               currentNumericType = null;
            }
            asm.addDataString(label, ((AsmDataStringElement) element).getValue());
            label = null; // Only output label once
         }  else if(element instanceof AsmDataNumericElement) {
            AsmDataNumericElement numericElement = (AsmDataNumericElement) element;
            AsmDataNumeric.Type type = numericElement.getType();
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
      if(currentNumericElements!=null && currentNumericElements.size()>0) {
         asm.addDataNumeric(label, currentNumericType, currentNumericElements);
      }
   }


}
