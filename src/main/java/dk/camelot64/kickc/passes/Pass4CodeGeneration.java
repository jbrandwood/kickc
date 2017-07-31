package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass4CodeGeneration {


   private Program program;

   public Pass4CodeGeneration(Program program) {
      this.program = program;
   }

   ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   ProgramScope getScope() {
      return program.getScope();
   }

   public void generate() {
      AsmProgram asm = new AsmProgram();
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         // Generate label
         asm.addLabel(block.getLabel().getFullName().replace('@', 'B').replace(':', '_'));
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if (defaultSuccessor != null) {
            if (defaultSuccessor.hasPhiBlock()) {
               genBlockPhiTransition(asm, block, defaultSuccessor);
            }
            asm.addInstruction("JMP", AsmAddressingMode.ABS, defaultSuccessor.getLabel().getFullName().replace('@', 'B').replace(':', '_'));
         }
      }
      program.setAsm(asm);
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      Iterator<Statement> statementsIt = block.getStatements().iterator();
      AsmCodegenAluState aluState = new AsmCodegenAluState();
      while (statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         generateStatementAsm(asm, block, statement, aluState);
      }
   }

   /**
    * Generate ASM code for a single statement
    *
    * @param asm       The ASM program to generate into
    * @param block     The block containing the statement
    * @param statement The statement to generate ASM code for
    * @param aluState  State of the special ALU register. Used to generate composite fragments when two consecutive statements can be executed effectively.
    *                  For example ADC $1100,x combines two statements $0 = $1100 staridx X, A = A+$0 .
    */
   public void generateStatementAsm(AsmProgram asm, ControlFlowBlock block, Statement statement, AsmCodegenAluState aluState) {

      // IF the previous statement was added to the ALU register - generate the composite ASM fragment
      if (aluState.hasAluAssignment()) {
         StatementAssignment assignmentAlu = aluState.getAluAssignment();
         if (!(statement instanceof StatementAssignment)) {
            throw new RuntimeException("Error! ALU statement must be followed immediately by assignment using the ALU. " + statement);
         }
         StatementAssignment assignment = (StatementAssignment) statement;
         AsmFragment asmFragment = new AsmFragment(assignment, assignmentAlu, program);
         asm.addComment(statement.toString(program) + "  //  " + asmFragment.getSignature());
         asmFragment.generate(asm);
         aluState.clear();
         return;
      }

      if (!(statement instanceof StatementPhiBlock)) {
         if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            boolean isAlu = false;
            if (lValue instanceof VariableRef) {
               VariableRef lValueRef = (VariableRef) lValue;
               Variable lValueVar = getScope().getVariable(lValueRef);
               RegisterAllocation.Register lValRegister = program.getRegister(lValueVar);
               if (lValRegister.getType().equals(RegisterAllocation.RegisterType.REG_ALU_BYTE)) {
                  asm.addComment(statement + "  //  ALU");
                  StatementAssignment assignmentAlu = assignment;
                  aluState.setAluAssignment(assignmentAlu);
                  isAlu = true;
               }
            }
            if (!isAlu) {
               if (assignment.getOperator() == null && assignment.getrValue1() == null && isRegisterCopy(lValue, assignment.getrValue2())) {
                  asm.addComment(lValue.toString(program) + " = " + assignment.getrValue2().toString(program) + "  // register copy " + getRegister(lValue));
               } else {
                  AsmFragment asmFragment = new AsmFragment(assignment, program);
                  asm.addComment(statement.toString(program) + "  //  " + asmFragment.getSignature());
                  asmFragment.generate(asm);
               }
            }
         } else if (statement instanceof StatementConditionalJump) {
            AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, block, program, getGraph());
            asm.addComment(statement.toString(program) + "  //  " + asmFragment.getSignature());
            asmFragment.generate(asm);
         } else if (statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            ControlFlowBlock callSuccessor = getGraph().getCallSuccessor(block);
            if (callSuccessor != null && callSuccessor.hasPhiBlock()) {
               genBlockPhiTransition(asm, block, callSuccessor);
            }
            asm.addInstruction("jsr", AsmAddressingMode.ABS, call.getProcedure().getFullName());
         } else if (statement instanceof StatementReturn) {
            asm.addInstruction("rts", AsmAddressingMode.NON, null);
         } else {
            throw new RuntimeException("Statement not supported " + statement);
         }
      }
   }


   /**
    * Contains previous assignment added to the ALU register between calls to generateStatementAsm
    */
   public static class AsmCodegenAluState {

      private StatementAssignment aluAssignment;

      public void setAluAssignment(StatementAssignment aluAssignment) {
         this.aluAssignment = aluAssignment;
      }

      public StatementAssignment getAluAssignment() {
         return aluAssignment;
      }

      public boolean hasAluAssignment() {
         return aluAssignment != null;
      }

      public void clear() {
         aluAssignment = null;
      }
   }


   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock block) {
      if (block.hasPhiBlock()) {
         List<ControlFlowBlock> predecessors = new ArrayList<>(getGraph().getPredecessors(block));
         Collections.sort(predecessors, new Comparator<ControlFlowBlock>() {
            @Override
            public int compare(ControlFlowBlock o1, ControlFlowBlock o2) {
               return o1.getLabel().getFullName().compareTo(o2.getLabel().getFullName());
            }
         });
         for (ControlFlowBlock predecessor : predecessors) {
            if (block.getLabel().equals(predecessor.getConditionalSuccessor())) {
               genBlockPhiTransition(asm, predecessor, block);
               asm.addInstruction("JMP", AsmAddressingMode.ABS, block.getLabel().getFullName().replace('@', 'B').replace(':', '_'));
            }
         }
      }
   }

   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock) {
      asm.addLabel((toBlock.getLabel().getFullName() + "_from_" + fromBlock.getLabel().getLocalName()).replace('@', 'B').replace(':', '_'));
      if (toBlock.hasPhiBlock()) {
         StatementPhiBlock phiBlock = toBlock.getPhiBlock();
         List<StatementPhiBlock.PhiVariable> phiVariables = new ArrayList<>(phiBlock.getPhiVariables());
         Collections.reverse(phiVariables);
         for (StatementPhiBlock.PhiVariable phiVariable : phiVariables) {
            List<StatementPhiBlock.PhiRValue> phiRValues = phiVariable.getValues();
            Collections.sort(phiRValues, new Comparator<StatementPhiBlock.PhiRValue>() {
               @Override
               public int compare(StatementPhiBlock.PhiRValue o1, StatementPhiBlock.PhiRValue o2) {
                  return o1.getPredecessor().getFullName().compareTo(o2.getPredecessor().getFullName());
               }
            });
            for (StatementPhiBlock.PhiRValue phiRValue : phiRValues) {
               if (phiRValue.getPredecessor().equals(fromBlock.getLabel())) {
                  genAsmMove(asm, phiVariable.getVariable(), phiRValue.getrValue());
                  break;
               }
            }
         }
      }
   }

   private RegisterAllocation.Register getRegister(RValue rValue) {
      if (rValue instanceof VariableRef) {
         VariableRef rValueRef = (VariableRef) rValue;
         Variable rValueVar = getScope().getVariable(rValueRef);
         return program.getRegister(rValueVar);
      } else {
         return null;
      }
   }

   private void genAsmMove(AsmProgram asm, LValue lValue, RValue rValue) {
      if (isRegisterCopy(lValue, rValue)) {
         asm.addComment(lValue.toString(program) + " = " + rValue.toString(program) + "  // register copy " + getRegister(lValue));
      } else {
         AsmFragment asmFragment = new AsmFragment(lValue, rValue, program);
         asm.addComment(lValue.toString(program) + " = " + rValue.toString(program) + "  // " + asmFragment.getSignature());
         asmFragment.generate(asm);
      }
   }

   private boolean isRegisterCopy(LValue lValue, RValue rValue) {
      return
            getRegister(lValue) != null &&
                  getRegister(rValue) != null &&
                  getRegister(lValue).equals(getRegister(rValue));
   }


}
