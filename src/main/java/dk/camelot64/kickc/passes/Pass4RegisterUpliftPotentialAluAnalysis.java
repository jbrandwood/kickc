package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

/***
 * Find equivalence classes that could be assigned to the special ALU register.
 *
 * Sets the potential inside the {@link RegisterPotentials} for al variables that has the potential.
 */
public class Pass4RegisterUpliftPotentialAluAnalysis extends Pass2Base {

   private LiveRangeEquivalenceClassSet liveRangeEquivalenceClassSet;

   public Pass4RegisterUpliftPotentialAluAnalysis(Program program) {
      super(program);
   }

   /***
    * Look through all statements identifying statement combinations that are fit for ALU.
    *
    * ALU is usable for v1 in the following sequence - if v1 is alive only in the first statement:<br>
    * v1 = vx *idx vy /   v1 = * vx  <br>
    * zzz = v1 + vz / zzz = vz + v1 / zzz = vz - v1  <br>
    *
    */
   public void findPotentialAlu() {

      RegisterPotentials registerPotentials = getProgram().getRegisterPotentials();
      this.liveRangeEquivalenceClassSet = getProgram().getLiveRangeEquivalenceClassSet();

      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {

         VariableRef potentialAluVar = null;

         for (Statement statement : block.getStatements()) {
            if (potentialAluVar != null) {
               // Previous assignment has ALU potential - check if current statement can use it
               if (statement instanceof StatementAssignment) {
                  StatementAssignment assignment = (StatementAssignment) statement;
                  if (assignment.getOperator()!=null && "-".equals(assignment.getOperator().getOperator())) {
                     // ALU applicable if the variable is the second lValue and the first lValue is non-null
                     if (assignment.getrValue2().equals(potentialAluVar) && assignment.getrValue1() != null) {
                        // The variable has ALU potential
                        setHasAluPotential(registerPotentials, potentialAluVar);
                     }
                  } else if (assignment.getOperator()!=null && (Operator.PLUS.equals(assignment.getOperator()) || Operator.BOOL_OR.equals(assignment.getOperator())|| Operator.WORD.equals(assignment.getOperator()))) {
                     // ALU applicable if the variable is one of the two values
                     if (assignment.getrValue2().equals(potentialAluVar) && assignment.getrValue1() != null) {
                        // The variable has ALU potential
                        setHasAluPotential(registerPotentials, potentialAluVar);
                     }
                     if (assignment.getrValue1().equals(potentialAluVar) && assignment.getrValue2() != null) {
                        // The variable has ALU potential
                        setHasAluPotential(registerPotentials, potentialAluVar);
                     }
                  }
               }
            }
            potentialAluVar = null;
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if (assignment.getOperator()!=null && "*".equals(assignment.getOperator().getOperator()) && assignment.getrValue1() == null) {
                  potentialAluVar = findAluPotential(assignment);
               }
               if (assignment.getOperator()!=null && "*idx".equals(assignment.getOperator().getOperator())) {
                  potentialAluVar = findAluPotential(assignment);
               }
               if (assignment.getOperator()!=null && Operator.LOWBYTE.equals(assignment.getOperator()) && assignment.getrValue1()==null) {
                  potentialAluVar = findAluPotential(assignment);
               }
               if (assignment.getOperator()!=null && Operator.HIBYTE.equals(assignment.getOperator()) && assignment.getrValue1()==null) {
                  potentialAluVar = findAluPotential(assignment);
               }
            }
         }
      }
   }

   private VariableRef findAluPotential(StatementAssignment assignment) {
      VariableRef potentialAluVar = null;
      if (assignment.getlValue() instanceof VariableRef) {
         VariableRef var = (VariableRef) assignment.getlValue();
         LiveRangeEquivalenceClass varEquivalenceClass = liveRangeEquivalenceClassSet.getEquivalenceClass(var);
         if (varEquivalenceClass.getVariables().size() == 1) {
            // Alone in equivalence class
            LiveRange liveRange = varEquivalenceClass.getLiveRange();
            if (liveRange.size() == 1) {
               // Only used in the following statement
               potentialAluVar = var;
            }
         }
      }
      return potentialAluVar;
   }

   private void setHasAluPotential(RegisterPotentials registerPotentials, VariableRef ref) {
      LiveRangeEquivalenceClass potentialAluEquivalenceClass = liveRangeEquivalenceClassSet.getEquivalenceClass(ref);
      registerPotentials.addPotentialRegister(potentialAluEquivalenceClass, Registers.getRegisterALU());
      getLog().append("Equivalence Class "+potentialAluEquivalenceClass+" has ALU potential.");
   }

}
