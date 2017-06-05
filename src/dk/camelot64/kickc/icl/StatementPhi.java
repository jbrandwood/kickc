package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/**
 * Single Static Assignment Form Phi Statement.
 * Selects appropriate value of a variable based on the actual control flow.
 * <br>
 * <i> X<sub>i</sub> := phi(X<sub>j</sub>, X<sub>k</sub>, ...) </i>
 */
public class StatementPhi implements StatementLValue {

   /** The versioned variable being assigned a value by the statement. */
   private VariableVersion lValue;

   /** The previous version of the rValue from predeccesor control blocks. */
   private List<PreviousSymbol> previousVersions;

   public StatementPhi(VariableVersion lValue) {
      this.lValue = lValue;
      this.previousVersions = new ArrayList<>();
   }

   /**
    * A previous version of the rValue that the phi function might take its value from.
    * Which value is chosen depends on which block transition was made.
    */
   public static class PreviousSymbol {
      private ControlFlowBlock block;
      private RValue rValue;

      public PreviousSymbol(ControlFlowBlock block, RValue rValue) {
         this.block = block;
         this.rValue = rValue;
      }

      public ControlFlowBlock getBlock() {
         return block;
      }

      public RValue getRValue() {
         return rValue;
      }


      public void setRValue(RValue RValue) {
         this.rValue = RValue;
      }

      public void setBlock(ControlFlowBlock block) {
         this.block = block;
      }
   }

   public VariableVersion getLValue() {
      return lValue;
   }

   @Override
   public void setLValue(LValue lValue) {
      if(!(lValue instanceof VariableVersion)) {
         throw new RuntimeException("Error modifying phi-statement lValue "+this.lValue+". Attempt to set to non-versioned variable "+lValue);
      }
      this.lValue = (VariableVersion) lValue;
   }

   public void addPreviousVersion(ControlFlowBlock block, VariableVersion symbol) {
      previousVersions.add(new PreviousSymbol(block, symbol));
   }

   public List<PreviousSymbol> getPreviousVersions() {
      return previousVersions;
   }

   @Override
   public String toString() {
      StringBuilder out = new StringBuilder();
      out.append(lValue + " ← " + "phi(");
      for (PreviousSymbol previousSymbol : previousVersions) {
         out.append(" "+previousSymbol.getBlock().getLabel().getLocalName()+"/"+previousSymbol.getRValue());
      }
      out.append(" )");
      return out.toString();
   }

}
