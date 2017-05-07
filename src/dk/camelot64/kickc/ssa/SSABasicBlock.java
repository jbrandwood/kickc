package dk.camelot64.kickc.ssa;

import java.util.ArrayList;
import java.util.List;

/** A sequence of SSA statements */
public class SSABasicBlock {

   List<SSAStatement> statements;

   public SSABasicBlock() {
      this.statements = new ArrayList<>();
   }

   public void addStatement(SSAStatement statement) {
      this.statements.add(statement);
   }

   @Override
   public String toString() {
      return "SSABasicBlock{" +
            "statements=" + statements +
            '}';
   }
}
