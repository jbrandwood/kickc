package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLabel;
import dk.camelot64.kickc.model.statements.StatementProcedureBegin;
import dk.camelot64.kickc.model.statements.StatementProcedureEnd;

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
      for(Statement statement : statements) {
         String indent = "";
         if(!(statement instanceof StatementLabel) && !(statement instanceof StatementProcedureBegin) && !(statement instanceof StatementProcedureEnd)) {
            indent = "  ";
         }
         if(program.getLog().isVerboseComments()) {
            for(Comment comment : statement.getComments()) {
               out.append(indent + "// " + comment + "\n");
            }
         }
         out.append(indent);
         out.append(statement.toString(program, false) + "\n");
      }
      return out.toString();
   }

}
