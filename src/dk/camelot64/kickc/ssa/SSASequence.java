package dk.camelot64.kickc.ssa;

import java.util.ArrayList;
import java.util.List;

/**
 * A sequence of SSA Statements
 */
public class SSASequence {

   List<SSAStatement> statements;

   public SSASequence() {
      this.statements = new ArrayList<>();
   }

   public void addStatement(SSAStatement statement) {
      this.statements.add(statement);
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (SSAStatement statement : statements) {
         out.append(statement.toString()+"\n");
      }
      return out.toString();
   }

   public List<SSAStatement> getStatements() {
      return statements;
   }
}
