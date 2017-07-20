package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.icl.*;

import java.util.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass3CodeGeneration {

   private ControlFlowGraph graph;
   private ProgramScope symbols;

   public Pass3CodeGeneration(Program program) {
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
            if (defaultSuccessor.hasPhiStatements()) {
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
         if (!(statement instanceof StatementPhi)) {
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
                        throw new RuntimeException("Error! ALU statement must be followed immidiately by assignment using the ALU. " + statement);
                     }
                     assignment = (StatementAssignment) statement;
                     AsmFragment asmFragment = new AsmFragment(assignment, assignmentAlu, symbols);
                     asm.addComment(statement.getAsTypedString(symbols) + "  //  " + asmFragment.getSignature());
                     asmFragment.generate(asm);
                     isAlu = true;
                  }
               }
               if (!isAlu) {
                  AsmFragment asmFragment = new AsmFragment(assignment, symbols);
                  asm.addComment(statement.getAsTypedString(symbols) + "  //  " + asmFragment.getSignature());
                  asmFragment.generate(asm);
               }
            } else if (statement instanceof StatementConditionalJump) {
               AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, block, symbols, graph);
               asm.addComment(statement.getAsTypedString(symbols) + "  //  " + asmFragment.getSignature());
               asmFragment.generate(asm);
            } else if (statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ControlFlowBlock callSuccessor = graph.getCallSuccessor(block);
               if (callSuccessor != null && callSuccessor.hasPhiStatements()) {
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
      if (block.hasPhiStatements()) {
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
      asm.addLabel((toBlock.getLabel().getFullName() + "_from_" + fromBlock.getLabel().getLocalName()).replace('@', 'B').replace(':','_'));
      for (Statement statement : toBlock.getStatements()) {
         if (!(statement instanceof StatementPhi)) {
            // No more phi statements to handle
            break;
         }
         StatementPhi phi = (StatementPhi) statement;
         List<StatementPhi.PreviousSymbol> previousVersions = new ArrayList<>(phi.getPreviousVersions());
         Collections.sort(previousVersions, new Comparator<StatementPhi.PreviousSymbol>() {
            @Override
            public int compare(StatementPhi.PreviousSymbol o1, StatementPhi.PreviousSymbol o2) {
               return o1.getBlock().getFullName().compareTo(o2.getBlock().getFullName());
            }
         });
         for (StatementPhi.PreviousSymbol previousSymbol : previousVersions) {
            if (previousSymbol.getBlock().equals(fromBlock.getLabel())) {
               genAsmMove(asm, phi.getlValue(), previousSymbol.getrValue());
               break;
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
         asm.addComment(lValue.getAsTypedString(symbols) + " = " + rValue.getAsTypedString(symbols) + "  // register copy ");
         return;
      }
      AsmFragment asmFragment = new AsmFragment(lValue, rValue, symbols);
      asm.addComment(lValue.getAsTypedString(symbols) + " = " + rValue.getAsTypedString(symbols) + "  // " + asmFragment.getSignature());
      asmFragment.generate(asm);
   }


}
