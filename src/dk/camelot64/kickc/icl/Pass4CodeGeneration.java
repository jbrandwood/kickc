package dk.camelot64.kickc.icl;

import java.util.List;

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

   public AsmSequence generate() {
      AsmSequence asm = new AsmSequence();
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         // Generate label
         genAsmLabel(asm, block.getLabel());
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = block.getDefaultSuccessor();
         if (defaultSuccessor != null) {
            if (defaultSuccessor.getPredecessors().size() > 1) {
               String label = defaultSuccessor.getLabel().getName() + "_from_" + block.getLabel().getName();
               genAsmJump(asm, label);
            } else {
               genAsmJump(asm, defaultSuccessor.getLabel().getName());
            }
         }
      }
      return asm;
   }

   private void genStatements(AsmSequence asm, ControlFlowBlock block) {
      for (Statement statement : block.getStatements()) {
         if (!(statement instanceof StatementPhi)) {
            genStatement(asm, statement);
         }
      }
   }

   private void genStatement(AsmSequence asm, Statement statement) {
      if (statement instanceof StatementAssignment) {
         AsmFragment asmFragment = new AsmFragment((StatementAssignment) statement, symbols);
         asm.addAsm("  // " + statement + "  //  " + asmFragment.getSignature());
         asmFragment.generateAsm(asm);
      } else if (statement instanceof StatementConditionalJump) {
         AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, symbols);
         asm.addAsm("  // " + statement + "  //  " + asmFragment.getSignature());
         asmFragment.generateAsm(asm);
      } else {
         throw new RuntimeException("Statement not supported "+statement);
      }
   }

   private void genBlockEntryPoints(AsmSequence asm, ControlFlowBlock block) {
      List<Statement> statements = block.getStatements();
      if (statements.size() > 0 && (statements.get(0) instanceof StatementPhi)) {
         for (ControlFlowBlock predecessor : block.getPredecessors()) {
            genBlockEntryPoint(asm, block, predecessor);
         }
      }
   }

   private void genBlockEntryPoint(AsmSequence asm, ControlFlowBlock block, ControlFlowBlock predecessor) {
      genAsmLabel(asm, block.getLabel().getName() + "_from_" + predecessor.getLabel().getName());
      for (Statement statement : block.getStatements()) {
         if (!(statement instanceof StatementPhi)) {
            // No more phi statements to handle
            break;
         }
         StatementPhi phi = (StatementPhi) statement;
         for (StatementPhi.PreviousSymbol previousSymbol : phi.getPreviousVersions()) {
            if (previousSymbol.getBlock().equals(predecessor)) {
               genAsmMove(asm, phi.getLValue(), previousSymbol.getRValue());
               break;
            }
         }
      }
      genAsmJump(asm, block.getLabel().getName());
   }

   private void genAsmMove(AsmSequence asm, LValue lValue, RValue rValue) {
      AsmFragment asmFragment = new AsmFragment(lValue, rValue, symbols);
      asm.addAsm("  // " + lValue + " = " + rValue + "  // " + asmFragment.getSignature());
      asmFragment.generateAsm(asm);
   }

   private void genAsmLabel(AsmSequence asm, Label label) {
      genAsmLabel(asm, label.getName());
   }

   private void genAsmLabel(AsmSequence asm, String label) {
      asm.addAsm(label.replace('@', 'B') + ":");
   }

   private void genAsmJump(AsmSequence asm, String label) {
      asm.addAsm("  jmp " + label.replace('@', 'B'));
   }


}
