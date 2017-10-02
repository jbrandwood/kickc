package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.asm.parser.AsmClobber;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/*** Ensures that no statement clobbers a CPU register used by an alive variable - and that assigning statements clobber the CPU registers they assign to */
public class Pass4AssertNoCpuClobber extends Pass2Base {

   public Pass4AssertNoCpuClobber(Program program) {
      super(program);
   }

   /**
    * Check that no statement clobbers a CPU register used by an alive variable
    */
   public void check() {
      if (hasClobberProblem(true)) {
         throw new RuntimeException("CLOBBER ERROR! See log for more info.");
      }
   }

   /**
    * Determines whether any statement in the ASM program that clobbers a CPU register used by an alive variable
    *
    * @return true if there is a clobber problem in the program
    */
   public boolean hasClobberProblem(boolean verbose) {
      AsmProgram asm = getProgram().getAsm();
      boolean clobberProblem = false;
      for (AsmSegment asmSegment : asm.getSegments()) {
         if (asmSegment.getStatementIdx() != null) {
            // Find the ICL statement
            int statementIdx = asmSegment.getStatementIdx();
            Statement statement = getGraph().getStatementByIndex(statementIdx);
            // Find the registered clobbered by the ASM asmSegment
            AsmClobber asmSegmentClobber = asmSegment.getClobber();
            Collection<Registers.Register> clobberRegisters = getClobberRegisters(asmSegmentClobber);
            // Find vars assigned to in the statement
            Collection<VariableRef> assignedVars = Pass4RegisterUpliftPotentialRegisterAnalysis.getAssignedVars(statement);
            // Two assigned vars cannot use same register
            if(assignedVars.size()>1) {
               for (VariableRef assignedVar1 : assignedVars) {
                  for (VariableRef assignedVar2 : assignedVars) {
                     if (assignedVar1.equals(assignedVar2)) {
                        // Same variable - not relevant
                        continue;
                     }
                     Registers.Register register1 = getProgram().getScope().getVariable(assignedVar1).getAllocation();
                     Registers.Register register2 = getProgram().getScope().getVariable(assignedVar2).getAllocation();
                     if (register1.equals(register2)) {
                        if (verbose) {
                           getLog().append("Two assigned variables " + assignedVar1 + " and " + assignedVar2 + " clobbered by use of same register " + register1 + " in statement " + statement);
                        }
                        clobberProblem = true;
                     }
                  }
               }
            }

            // Find alive variables
            List<VariableRef> aliveVars = new ArrayList<>(getProgram().getLiveRangeVariables().getAliveEffective(statement));
            // Non-assigned alive variables must not be clobbered
            for (VariableRef aliveVar : aliveVars) {
               Variable variable = getProgram().getScope().getVariable(aliveVar);
               Registers.Register aliveVarRegister = variable.getAllocation();
               if (aliveVarRegister.isZp()) {
                  // No need to check a zp-register - here we are only interested in CPU registers
                  continue;
               }
               if (assignedVars.contains(aliveVar)) {
                  // No need to register that is assigned by the statement - it will be clobbered
                  continue;
               }
               // Alive and not assigned to - clobber not allowed!
               if (clobberRegisters.contains(aliveVarRegister)) {
                  if (verbose) {
                     getLog().append("Error! Alive variable " + aliveVar + " register " + aliveVarRegister + " clobbered by the ASM generated by statement " + statement);
                  }
                  clobberProblem = true;
               }
            }
         }
      }
      if(verbose && clobberProblem) {
         getLog().append(asm.toString(true));
      }
      return clobberProblem;
   }

   /**
    * Get all CPU registers clobbered by the ASM generated from a specific statement in the program
    *
    * @param clobber The clobber
    * @return The clobbered CPU registers
    */
   public static Collection<Registers.Register> getClobberRegisters(AsmClobber clobber) {
      List<Registers.Register> clobberRegisters = new ArrayList<>();
      if (clobber.isClobberA()) {
         clobberRegisters.add(Registers.getRegisterA());
      }
      if (clobber.isClobberX()) {
         clobberRegisters.add(Registers.getRegisterX());
      }
      if (clobber.isClobberY()) {
         clobberRegisters.add(Registers.getRegisterY());
      }
      return clobberRegisters;
   }

}
