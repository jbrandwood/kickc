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
   private VariableRef lValue;

   /** The previous version of the rValue from predeccesor control blocks. */
   private List<PreviousSymbol> previousVersions;

   public StatementPhi(VariableRef lValue) {
      this.lValue = lValue;
      this.previousVersions = new ArrayList<>();
   }

   public PreviousSymbol getPreviousVersion(int i) {
      return previousVersions.get(i);
   }

   /**
    * A previous version of the rValue that the phi function might take its value from.
    * Which value is chosen depends on which block transition was made.
    */
   public static class PreviousSymbol {
      private Label block;
      private RValue rValue;

      public PreviousSymbol(Label block, RValue rValue) {
         this.block = block;
         this.rValue = rValue;
      }

      public Label getBlock() {
         return block;
      }

      public RValue getRValue() {
         return rValue;
      }

      public void setRValue(RValue RValue) {
         this.rValue = RValue;
      }

      public void setBlock(Label block) {
         this.block = block;
      }
   }

   public VariableRef getlValue() {
      return lValue;
   }

   @Override
   public void setlValue(LValue lValue) {
      if(!(lValue instanceof VariableRef)) {
         throw new RuntimeException("Error modifying phi-statement lValue "+this.lValue+". Attempt to set to non-versioned variable "+lValue);
      }
      this.lValue = (VariableRef) lValue;
   }

   public void addPreviousVersion(Label block, RValue rValue) {
      previousVersions.add(new PreviousSymbol(block, rValue));
   }

   public List<PreviousSymbol> getPreviousVersions() {
      return previousVersions;
   }

   @Override
   public String toString() {
      return getAsString();
   }

   @Override
   public String getAsTypedString(ProgramScope scope) {
      StringBuilder out = new StringBuilder();
      out.append(lValue.getAsTypedString(scope) + " ← " + "phi(");
      for (PreviousSymbol previousSymbol : previousVersions) {
         out.append(" "+previousSymbol.getBlock().getFullName()+"/"+previousSymbol.getRValue().getAsTypedString(scope));
      }
      out.append(" )");
      return out.toString();
   }

   @Override
   public String getAsString() {
      StringBuilder out = new StringBuilder();
      out.append(lValue + " ← " + "phi(");
      for (PreviousSymbol previousSymbol : previousVersions) {
         out.append(" "+previousSymbol.getBlock().getFullName()+"/"+previousSymbol.getRValue());
      }
      out.append(" )");
      return out.toString();
   }
}
