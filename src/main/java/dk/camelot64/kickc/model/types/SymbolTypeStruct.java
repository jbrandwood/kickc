package dk.camelot64.kickc.model.types;

import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;

import java.util.Locale;
import java.util.Objects;

/** A struct/union */
public class SymbolTypeStruct implements SymbolType {

   /** Name of the struct/union type. */
   private String structName;

   /** Size of the struct/union in bytes. */
   private int sizeBytes;

   /** Is this a union */
   private final boolean isUnion;

   /** Volatile type qualifier. */
   private final boolean isVolatile;
   /** Const type qualifier. */
   private final boolean isNomodify;

   public SymbolTypeStruct(String structName, boolean isUnion, int sizeBytes, boolean isVolatile, boolean isNomodify) {
      this.structName = structName;
      this.isUnion = isUnion;
      this.sizeBytes = sizeBytes;
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   public SymbolTypeStruct(StructDefinition structDefinition, boolean isVolatile, boolean isNomodify) {
      this.structName = structDefinition.getLocalName();
      this.isUnion = structDefinition.isUnion();
      this.sizeBytes = calculateSizeBytes(structDefinition, null);
      this.isVolatile = isVolatile;
      this.isNomodify = isNomodify;
   }

   @Override
   public SymbolType getQualified(boolean isVolatile, boolean isNomodify) {
      return new SymbolTypeStruct(this.structName, isUnion, this.sizeBytes, isVolatile, isNomodify);
   }

   public boolean isUnion() {
      return isUnion;
   }

   @Override
   public boolean isVolatile() {
      return isVolatile;
   }

   @Override
   public boolean isNomodify() {
      return isNomodify;
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
      if(isUnion) {
         for(Variable member : structDefinition.getAllVars(false)) {
            SymbolType memberType = member.getType();
            int memberSize = getMemberSizeBytes(memberType, member.getArraySize(), programScope);
            sizeBytes = Math.max(sizeBytes, memberSize);
         }
      }  else {
         for(Variable member : structDefinition.getAllVars(false)) {
            SymbolType memberType = member.getType();
            int memberSize = getMemberSizeBytes(memberType, member.getArraySize(), programScope);
            sizeBytes += memberSize;
         }
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
      return isUnion == that.isUnion &&
            structName.equals(that.structName);
   }

   @Override
   public int hashCode() {
      return Objects.hash(structName, isUnion);
   }

   @Override
   public String toString() {
      return toCDecl();
   }

   @Override
   public String toCDecl(String parentCDecl) {
      StringBuilder cdecl = new StringBuilder();
      if(isVolatile())
         cdecl.append("volatile ");
      if(isNomodify())
         cdecl.append("const ");
      if(isUnion) {
         cdecl.append("union ");
      }  else {
         cdecl.append("struct ");
      }
      cdecl.append(this.structName);
      if(parentCDecl.length()>0)
         cdecl.append(" ");
      cdecl.append(parentCDecl);
      return cdecl.toString();
   }

   @Override
   public String getConstantFriendlyName() {
      if(isUnion) {
         return "UNION_"+structName.toUpperCase(Locale.ENGLISH);
      } else {
         return "STRUCT_"+structName.toUpperCase(Locale.ENGLISH);
      }
   }
}
