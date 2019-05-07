package dk.camelot64.kickc.model.types;

/** Container for function checking if types of an assignment match up */
public class SymbolTypeMatch {

   /**
    * Determines if the types of an assignment match up properly
    * @param lValueType The type of the LValue
    * @param rValueType The type of the RValue
    * @return true if the types match up
    */
   public static boolean assignmentTypeMatch(SymbolType lValueType, SymbolType rValueType) {
      if(lValueType.equals(rValueType)) {
         return true;
      }
      if(SymbolType.NUMBER.equals(rValueType) && SymbolType.isInteger(lValueType)) {
         // L-value is still a number - constants are probably not done being identified & typed
         return true;
      }
      if(SymbolType.STRING.equals(rValueType) && lValueType instanceof SymbolTypePointer && ((SymbolTypePointer) lValueType).getElementType().equals(SymbolType.BYTE)) {
         // String value can be assigned into a pointer
         return true;
      }
      if(lValueType instanceof SymbolTypePointer && rValueType instanceof SymbolTypePointer && assignmentTypeMatch(((SymbolTypePointer) lValueType).getElementType(), ((SymbolTypePointer) rValueType).getElementType())) {
         // Pointer types assigned from each other
         // TODO: Maybe handle sizes
         return true;
      }
      return false;
   }
}
