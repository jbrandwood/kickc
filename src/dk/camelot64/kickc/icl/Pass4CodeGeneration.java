package dk.camelot64.kickc.icl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
            if(defaultSuccessor.getPredecessors().size()>1) {
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
         AsmFragmentSignature asmFragmentSignature = new AsmFragmentSignatureAssignment((StatementAssignment) statement, symbols);
         asm.addAsm("  // " + statement + "  //  "+asmFragmentSignature.getSignature());
         genAsmFragment(asm, asmFragmentSignature);
      } else {
         asm.addAsm("  // TODO: " + statement);
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
               genAsmMove(asm, previousSymbol.getRValue(), phi.getLValue());
               break;
            }
         }
      }
      genAsmJump(asm, block.getLabel().getName());
   }

   /**
    * Generate an assembler move from an Rvalue to an LValue
    *
    * @param asm    The assembler sequence
    * @param rValue The rValue
    * @param lValue The lValue
    */
   private void genAsmMove(AsmSequence asm, RValue rValue, LValue lValue) {
      AsmFragmentSignatureAssignment signature = new AsmFragmentSignatureAssignment(lValue, rValue, symbols);
      asm.addAsm("  // " + rValue + " = " + lValue + "  // "+signature.getSignature());
      genAsmFragment(asm, signature);
   }

   private void genAsmLabel(AsmSequence asm, Label label) {
      genAsmLabel(asm, label.getName());
   }

   private void genAsmLabel(AsmSequence asm, String label) {
      asm.addAsm(label.replace('@', 'B') + ":");
   }

   private void genAsmJump(AsmSequence asm, String label) {
      asm.addAsm("  jmp " + label.replace('B', '_'));
   }

   /**
    * Generate assembler code for an assembler fragment.
    *
    * @param asm               The assembler sequence to generate into.
    * @param fragmentSignature Signature of the code fragment to generate
    */
   private void genAsmFragment(AsmSequence asm, AsmFragmentSignature fragmentSignature) {
      String signature = fragmentSignature.getSignature();
      ClassLoader classLoader = this.getClass().getClassLoader();
      URL fragmentResource = classLoader.getResource("dk/camelot64/kickc/icl/asm/" + signature + ".asm");
      if (fragmentResource == null) {
         System.out.println("Fragment not found " + fragmentResource);
         asm.addAsm("  // Fragment not found: " + signature);
         return;
      }
      Pattern bindPattern = Pattern.compile(".*\\{([^}]*)}.*");
      try {
         InputStream fragmentStream = fragmentResource.openStream();
         BufferedReader fragmentReader = new BufferedReader(new InputStreamReader(fragmentStream));
         String line;
         while ((line = fragmentReader.readLine()) != null) {
            Matcher matcher = bindPattern.matcher(line);
            if(matcher.matches()) {
               String name = matcher.group(1);
               String bound = getFragmentBoundValue(name, fragmentSignature);
               line = line.replaceFirst("\\{[^}]*}", bound);
            }
            asm.addAsm("  " + line);
         }
         fragmentReader.close();
         fragmentStream.close();
      } catch (IOException e) {
         throw new RuntimeException("Error reading code fragment " + fragmentResource);
      }

   }

   /**
    * Get the value to replace a bound name with from the fragment signature
    * @param boundName The name of the bound value in the fragment
    * @param fragmentSignature The fragment signature containing the bindings
    * @return The bound value to use in the generated ASM code
    */
   private String getFragmentBoundValue(String boundName, AsmFragmentSignature fragmentSignature) {
      RValue boundValue = fragmentSignature.getBinding(boundName);
      String bound;
      if(boundValue instanceof Variable) {
         RegisterAllocation.Register register = symbols.getRegister((Variable) boundValue);
         if(register instanceof RegisterAllocation.RegisterZpByte) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpByte) register).getZp());
         }  else if(register instanceof RegisterAllocation.RegisterZpBool) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpBool) register).getZp());
         } else {
            throw new RuntimeException("Register Type not implemented "+register);
         }
      } else if(boundValue instanceof ConstantInteger) {
         ConstantInteger boundInt = (ConstantInteger) boundValue;
         if(boundInt.getType().equals(SymbolType.BYTE)) {
            bound = Integer.toString(boundInt.getNumber());
         } else {
            throw new RuntimeException("Bound Value Type not implemented " + boundValue);
         }
      } else {
         throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
      return bound;
   }


}
