package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLabel;
import dk.camelot64.kickc.model.statements.StatementProcedureBegin;
import dk.camelot64.kickc.model.statements.StatementProcedureEnd;
import dk.camelot64.kickc.model.values.LabelRef;

import java.util.ArrayList;
import java.util.List;

/** A sequence of statements used before pass1*/
public class StatementSequence {

   private ArrayList<Statement> statements;

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
               out.append(indent + "//" + comment + "\n");
            }
         }
         out.append(indent);
         out.append(statement.toString(program, false) + "\n");
      }
      return out.toString();
   }

   /**
    * Look backwar from the end of the sequence and find the last label
    * @return The label of the block, currently being build
    */
   public LabelRef getCurrentBlockLabel() {
      for(int i = statements.size()-1; i >= 0; i--) {
         Statement statement = statements.get(i);
         if(statement instanceof StatementLabel) {
            return ((StatementLabel) statement).getLabel();
         }
      }
      return null;
   }
}
