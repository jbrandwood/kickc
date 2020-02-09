package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.values.ConstantValue;

/**
 * Specification of array properties of a variable.
 * The presence of this means the variable is an array.
 * If the size of the array is fixed this will contain the size.
 * */
public class ArraySpec {

   /** If the variable is a fixed size array this is the fixed size of the array. */
   private ConstantValue arraySize;

   public ArraySpec() {
   }

   public ArraySpec(ConstantValue arraySize) {
      this.arraySize = arraySize;
   }

   public ConstantValue getArraySize() {
      return arraySize;
   }

   public void setArraySize(ConstantValue arraySize) {
      this.arraySize = arraySize;
   }
}
