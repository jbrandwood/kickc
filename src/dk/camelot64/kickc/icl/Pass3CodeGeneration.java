package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.asm.*;

import java.util.Iterator;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass3CodeGeneration {

   private ControlFlowGraph graph;
   private SymbolTable symbols;

   public Pass3CodeGeneration(ControlFlowGraph graph, SymbolTable symbols) {
      this.graph = graph;
      this.symbols = symbols;
   }

   public AsmProgram generate() {
      AsmProgram asm = new AsmProgram();
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         // Generate label
         asm.addLabel(block.getLabel().getLocalName().replace('@', 'B'));
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = block.getDefaultSuccessor();
         if (defaultSuccessor != null) {
            if (defaultSuccessor.hasPhiStatements()) {
               genBlockPhiTransition(asm, block, defaultSuccessor);
            }
            asm.addInstruction("JMP", AsmAddressingMode.ABS, defaultSuccessor.getLabel().getLocalName().replace('@', 'B'));
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
               LValue lValue = assignment.getLValue();
               boolean isAlu = false;
               if (lValue instanceof Variable) {
                  RegisterAllocation.Register lValRegister = symbols.getRegister((Variable) lValue);
                  if (lValRegister.getType().equals(RegisterAllocation.RegisterType.REG_ALU_BYTE)) {
                     asm.addComment(statement + "  //  ALU");
                     StatementAssignment assignmentAlu = assignment;
                     statement = statementsIt.next();
                     if (!(statement instanceof StatementAssignment)) {
                        throw new RuntimeException("Error! ALU statement must be followed immidiately by assignment using the ALU. " + statement);
                     }
                     assignment = (StatementAssignment) statement;
                     AsmFragment asmFragment = new AsmFragment(assignment, assignmentAlu, symbols);
                     asm.addComment(statement + "  //  " + asmFragment.getSignature());
                     asmFragment.generate(asm);
                     isAlu = true;
                  }
               }
               if (!isAlu) {
                  AsmFragment asmFragment = new AsmFragment(assignment, symbols);
                  asm.addComment(statement + "  //  " + asmFragment.getSignature());
                  asmFragment.generate(asm);
               }
            } else if (statement instanceof StatementConditionalJump) {
               AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, block, symbols, graph);
               asm.addComment(statement + "  //  " + asmFragment.getSignature());
               asmFragment.generate(asm);
            } else {
               throw new RuntimeException("Statement not supported " + statement);
            }
         }
      }
   }

   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock block) {
      if (block.hasPhiStatements()) {
         for (ControlFlowBlock predecessor : block.getPredecessors()) {
            if (block.equals(predecessor.getConditionalSuccessor())) {
               genBlockPhiTransition(asm, predecessor, block);
               asm.addInstruction("JMP", AsmAddressingMode.ABS, block.getLabel().getLocalName().replace('@', 'B'));
            }
         }
      }
   }

   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock) {
      asm.addLabel((toBlock.getLabel().getLocalName() + "_from_" + fromBlock.getLabel().getLocalName()).replace('@', 'B'));
      for (Statement statement : toBlock.getStatements()) {
         if (!(statement instanceof StatementPhi)) {
            // No more phi statements to handle
            break;
         }
         StatementPhi phi = (StatementPhi) statement;
         for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
            if (previousSymbol.getBlock().equals(fromBlock)) {
               genAsmMove(asm, phi.getLValue(), previousSymbol.getRValue());
               break;
            }
         }
      }
   }

   private RegisterAllocation.Register getRegister(RValue rValue) {
      if (rValue instanceof Variable) {
         return symbols.getRegister((Variable) rValue);
      } else {
         return null;
      }
   }

   private void genAsmMove(AsmProgram asm, LValue lValue, RValue rValue) {
      if (getRegister(lValue).equals(getRegister(rValue))) {
         // Do not move from register to itself
         asm.addComment(lValue + " = " + rValue + "  // register copy ");
         return;
      }
      AsmFragment asmFragment = new AsmFragment(lValue, rValue, symbols);
      asm.addComment(lValue + " = " + rValue + "  // " + asmFragment.getSignature());
      asmFragment.generate(asm);
   }


}
