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

   public List<Statement> getStatements() {
      return statements;
   }

   public String toString(Program program) {
      StringBuffer out = new StringBuffer();
      for (Statement statement : statements) {
         if(!(statement instanceof StatementLabel)) {
            out.append("  ");
         }
         out.append(statement.toString(program)+"\n");
      }
      return out.toString();
   }

}
