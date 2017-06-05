package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.List;

/** A sequence of Statements */
public class StatementSequence {

   private List<Statement> statements;

   public StatementSequence() {
      this.statements = new ArrayList<>();
   }

   public void addStatement(Statement statement) {
      this.statements.add(statement);
   }

   @Override
   public String toString() {
      StringBuffer out = new StringBuffer();
      for (Statement statement : statements) {
         if(!(statement instanceof StatementLabel)) {
             out.append("  ");
         }
         out.append(statement.toString()+"\n");
      }
      return out.toString();
   }

   public List<Statement> getStatements() {
      return statements;
   }
}
