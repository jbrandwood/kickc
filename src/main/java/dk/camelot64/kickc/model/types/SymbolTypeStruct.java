package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.Objects;

/** A struct */
public class SymbolTypeStruct implements SymbolType {

   /** Name of the struct type. */
   private String name;

   /** Size of the struct in bytes. */
   private int sizeBytes;

   public SymbolTypeStruct(StructDefinition structDefinition) {
      this.name = structDefinition.getLocalName();
      this.sizeBytes = calculateSizeBytes(structDefinition, null);
   }

   @Override
   public String getTypeName() {
      return "struct " + name;
   }

   public String getStructTypeName() {
      return name;
   }

   public StructDefinition getStructDefinition(ProgramScope programScope) {
      return programScope.getStructDefinition(name);
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
    * @param structDefinition The struct definition (get using getStructDefinition)
    * @return The number of bytes a struct value require
    */
   public int calculateSizeBytes(StructDefinition structDefinition, ProgramScope programScope) {
      int sizeBytes = 0;
      for(Variable member : structDefinition.getAllVariables(false)) {
         SymbolType memberType = member.getType();
         int memberSize = getMemberSizeBytes(memberType, programScope);
         sizeBytes += memberSize;
      }
      return sizeBytes;
   }

   public static int getMemberSizeBytes(SymbolType memberType, ProgramScope programScope) {
      if(memberType instanceof SymbolTypeArray && ((SymbolTypeArray) memberType).getSize()!=null) {
         if(programScope!=null) {
            RValue memberArraySize = ((SymbolTypeArray) memberType).getSize();
            if(memberArraySize instanceof ConstantValue) {
               ConstantLiteral sizeLiteral = ((ConstantValue) memberArraySize).calculateLiteral(programScope);
               if(sizeLiteral instanceof ConstantInteger) {
                  return ((ConstantInteger) sizeLiteral).getInteger().intValue();
               }
            }
         } else {
            return 5; // Add a token size
         }
      }  else {
         return memberType.getSizeBytes();
      }
      throw new InternalError("Memeber type not handled "+memberType);
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      SymbolTypeStruct that = (SymbolTypeStruct) o;
      return sizeBytes == that.sizeBytes &&
            Objects.equals(name, that.name);
   }

   @Override
   public int hashCode() {
      return Objects.hash(name, sizeBytes);
   }

   @Override
   public String toString() {
      return getTypeName();
   }

}
