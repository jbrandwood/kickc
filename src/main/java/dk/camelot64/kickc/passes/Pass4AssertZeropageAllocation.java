package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.symbols.SymbolVariable;

import java.util.Collection;

/*** Ensures that the variables fit on zeropage.  */
public class Pass4AssertZeropageAllocation extends Pass2Base {

   public Pass4AssertZeropageAllocation(Program program) {
      super(program);
   }

   /**
    * Check that all variables fit onto zeropage
    */
   public void check() {
      Collection<SymbolVariable> allVariables = getSymbols().getAllVariables(true);
      for(SymbolVariable variable : allVariables) {
         Registers.Register allocation = variable.getAllocation();
         if(allocation != null && Registers.RegisterType.ZP_MEM.equals(allocation.getType())) {
            int zp = ((Registers.RegisterZpMem) allocation).getZp();
            int sizeBytes = variable.getType().getSizeBytes();
            if(zp + sizeBytes > 0x100) {
               // Allocation is outside ZP!
               throw new CompileError("Error! Variables used in program do not fit on zeropage. Maybe try compiling with -Ocoalesce to optimize ZP usage.");
            }
         }
      }
   }

}
