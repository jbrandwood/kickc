package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.Objects;

/** A struct */
public class SymbolTypeStruct implements SymbolType {

   /** Name of the struct type. */
   private String structName;

   /** Size of the struct in bytes. */
   private int sizeBytes;

   private final boolean isVolatile;
   private final boolean isNomodify;

   public SymbolTypeStruct(String structName, int sizeBytes, boolean isVolatile, boolean isNomodify) {
      this.structName = structName;
      this.sizeBytes = sizeBytes;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   public SymbolTypeStruct(StructDefinition structDefinition, boolean isVolatile, boolean isNomodify) {
      this.structName = structDefinition.getLocalName();
      this.sizeBytes = calculateSizeBytes(structDefinition, null);
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeStruct(this.structName, this.sizeBytes, isVolatile, isNomodify);
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
   }

   @Override
   public String getTypeName() {
      String name = "";
      // TODO #121 Add
      /*
      if(isVolatile)
         name += "volatile ";
      if(isNomodify)
         name += "const ";
   */
      name += "struct " + this.structName;
      return name;
   }

   public String getStructTypeName() {
      return structName;
   }

   public StructDefinition getStructDefinition(ProgramScope programScope) {
      return programScope.getLocalStructDefinition(structName);
   }

   @Override
   public int getSizeBytes() {
      return sizeBytes;
   }

   public void setSizeBytes(int sizeBytes) {
      this.sizeBytes = sizeBytes;
   }

   /**
    * Calculate the number of bytes used by the struct by calculating bytes used by each member
    *
    * @param structDefinition The struct definition (get using getStructDefinition)
    * @return The number of bytes a struct value require
    */
   public int calculateSizeBytes(StructDefinition structDefinition, ProgramScope programScope) {
      int sizeBytes = 0;
      for(Variable member : structDefinition.getAllVars(false)) {
         SymbolType memberType = member.getType();
         int memberSize = getMemberSizeBytes(memberType, member.getArraySize(), programScope);
         sizeBytes += memberSize;
      }
      return sizeBytes;
   }

   public static int getMemberSizeBytes(SymbolType memberType, ConstantValue arraySize, ProgramScope programScope) {
      if(arraySize!=null) {
         final SymbolType elementType = ((SymbolTypePointer) memberType).getElementType();
         if(programScope != null) {
            ConstantLiteral sizeLiteral = arraySize.calculateLiteral(programScope);
            if(sizeLiteral instanceof ConstantInteger) {
               return elementType.getSizeBytes() * ((ConstantInteger) sizeLiteral).getInteger().intValue();
            }
         } else {
            return 5; // Add a token size
         }
      } else {
         return memberType.getSizeBytes();
      }
      throw new InternalError("Member type not handled " + memberType);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeStruct that = (SymbolTypeStruct) o;
      return Objects.equals(structName, that.structName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(structName, sizeBytes);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
