package dk.camelot64.kickc.model.statements;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.RValue;

import java.util.List;
import java.util.Objects;

/**
 * Call procedure in SSA form.
 * <br>
 * <i> X<sub>i</sub> := call label param1 param2 param3 ... </i>
 */
public class StatementCall extends StatementBase implements StatementLValue, StatementCalling {

   /** The variable being assigned a value by the call. Can be null. */
   private LValue lValue;
   /** The name of the procedure called */
   private String procedureName;
   /** The procedure called. */
   private ProcedureRef procedure;
   /** The parameter values passed to the procedure. */
   private List<RValue> parameters;
   /** This is the initial assignment of the lValue. */
   private boolean initialAssignment;

   public StatementCall(LValue lValue, String procedureName, List<RValue> parameters, StatementSource source, List<Comment> comments) {
      super(source, comments);
      this.lValue = lValue;
      this.procedureName = procedureName;
      this.parameters = parameters;
   }

   public LValue getlValue() {
      return lValue;
   }

   public void setlValue(LValue lValue) {
      this.lValue = lValue;
   }

   public String getProcedureName() {
      return procedureName;
   }

   public ProcedureRef getProcedure() {
      return procedure;
   }

   public void setProcedure(ProcedureRef procedure) {
      this.procedure = procedure;
   }

   public List<RValue> getParameters() {
      return parameters;
   }

   public void setParameters(List<RValue> parameters) {
      this.parameters = parameters;
   }

   public int getNumParameters() {
      return parameters.size();
   }

   public RValue getParameter(int idx) {
      return parameters.get(idx);
   }

   public void clearParameters() {
      this.parameters = null;
   }

   @Override
   public boolean isInitialAssignment() {
      return initialAssignment;
   }

   public void setInitialAssignment(boolean initialAssignment) {
      this.initialAssignment = initialAssignment;
   }

   @Override
   public String toString(Program program, boolean aliveInfo) {
      return toString(program, false, aliveInfo);
   }

   public String toString(Program program, boolean onlyTypes, boolean aliveInfo) {
      StringBuilder res = new StringBuilder();
      res.append(super.idxString());
      if(lValue != null) {
         res.append(lValue.toString(program));
         res.append(" = ");
      }
      res.append("call ");
      if(procedure != null) {
         res.append(procedure.getFullName());
      } else {
         res.append(procedureName);
      }
      if(parameters != null && parameters.size()>0) {
         res.append("(");
         boolean first = true;
         for(RValue parameter : parameters) {
            if(!first) res.append(", ");
            first = false;
            if(onlyTypes) {
               final SymbolType symbolType = SymbolTypeInference.inferType(program.getScope(), parameter);
               res.append(symbolType.toCDecl());
            } else {
               res.append(parameter.toString(program));
            }
         }
         res.append(")");
      }
      if(aliveInfo) {
         res.append(super.aliveString(program));
      }
      return res.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      if(!super.equals(o)) return false;
      StatementCall that = (StatementCall) o;
      return Objects.equals(lValue, that.lValue) &&
            Objects.equals(procedureName, that.procedureName) &&
            Objects.equals(procedure, that.procedure) &&
            Objects.equals(parameters, that.parameters);
   }

   @Override
   public int hashCode() {
      return Objects.hash(super.hashCode(), lValue, procedureName, procedure, parameters);
   }
}
