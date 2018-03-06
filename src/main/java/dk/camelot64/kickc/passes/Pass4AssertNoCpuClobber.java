package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.AsmSegment;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.Variable;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/*** Ensures that no statement clobbers a CPU register used by an alive variable - and that assigning statements clobber the CPU registers they assign to */
public class Pass4AssertNoCpuClobber extends Pass2Base {

   public Pass4AssertNoCpuClobber(Program program) {
      super(program);
   }

   /**
    * Get all CPU registers clobbered by the ASM generated from a specific statement in the program
    *
    * @param clobber The clobber
    * @return The clobbered CPU registers
    */
   public static Collection<Registers.Register> getClobberRegisters(AsmClobber clobber) {
      List<Registers.Register> clobberRegisters = new ArrayList<>();
      if(clobber.isClobberA()) {
         clobberRegisters.add(Registers.getRegisterA());
      }
      if(clobber.isClobberX()) {
         clobberRegisters.add(Registers.getRegisterX());
      }
      if(clobber.isClobberY()) {
         clobberRegisters.add(Registers.getRegisterY());
      }
      return clobberRegisters;
   }

   /**
    * Check that no statement clobbers a CPU register used by an alive variable
    */
   public void check() {
      if(hasClobberProblem(true)) {
         throw new CompileError("CLOBBER ERROR! See log for more info.");
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
      for(AsmSegment asmSegment : asm.getSegments()) {
         if(asmSegment.getStatementIdx() != null) {
            // Find the ICL statement
            int statementIdx = asmSegment.getStatementIdx();
            Statement statement = getProgram().getStatementInfos().getStatement(statementIdx);
            // Find the registered clobbered by the ASM asmSegment
            AsmClobber asmSegmentClobber = asmSegment.getClobber();
            Collection<Registers.Register> clobberRegisters = getClobberRegisters(asmSegmentClobber);
            // Find vars assigned to in the statement
            Collection<VariableRef> assignedVars = Pass4RegisterUpliftPotentialRegisterAnalysis.getAssignedVars(statement);

            // Find alive variables
            List<VariableRef> aliveVars = new ArrayList<>(getProgram().getLiveRangeVariablesEffective().getAliveEffective(statement));

            // If the segment is an assignment in a phi transition, examine the later phi transition assignments and update alive variables alive and variables assigned
            if(asmSegment.getPhiTransitionId() != null && asmSegment.getPhiTransitionAssignmentIdx() != null) {
               String phiTransitionId = asmSegment.getPhiTransitionId();
               int transitionAssignmentIdx = asmSegment.getPhiTransitionAssignmentIdx();
               ControlFlowBlock statementBlock = getProgram().getStatementInfos().getBlock(statementIdx);
               PhiTransitions phiTransitions = new PhiTransitions(getProgram(), statementBlock);
               PhiTransitions.PhiTransition phiTransition = phiTransitions.getTransition(phiTransitionId);
               for(PhiTransitions.PhiTransition.PhiAssignment phiAssignment : phiTransition.getAssignments()) {
                  // IF the assignment is later than the current one
                  if(phiAssignment.getAssignmentIdx() > transitionAssignmentIdx) {
                     RValue rValue = phiAssignment.getrValue();
                     Collection<VariableRef> alive = VariableReferenceInfos.getReferencedVars(rValue);
                     aliveVars.addAll(alive);
                     VariableRef assignedVar = phiAssignment.getVariable();
                     assignedVars.remove(assignedVar);
                     alive.remove(assignedVar);
                  }
               }
            }

            // Non-assigned alive variables must not be clobbered
            for(VariableRef aliveVar : aliveVars) {
               Variable variable = getProgram().getSymbolInfos().getVariable(aliveVar);
               Registers.Register aliveVarRegister = variable.getAllocation();
               if(aliveVarRegister.isZp()) {
                  // No need to check a zp-register - here we are only interested in CPU registers
                  continue;
               }
               if(assignedVars.contains(aliveVar)) {
                  // No need to register that is assigned by the statement - it will be clobbered
                  continue;
               }
               // Alive and not assigned to - clobber not allowed!
               if(clobberRegisters.contains(aliveVarRegister)) {
                  if(verbose) {
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

}
