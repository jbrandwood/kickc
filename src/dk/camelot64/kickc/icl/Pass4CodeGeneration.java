package dk.camelot64.kickc.icl;

import dk.camelot64.kickc.asm.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass4CodeGeneration {

   private ControlFlowGraph graph;
   private SymbolTable symbols;

   public Pass4CodeGeneration(ControlFlowGraph graph, SymbolTable symbols) {
      this.graph = graph;
      this.symbols = symbols;
   }

   public AsmProgram generate() {
      AsmProgram asm = new AsmProgram();
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         // Generate label
         asm.addLabel(block.getLabel().getName().replace('@', 'B'));
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = block.getDefaultSuccessor();
         if (defaultSuccessor != null) {
            if(defaultSuccessor.hasPhiStatements()) {
               genBlockPhiTransition(asm, block, defaultSuccessor);
            }
            asm.addInstruction("JMP", AsmAddressingMode.ABS, defaultSuccessor.getLabel().getName().replace('@', 'B'));
         }
      }
      return asm;
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      for (Statement statement : block.getStatements()) {
         if (!(statement instanceof StatementPhi)) {
            genStatement(asm, statement, block);
         }
      }
   }

   private void genStatement(AsmProgram asm, Statement statement, ControlFlowBlock block) {
      if (statement instanceof StatementAssignment) {
         AsmFragment asmFragment = new AsmFragment((StatementAssignment) statement, symbols);
         asm.addComment(statement + "  //  " + asmFragment.getSignature());
         asmFragment.generate(asm);
      } else if (statement instanceof StatementConditionalJump) {
         AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, symbols, graph, block);
         asm.addComment(statement + "  //  " + asmFragment.getSignature());
         asmFragment.generate(asm);
      } else {
         throw new RuntimeException("Statement not supported "+statement);
      }
   }

   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock block) {
      if(block.hasPhiStatements()) {
         for (ControlFlowBlock predecessor : block.getPredecessors()) {
            if(block.equals(predecessor.getConditionalSuccessor())) {
               genBlockPhiTransition(asm, predecessor, block);
               asm.addInstruction("JMP", AsmAddressingMode.ABS, block.getLabel().getName().replace('@', 'B'));
            }
         }
      }
   }

   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock) {
      asm.addLabel((toBlock.getLabel().getName() + "_from_" + fromBlock.getLabel().getName()).replace('@', 'B'));
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
      if(rValue instanceof Variable) {
         return symbols.getRegister((Variable) rValue);
      } else {
         return null;
      }
   }

   private void genAsmMove(AsmProgram asm, LValue lValue, RValue rValue) {
      if(getRegister(lValue).equals(getRegister(rValue))) {
         // Do not move from register to itself
         asm.addComment(lValue + " = " + rValue + "  // register copy "  );
         return;
      }
      AsmFragment asmFragment = new AsmFragment(lValue, rValue, symbols);
      asm.addComment(lValue + " = " + rValue + "  // " + asmFragment.getSignature());
      asmFragment.generate(asm);
   }


}
