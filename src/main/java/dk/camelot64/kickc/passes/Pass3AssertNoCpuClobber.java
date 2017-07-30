package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.asm.parser.AsmClobber;
import dk.camelot64.kickc.icl.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/*** Ensures that no statement clobbers a CPU register used by an alive variable - and that assigning statements clobber the CPU registers they assign to */
public class Pass3AssertNoCpuClobber {

   private Program program;
   private CompileLog log;

   public Pass3AssertNoCpuClobber(Program program, CompileLog log) {
      this.program = program;
      this.log = log;
   }

   public Program getProgram() {
      return program;
   }

   public CompileLog getLog() {
      return log;
   }

   /** Check that no statement clobbers a CPU register used by an alive variable */
   public void check() {
      LiveRangeVariables liveRangeVariables = program.getScope().getLiveRangeVariables();
      RegisterAllocation allocation = program.getScope().getAllocation();

      boolean error = false;

      for (ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {

            // Generate ASM and find clobber
            Collection<RegisterAllocation.Register> clobberRegisters = getClobberedRegisters(statement, block);

            // Find alive variables
            List<VariableRef> aliveVars = new ArrayList<>(liveRangeVariables.getAlive(statement));

            // Find vars assignedVars to
            Collection<VariableRef> assignedVars = getAssignedVars(statement);

            for (VariableRef aliveVar : aliveVars) {
               RegisterAllocation.Register aliveVarRegister = allocation.getRegister(aliveVar);
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
                  log.append("Error! Alive variable "+aliveVar+" register "+aliveVarRegister+" clobbered by the ASM generated by statement "+statement);
                  log.append(getAsmProgram(statement, block).toString(false));
                  error = true;
               }
            }
         }
      }

      if(error) {
         throw new RuntimeException("CLOBBER ERROR! See log for more info.");
      }

   }


   /**
    * Get the variables assigned to by a specific statement
    *
    * @param statement The statement
    * @return The variables assigned by the statement
    */
   private Collection<VariableRef> getAssignedVars(Statement statement) {
      List<VariableRef> assignedVars = new ArrayList<>();
      if(statement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) statement;
         if(assignment.getlValue() instanceof VariableRef) {
            assignedVars.add((VariableRef) assignment.getlValue());
         }
      } else if(statement instanceof StatementPhiBlock) {
         StatementPhiBlock phi = (StatementPhiBlock) statement;
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            assignedVars.add(phiVariable.getVariable());
         }
      }
      return assignedVars;
   }

   /**
    * Get all CPU registers clobbered by the ASM generated from a specific statement in the program
    *
    * @param statement The statement
    * @param block The block containing the statement
    * @return The clobbered CPU registers
    */
   private Collection<RegisterAllocation.Register> getClobberedRegisters(Statement statement, ControlFlowBlock block) {
      AsmProgram asm = getAsmProgram(statement, block);
      AsmClobber clobber = asm.getClobber();
      List<RegisterAllocation.Register> clobberRegisters = new ArrayList<>();
      if(clobber.isClobberA()) {
         clobberRegisters.add(RegisterAllocation.getRegisterA());
      }
      if(clobber.isClobberX()) {
         clobberRegisters.add(RegisterAllocation.getRegisterX());
      }
      if(clobber.isClobberY()) {
         clobberRegisters.add(RegisterAllocation.getRegisterY());
      }
      return clobberRegisters;
   }

   /**
    * Get the ASM program generated by a specific statement in the program
    *
    * @param statement The statement
    * @param block The block containing the statement
    * @return The ASM code
    */
   private AsmProgram getAsmProgram(Statement statement, ControlFlowBlock block) {
      Pass4CodeGeneration codegen = new Pass4CodeGeneration(program);
      AsmProgram asm = new AsmProgram();
      codegen.generateStatementAsm(asm, block, statement, new Pass4CodeGeneration.AsmCodegenAluState());
      return asm;
   }


}
