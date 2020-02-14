package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableReferenceInfos;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.passes.utils.VarAssignments;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;

/**
 * Convert condition variables in unrolled jumps to single-static-assignment
 */
public class Pass1UnrollConditionVariableSsa extends Pass2SsaOptimization {

   public Pass1UnrollConditionVariableSsa(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementConditionalJump) {
               final StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
               if(conditionalJump.isDeclaredUnroll()) {
                  Collection<VariableRef> referencedVars = new LinkedHashSet<>();
                  findAllReferencedVars(referencedVars, conditionalJump.getrValue1());
                  findAllReferencedVars(referencedVars, conditionalJump.getrValue2());
                  for(VariableRef referencedVar : referencedVars) {
                     final Variable variable = getScope().getVariable(referencedVar);
                     if(variable.isKindLoadStore()) {
                        // Convert the variable to versioned if it is load/store
                        getLog().append("Converting unrolled condition variable to single-static-assignment "+variable);
                        variable.setKind(Variable.Kind.PHI_MASTER);
                     }
                  }
               }
            }
         }
      }
      return false;
   }

   /**
    * Find all referenced variables in a value. If an intermediate variable is referenced this recurses to the definition of the intermediate.
    * @param referencedVars The collection to fill
    * @param rValue The value to find references in
    */
   private void findAllReferencedVars(Collection<VariableRef> referencedVars, RValue rValue) {
      Collection<VariableRef> directReferenced = VariableReferenceInfos.getReferencedVars(rValue);
      referencedVars.addAll(directReferenced);
      for(VariableRef varRef : directReferenced) {
         if(varRef.isIntermediate()) {
            // Found an intermediate variable - recurse to the definition
            final List<VarAssignments.VarAssignment> varAssignments = VarAssignments.get(varRef, getGraph(), getScope());
            for(VarAssignments.VarAssignment varAssignment : varAssignments) {
               if(VarAssignments.VarAssignment.Type.STATEMENT_LVALUE.equals(varAssignment.type)) {
                  if(varAssignment.statementLValue instanceof StatementAssignment) {
                     findAllReferencedVars(referencedVars, ((StatementAssignment) varAssignment.statementLValue).getrValue1());
                     findAllReferencedVars(referencedVars, ((StatementAssignment) varAssignment.statementLValue).getrValue2());
                  }  else {
                     throw new InternalError("Not implemented!");
                  }
               }  else {
                  throw new InternalError("Not implemented!");
               }
            }
         }
      }
   }

}
