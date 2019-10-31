package dk.camelot64.kickc.model.symbols;

import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * A Variable in the program.
 */
public class Variable extends SymbolVariable {

   public Variable(String name, Scope scope, SymbolType type, String dataSegment, StorageStrategy storageStrategy, MemoryArea memoryArea) {
      super(name, scope, type, storageStrategy, memoryArea, dataSegment);
   }

   /**
    * Create a version of a PHI master variable
    *
    * @param phiMaster The PHI master variable.
    * @param version The version number
    */
   public Variable(SymbolVariable phiMaster, int version) {
      super(phiMaster.getName() + "#" + version, phiMaster.getScope(), phiMaster.getType(), StorageStrategy.PHI_VERSION, phiMaster.getMemoryArea(), phiMaster.getDataSegment());
      this.setDeclaredAlignment(phiMaster.getDeclaredAlignment());
      this.setDeclaredAsRegister(phiMaster.isDeclaredAsRegister());
      this.setDeclaredNotRegister(phiMaster.isDeclaredAsNotRegister());
      this.setConstantDeclaration(phiMaster.getConstantDeclaration());
      this.setDeclaredRegister(phiMaster.getDeclaredRegister());
      this.setDeclaredVolatile(phiMaster.isDeclaredVolatile());
      this.setDeclaredExport(phiMaster.isDeclaredExport());
      this.setInferedVolatile(phiMaster.isInferedVolatile());
      this.setInferredType(phiMaster.isInferredType());
      this.setComments(phiMaster.getComments());
   }

   public VariableRef getRef() {
      return new VariableRef(this);
   }

}
