package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass4CodeGeneration {

   private ControlFlowGraph graph;
   private ProgramScope symbols;

   public Pass4CodeGeneration(Program program) {
      this.graph = program.getGraph();
      this.symbols = program.getScope();
   }

   public AsmProgram generate() {
      AsmProgram asm = new AsmProgram();
      for (LabelRef blockRef : graph.getSequence()) {
         ControlFlowBlock block = graph.getBlock(blockRef);
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         // Generate label
         asm.addLabel(block.getLabel().getFullName().replace('@', 'B').replace(':','_'));
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = graph.getDefaultSuccessor(block);
         if (defaultSuccessor != null) {
            if (defaultSuccessor.hasPhiBlock()) {
               genBlockPhiTransition(asm, block, defaultSuccessor);
            }
            asm.addInstruction("JMP", AsmAddressingMode.ABS, defaultSuccessor.getLabel().getFullName().replace('@', 'B').replace(':','_'));
         }
      }
      return asm;
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      Iterator<Statement> statementsIt = block.getStatements().iterator();
      while (statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         if (!(statement instanceof StatementPhiBlock)) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               boolean isAlu = false;
               if (lValue instanceof VariableRef) {
                  VariableRef lValueRef = (VariableRef) lValue;
                  Variable lValueVar = symbols.getVariable(lValueRef);
                  RegisterAllocation.Register lValRegister = symbols.getRegister(lValueVar);
                  if (lValRegister.getType().equals(RegisterAllocation.RegisterType.REG_ALU_BYTE)) {
                     asm.addComment(statement + "  //  ALU");
                     StatementAssignment assignmentAlu = assignment;
                     statement = statementsIt.next();
                     if (!(statement instanceof StatementAssignment)) {
                        throw new RuntimeException("Error! ALU statement must be followed immediately by assignment using the ALU. " + statement);
                     }
                     assignment = (StatementAssignment) statement;
                     AsmFragment asmFragment = new AsmFragment(assignment, assignmentAlu, symbols);
                     asm.addComment(statement.toString(symbols) + "  //  " + asmFragment.getSignature());
                     asmFragment.generate(asm);
                     isAlu = true;
                  }
               }
               if (!isAlu) {
                  AsmFragment asmFragment = new AsmFragment(assignment, symbols);
                  asm.addComment(statement.toString(symbols) + "  //  " + asmFragment.getSignature());
                  asmFragment.generate(asm);
               }
            } else if (statement instanceof StatementConditionalJump) {
               AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, block, symbols, graph);
               asm.addComment(statement.toString(symbols) + "  //  " + asmFragment.getSignature());
               asmFragment.generate(asm);
            } else if (statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ControlFlowBlock callSuccessor = graph.getCallSuccessor(block);
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
   }

   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock block) {
      if (block.hasPhiBlock()) {
         List<ControlFlowBlock> predecessors = new ArrayList<>(graph.getPredecessors(block));
         Collections.sort(predecessors, new Comparator<ControlFlowBlock>() {
            @Override
            public int compare(ControlFlowBlock o1, ControlFlowBlock o2) {
               return o1.getLabel().getFullName().compareTo(o2.getLabel().getFullName());
            }
         });
         for (ControlFlowBlock predecessor : predecessors) {
            if (block.getLabel().equals(predecessor.getConditionalSuccessor())) {
               genBlockPhiTransition(asm, predecessor, block);
               asm.addInstruction("JMP", AsmAddressingMode.ABS, block.getLabel().getFullName().replace('@', 'B').replace(':','_'));
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
         Variable rValueVar = symbols.getVariable(rValueRef);
         return symbols.getRegister(rValueVar);
      } else {
         return null;
      }
   }

   private void genAsmMove(AsmProgram asm, LValue lValue, RValue rValue) {
      if (getRegister(lValue).equals(getRegister(rValue))) {
         // Do not move from register to itself
         asm.addComment(lValue.toString(symbols) + " = " + rValue.toString(symbols) + "  // register copy ");
         return;
      }
      AsmFragment asmFragment = new AsmFragment(lValue, rValue, symbols);
      asm.addComment(lValue.toString(symbols) + " = " + rValue.toString(symbols) + "  // " + asmFragment.getSignature());
      asmFragment.generate(asm);
   }


}
