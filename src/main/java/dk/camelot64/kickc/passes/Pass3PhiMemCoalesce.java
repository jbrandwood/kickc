package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Eliminate virtual variables introduced by PhiLifting if they do not have overlapping live ranges with other phi equivalent variables.
 * (This pass requires variable alive ranges).
 * <p>
 * This utilized live range equivalence classes over the phi statements of the program.
 * In the phi statement <code>va = phi(vb, vc)</code> all 3 variables are in the same equivalence class.
 * The equivalence class is the closure over all phi statements in the program.
 * The set of equivalence classes is a disjoint partition of all variables uses in phi statements
 * (ie. those variables crossing non-trivial block transitions).
 * <p>
 * See http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 *
 */
public class Pass3PhiMemCoalesce extends Pass2SsaOptimization {

   public Pass3PhiMemCoalesce(Program program) {
      super(program);
   }

   @Override
   public boolean optimize() {
      EquivalenceClassPhiInitializer equivalenceClassPhiInitializer = new EquivalenceClassPhiInitializer(getProgram());
      equivalenceClassPhiInitializer.visitGraph(getGraph());
      LiveRangeEquivalenceClassSet phiEquivalenceClasses = equivalenceClassPhiInitializer.getPhiEquivalenceClasses();
      getLog().append("Created " + phiEquivalenceClasses.size() + " initial phi equivalence classes");
      PhiMemCoalescer phiMemCoalescer = new PhiMemCoalescer(phiEquivalenceClasses);
      phiMemCoalescer.visitGraph(getGraph());
      removeAssignments(phiMemCoalescer.getRemove());
      replaceVariables(phiMemCoalescer.getReplace());
      deleteSymbols(phiMemCoalescer.getRemove());
      getLog().append("Coalesced down to " + phiEquivalenceClasses.size() + " phi equivalence classes");
      return false;
   }

   /** Coalesces phi equivalence classes when they do not overlap based on assignments to variables in phi statements. */
   private class PhiMemCoalescer extends ControlFlowGraphBaseVisitor<Void> {

      private LiveRangeEquivalenceClassSet phiEquivalenceClassSet;
      private List<VariableRef> remove;
      private Map<VariableRef, VariableRef> replace;

      public PhiMemCoalescer(LiveRangeEquivalenceClassSet phiEquivalenceClassSet) {
         this.phiEquivalenceClassSet = phiEquivalenceClassSet;
         this.remove = new ArrayList<>();
         this.replace = new HashMap<>();
      }

      public List<VariableRef> getRemove() {
         return remove;
      }

      public Map<VariableRef, VariableRef> getReplace() {
         return replace;
      }

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         if (assignment.getlValue() instanceof VariableRef) {
            LiveRangeEquivalenceClass lValEquivalenceClass =
                  phiEquivalenceClassSet.getEquivalenceClass((VariableRef) assignment.getlValue());
            if (lValEquivalenceClass != null && assignment.getOperator() == null && assignment.getrValue1() == null && assignment.getrValue2() instanceof VariableRef) {
               // Found copy assignment to a variable in an equivalence class - attempt to coalesce
               VariableRef assignVar = (VariableRef) assignment.getrValue2();
               LiveRangeEquivalenceClass assignVarEquivalenceClass = phiEquivalenceClassSet.getOrCreateEquivalenceClass(assignVar);
               if (lValEquivalenceClass.equals(assignVarEquivalenceClass)) {
                  remove.add((VariableRef) assignment.getlValue());
                  replace.put((VariableRef) assignment.getlValue(), assignVar);
                  getLog().append("Coalesced (already) " + assignment);
               } else if (!lValEquivalenceClass.getLiveRange().overlaps(assignVarEquivalenceClass.getLiveRange())) {
                  phiEquivalenceClassSet.consolidate(lValEquivalenceClass, assignVarEquivalenceClass);
                  remove.add((VariableRef) assignment.getlValue());
                  replace.put((VariableRef) assignment.getlValue(), assignVar);
                  getLog().append("Coalesced " + assignment);
               } else {
                  getLog().append("Not coalescing " + assignment);
               }
            }
         }
         return null;
      }

   }

   /**
    * Creates initial live range equivalence classes from program phi statements.
    */
   public static class EquivalenceClassPhiInitializer extends ControlFlowGraphBaseVisitor<Void> {

      private LiveRangeEquivalenceClassSet phiEquivalenceClasses;

      public EquivalenceClassPhiInitializer(Program program) {
         this.phiEquivalenceClasses = new LiveRangeEquivalenceClassSet(program);
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            VariableRef variable = phiVariable.getVariable();
            LiveRangeEquivalenceClass equivalenceClass = phiEquivalenceClasses.getOrCreateEquivalenceClass(variable);
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if (!(phiRValue.getrValue() instanceof ConstantValue)) {
                  VariableRef phiRVar = (VariableRef) phiRValue.getrValue();
                  LiveRangeEquivalenceClass rValEquivalenceClass = phiEquivalenceClasses.getOrCreateEquivalenceClass(phiRVar);
                  if(!rValEquivalenceClass.equals(equivalenceClass)) {
                     phiEquivalenceClasses.consolidate(equivalenceClass, rValEquivalenceClass);
                  }
               }
            }
         }
         return null;
      }

      public LiveRangeEquivalenceClassSet getPhiEquivalenceClasses() {
         return phiEquivalenceClasses;
      }
   }

}
