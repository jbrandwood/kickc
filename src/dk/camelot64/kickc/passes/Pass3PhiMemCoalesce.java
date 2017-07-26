package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Eliminate virtual variables introduced by PhiLifting if they do not have overlapping live ranges with other phi equivalent variables.
 * (This pass requires variable alive ranges).
 * <p>
 * See http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
 */
public class Pass3PhiMemCoalesce extends Pass2SsaOptimization {

   public Pass3PhiMemCoalesce(Program program, CompileLog log) {
      super(program, log);
   }

   @Override
   public boolean optimize() {
      PhiEquivalenceClassInitializer phiEquivalenceClassInitializer = new PhiEquivalenceClassInitializer();
      phiEquivalenceClassInitializer.visitGraph(getGraph());
      ProgramPhiEquivalenceClasses phiEquivalenceClasses = phiEquivalenceClassInitializer.getPhiEquivalenceClasses();
      log.append("Created " +phiEquivalenceClasses.size()+ " initial phi equivalence classes");
      PhiMemCoalescer phiMemCoalescer = new PhiMemCoalescer(phiEquivalenceClasses);
      phiMemCoalescer.visitGraph(getGraph());
      removeAssignments(phiMemCoalescer.getRemove());
      replaceVariables(phiMemCoalescer.getReplace());
      deleteVariables(phiMemCoalescer.getRemove());
      log.append("Coalesced down to " +phiEquivalenceClasses.size()+ " phi equivalence classes");
      return false;
   }

   /** Coalesces phi equivalence classes when they do not overlap based on assignments to variables in phi statements. */
   private class PhiMemCoalescer extends ControlFlowGraphBaseVisitor<Void> {

      private ProgramPhiEquivalenceClasses phiEquivalenceClasses;
      private List<VariableRef> remove;
      private Map<VariableRef, VariableRef> replace;

      public PhiMemCoalescer(ProgramPhiEquivalenceClasses phiEquivalenceClasses) {
         this.phiEquivalenceClasses = phiEquivalenceClasses;
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
            PhiEquivalenceClass lValEquivalenceClass =
                  phiEquivalenceClasses.getPhiEquivalenceClass((VariableRef) assignment.getlValue());
            if (lValEquivalenceClass != null && assignment.getOperator() == null && assignment.getrValue1() == null && assignment.getrValue2() instanceof VariableRef) {
               // Found copy assignment to a variable in an equivalence class - attempt to coalesce
               VariableRef assignVar = (VariableRef) assignment.getrValue2();
               PhiEquivalenceClass assignVarEquivalenceClass = phiEquivalenceClasses.getOrCreateEquivalenceClass(assignVar);
               if(lValEquivalenceClass.equals(assignVarEquivalenceClass)) {
                  remove.add((VariableRef) assignment.getlValue());
                  replace.put((VariableRef) assignment.getlValue(), assignVar);
                  log.append("Coalesced (already) "+assignment);
               } else if (!lValEquivalenceClass.getLiveRange().overlaps(assignVarEquivalenceClass.getLiveRange())) {
                  lValEquivalenceClass.addAll(assignVarEquivalenceClass);
                  phiEquivalenceClasses.remove(assignVarEquivalenceClass);
                  remove.add((VariableRef) assignment.getlValue());
                  replace.put((VariableRef) assignment.getlValue(), assignVar);
                  log.append("Coalesced "+assignment);
               } else {
                  log.append("Not coalescing "+assignment);
               }
            }
         }
         return null;
      }

   }


   /** Creates initial phi equivalence classes from program phi statements.*/
   private class PhiEquivalenceClassInitializer extends ControlFlowGraphBaseVisitor<Void> {

      private ProgramPhiEquivalenceClasses phiEquivalenceClasses;

      public PhiEquivalenceClassInitializer() {
         this.phiEquivalenceClasses = new ProgramPhiEquivalenceClasses();
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            VariableRef variable = phiVariable.getVariable();
            PhiEquivalenceClass equivalenceClass = phiEquivalenceClasses.getOrCreateEquivalenceClass(variable);
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               if(!(phiRValue.getrValue() instanceof Constant)) {
                  VariableRef phiRVar = (VariableRef) phiRValue.getrValue();
                  equivalenceClass.addVariable(phiRVar);
               }
            }
         }
         return null;
      }

      public ProgramPhiEquivalenceClasses getPhiEquivalenceClasses() {
         return phiEquivalenceClasses;
      }
   }

   /** The entire set of phi equivalence classes in the pgogram. */
   public class ProgramPhiEquivalenceClasses {
      
      List<PhiEquivalenceClass> equivalenceClasses;

      public ProgramPhiEquivalenceClasses() {
         this.equivalenceClasses = new ArrayList<>();
      }

      /**
       * Get the phi equivalence class for a specific variable.
       * If the equivalence class does not exist it is created.
       *
       * @param variable The variable
       * @return The existing or new phi equivalence class
       */
      public PhiEquivalenceClass getOrCreateEquivalenceClass(VariableRef variable) {
         PhiEquivalenceClass equivalenceClass1 = getPhiEquivalenceClass(variable);
         if (equivalenceClass1 != null) return equivalenceClass1;
         // Not found - create it
         PhiEquivalenceClass equivalenceClass = new PhiEquivalenceClass();
         equivalenceClasses.add(equivalenceClass);
         equivalenceClass.addVariable(variable);
         return equivalenceClass;
      }

      /**
       * Get the phi equivalence class for a specific variable.
       *
       * @param variable The variable
       * @return The existing phi equivalence class. null if no equivalence class contains the variable.
       */
      private PhiEquivalenceClass getPhiEquivalenceClass(VariableRef variable) {
         for (PhiEquivalenceClass equivalenceClass : equivalenceClasses) {
            if(equivalenceClass.contains(variable)) {
               return equivalenceClass;
            }
         }
         return null;
      }


      public int size() {
         return equivalenceClasses.size();
      }

      public void remove(PhiEquivalenceClass equivalenceClass) {
         equivalenceClasses.remove(equivalenceClass);
      }
   }

   /**
    * A phi equivalence class contains all varialbes connected in by phi statements.
    * In the phi statement <code>va = phi(vb, vc)</code> all 3 variables are in the same equivalence class.
    * The equivalence class is the closure over all phi statements in the program.
    * The set of equivalence classes is a disjoint partition of all variables uses in phi statements
    * (ie. those variables crossing non-trivial block transitions).
    * <p>
    * See http://compilers.cs.ucla.edu/fernando/projects/soc/reports/short_tech.pdf
    **/
   public class PhiEquivalenceClass {

      /** The variables of the equivalence class. */
      List<VariableRef> variables;

      /** The combined live range of the variables. */
      LiveRange classLiveRange;

      public PhiEquivalenceClass() {
         this.variables = new ArrayList<>();
         this.classLiveRange = new LiveRange();
      }

      /**
       * Add a variable to the equivalence class
       * @param variable The variable to add
       */
      public void addVariable(VariableRef variable) {
         VariableLiveRanges liveRanges = getSymbols().getLiveRanges();
         LiveRange varLiveRange = liveRanges.getLiveRange(variable);
         if(classLiveRange.overlaps(varLiveRange)) {
            throw new RuntimeException("Compilation error! Variable live range overlaps phi equivalence class live range. "+variable);
         }
         classLiveRange.add(varLiveRange);
         variables.add(variable);
      }

      /**
       * Determines if the phi equivalence class contains a variable
       * @param variable The variable to look for
       * @return true if the equivalence class contains the variable
       */
      public boolean contains(VariableRef variable) {
         return variables.contains(variable);
      }

      public LiveRange getLiveRange() {
         return classLiveRange;
      }

      public void addAll(PhiEquivalenceClass other) {
         variables.addAll(other.variables);
         classLiveRange.add(other.classLiveRange);
      }

      @Override
      public boolean equals(Object o) {
         if (this == o) return true;
         if (o == null || getClass() != o.getClass()) return false;

         PhiEquivalenceClass that = (PhiEquivalenceClass) o;

         return variables.equals(that.variables);
      }

      @Override
      public int hashCode() {
         return variables.hashCode();
      }
   }

}
