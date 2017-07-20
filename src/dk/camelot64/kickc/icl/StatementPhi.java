package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

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

   @JsonCreator
   StatementPhi(
         @JsonProperty("lValue") VariableRef lValue,
         @JsonProperty("previousVersions")  List<PreviousSymbol> previousVersions) {
      this.lValue = lValue;
      this.previousVersions = previousVersions;
   }

   public PreviousSymbol getPreviousVersion(int i) {
      return previousVersions.get(i);
   }

   /**
    * A previous version of the rValue that the phi function might take its value from.
    * Which value is chosen depends on which block transition was made.
    */
   public static class PreviousSymbol {
      private LabelRef block;
      private RValue rValue;

      @JsonCreator
      public PreviousSymbol(
            @JsonProperty("block") LabelRef block,
            @JsonProperty("rValue") RValue rValue) {
         this.block = block;
         this.rValue = rValue;
      }

      public LabelRef getBlock() {
         return block;
      }

      public RValue getrValue() {
         return rValue;
      }

      public void setrValue(RValue RValue) {
         this.rValue = RValue;
      }

      public void setBlock(LabelRef block) {
         this.block = block;
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;

         PreviousSymbol that = (PreviousSymbol) o;

         if (!block.equals(that.block)) return false;
         return rValue.equals(that.rValue);
      }

      @Override
      public int hashCode() {
         int result = block.hashCode();
         result = 31 * result + rValue.hashCode();
         return result;
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

   public void addPreviousVersion(LabelRef block, RValue rValue) {
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
         out.append(" "+previousSymbol.getBlock().getFullName()+"/"+previousSymbol.getrValue().getAsTypedString(scope));
      }
      out.append(" )");
      return out.toString();
   }

   @Override
   public String getAsString() {
      StringBuilder out = new StringBuilder();
      out.append(lValue + " ← " + "phi(");
      for (PreviousSymbol previousSymbol : previousVersions) {
         out.append(" "+previousSymbol.getBlock().getFullName()+"/"+previousSymbol.getrValue());
      }
      out.append(" )");
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if (this == o) return true;
      if (o == null || getClass() != o.getClass()) return false;

      StatementPhi that = (StatementPhi) o;

      if (!lValue.equals(that.lValue)) return false;
      return previousVersions.equals(that.previousVersions);
   }

   @Override
   public int hashCode() {
      int result = lValue.hashCode();
      result = 31 * result + previousVersions.hashCode();
      return result;
   }
}
