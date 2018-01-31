package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.fragment.*;
import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass4CodeGeneration {

   /** Should the generated ASM contain verbose alive info for the statements (costs a bit more to generate). */
   boolean verboseAliveInfo;
   private Program program;
   /**
    * Keeps track of the phi transitions into blocks during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    * Maps to-blocks to the transition information for the block
    */
   private Map<ControlFlowBlock, PhiTransitions> blockTransitions = new LinkedHashMap<>();

   public Pass4CodeGeneration(Program program, boolean verboseAliveInfo) {
      this.program = program;
      this.verboseAliveInfo = verboseAliveInfo;
   }

   ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   ProgramScope getScope() {
      return program.getScope();
   }

   public void generate() {
      AsmProgram asm = new AsmProgram();
      ScopeRef currentScope = ScopeRef.ROOT;

      asm.startSegment(null, "Basic Upstart");
      asm.addLine(new AsmSetPc("Basic", 0x0801));
      asm.addLine(new AsmBasicUpstart("main"));
      asm.addLine(new AsmSetPc("Program", 0x080d));

      // Generate global ZP labels
      asm.startSegment(null, "Global Constants & labels");
      addConstants(asm, currentScope);
      addZpLabels(asm, currentScope);
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(!block.getScope().equals(currentScope)) {
            if(!ScopeRef.ROOT.equals(currentScope)) {
               addData(asm, currentScope);
               asm.addScopeEnd();
            }
            currentScope = block.getScope();
            asm.startSegment(null, block.getLabel().getFullName());
            asm.addScopeBegin(block.getLabel().getFullName().replace('@', 'b').replace(':', '_'));
            // Add all ZP labels for the scope
            addConstants(asm, currentScope);
            addZpLabels(asm, currentScope);
         }
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         if(!block.isProcedureEntry(program)) {
            // Generate label
            asm.startSegment(null, block.getLabel().getFullName());
            asm.addLabel(block.getLabel().getLocalName().replace('@', 'b').replace(':', '_'));
         }
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if(defaultSuccessor != null) {
            if(defaultSuccessor.hasPhiBlock()) {
               PhiTransitions.PhiTransition transition = getTransitions(defaultSuccessor).getTransition(block);
               if(!transition.isGenerated()) {
                  genBlockPhiTransition(asm, block, defaultSuccessor, defaultSuccessor.getScope());
                  String label = defaultSuccessor.getLabel().getLocalName().replace('@', 'b').replace(':', '_');
                  asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
               } else {
                  String label = (defaultSuccessor.getLabel().getLocalName() + "_from_" + block.getLabel().getLocalName()).replace('@', 'b').replace(':', '_');
                  asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
               }
            } else {
               String label = defaultSuccessor.getLabel().getLocalName().replace('@', 'b').replace(':', '_');
               asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
            }
         }
      }
      if(!ScopeRef.ROOT.equals(currentScope)) {
         addData(asm, currentScope);
         asm.addScopeEnd();
      }
      addData(asm, ScopeRef.ROOT);
      program.setAsm(asm);
   }

   /**
    * Add constant declarations for all scope constants
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addConstants(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<ConstantVar> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      for(ConstantVar constantVar : scopeConstants) {
         if(!(constantVar.getValue() instanceof ConstantArrayList || constantVar.getValue() instanceof ConstantArrayFilled || constantVar.getType().equals(SymbolType.STRING))) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               added.add(asmName);
               String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getValue(), 99, scopeRef);
               if(constantVar.getType() instanceof SymbolTypePointer) {
                  // Must use a label for pointers
                  asm.addLabelDecl(asmName.replace("#", "_").replace("$", "_"), asmConstant);
               } else {
                  // Use constant for non-pointers
                  asm.addConstant(asmName.replace("#", "_").replace("$", "_"), asmConstant);
               }
            }
         }
      }
   }

   /**
    * Add data directives for constants declarations
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addData(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<ConstantVar> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      for(ConstantVar constantVar : scopeConstants) {
         Integer declaredAlignment = constantVar.getDeclaredAlignment();
         if(declaredAlignment != null) {
            String alignment = AsmFormat.getAsmNumber(declaredAlignment);
            asm.addDataAlignment(alignment);
         }
         if(constantVar.getValue() instanceof ConstantArrayList) {
            ConstantArrayList constantArrayList = (ConstantArrayList) constantVar.getValue();
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               List<String> asmElements = new ArrayList<>();
               for(ConstantValue element : constantArrayList.getElements()) {
                  String asmElement = AsmFormat.getAsmConstant(program, element, 99, scopeRef);
                  asmElements.add(asmElement);
               }
               if(SymbolType.isByte(constantArrayList.getElementType())) {
                  asm.addDataNumeric(asmName.replace("#", "_").replace("$", "_"), AsmDataNumeric.Type.BYTE, asmElements);
                  added.add(asmName);
               } else if(SymbolType.isSByte(constantArrayList.getElementType())) {
                  asm.addDataNumeric(asmName.replace("#", "_").replace("$", "_"), AsmDataNumeric.Type.BYTE, asmElements);
                  added.add(asmName);
               } else {
                  throw new RuntimeException("Unhandled constant array element type " + constantArrayList.toString(program));
               }
            }
         } else if(constantVar.getValue() instanceof ConstantArrayFilled) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            ConstantArrayFilled constantArrayFilled = (ConstantArrayFilled) constantVar.getValue();
            if(SymbolType.isByte(constantArrayFilled.getElementType())) {
               asm.addDataFilled(asmName.replace("#", "_").replace("$", "_"), AsmDataNumeric.Type.BYTE, constantArrayFilled.getSize(), "0");
               added.add(asmName);
            } else {
               throw new RuntimeException("Unhandled constant array element type " + constantArrayFilled.toString(program));
            }
         } else if(constantVar.getType().equals(SymbolType.STRING)) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getValue(), 99, scopeRef);
            asm.addDataString(asmName.replace("#", "_").replace("$", "_"), asmConstant);
            added.add(asmName);
         }
      }
   }

   /**
    * Add label declarations for all scope variables assigned to ZP registers
    *
    * @param asm The ASM program
    * @param scope The scope
    */
   private void addZpLabels(AsmProgram asm, ScopeRef scope) {
      Collection<Variable> scopeVars = program.getScope().getScope(scope).getAllVariables(false);
      Set<String> added = new LinkedHashSet<>();
      for(Variable scopeVar : scopeVars) {
         Registers.Register register = scopeVar.getAllocation();
         if(register != null && register.isZp()) {
            Registers.RegisterZp registerZp = (Registers.RegisterZp) register;
            String asmName = scopeVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               asm.addLabelDecl(asmName.replace("#", "_").replace("$", "_"), registerZp.getZp());
               added.add(asmName);
            }
         }
      }
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      Iterator<Statement> statementsIt = block.getStatements().iterator();
      AsmCodegenAluState aluState = new AsmCodegenAluState();
      while(statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         if(!(statement instanceof StatementPhiBlock)) {
            generateStatementAsm(asm, block, statement, aluState, true);
         }
      }
   }

   /**
    * Generate ASM code for a single statement
    *
    * @param asm The ASM program to generate into
    * @param block The block containing the statement
    * @param statement The statement to generate ASM code for
    * @param aluState State of the special ALU register. Used to generate composite fragments when two consecutive statements can be executed effectively.
    * For example ADC $1100,x combines two statements $0 = $1100 staridx X, A = A+$0 .
    */
   public void generateStatementAsm(AsmProgram asm, ControlFlowBlock block, Statement statement, AsmCodegenAluState aluState, boolean genCallPhiEntry) {

      asm.startSegment(statement.getIndex(), statement.toString(program, verboseAliveInfo));

      // IF the previous statement was added to the ALU register - generate the composite ASM fragment
      if(aluState.hasAluAssignment()) {
         StatementAssignment assignmentAlu = aluState.getAluAssignment();
         if(!(statement instanceof StatementAssignment)) {
            throw new AsmFragmentInstance.AluNotApplicableException();
         }
         StatementAssignment assignment = (StatementAssignment) statement;
         AsmFragmentInstanceSpec asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(assignment, assignmentAlu, program);
         AsmFragmentInstance asmFragmentInstance = AsmFragmentTemplateSynthesizer.getFragmentInstance(asmFragmentInstanceSpec, program.getLog());
         asm.getCurrentSegment().setFragment(asmFragmentInstance.getFragmentName());
         asmFragmentInstance.generate(asm);
         aluState.clear();
         return;
      }

      if(!(statement instanceof StatementPhiBlock)) {
         if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            boolean isAlu = false;
            if(lValue instanceof VariableRef) {
               VariableRef lValueRef = (VariableRef) lValue;
               Registers.Register lValRegister = program.getSymbolInfos().getVariable(lValueRef).getAllocation();
               if(lValRegister.getType().equals(Registers.RegisterType.REG_ALU)) {
                  asm.addComment(statement + "  //  ALU");
                  StatementAssignment assignmentAlu = assignment;
                  aluState.setAluAssignment(assignmentAlu);
                  isAlu = true;
               }
            }
            if(!isAlu) {
               if(assignment.getOperator() == null && assignment.getrValue1() == null && isRegisterCopy(lValue, assignment.getrValue2())) {
                  asm.addComment(lValue.toString(program) + " = " + assignment.getrValue2().toString(program) + "  // register copy " + getRegister(lValue));
               } else {
                  AsmFragmentInstanceSpec asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(assignment, program);
                  AsmFragmentInstance asmFragmentInstance = AsmFragmentTemplateSynthesizer.getFragmentInstance(asmFragmentInstanceSpec, program.getLog());
                  asm.getCurrentSegment().setFragment(asmFragmentInstance.getFragmentName());
                  asmFragmentInstance.generate(asm);
               }
            }
         } else if(statement instanceof StatementConditionalJump) {
            AsmFragmentInstanceSpec asmFragmentInstanceSpec = new AsmFragmentInstanceSpec((StatementConditionalJump) statement, block, program, getGraph());
            AsmFragmentInstance asmFragmentInstance = AsmFragmentTemplateSynthesizer.getFragmentInstance(asmFragmentInstanceSpec, program.getLog());
            asm.getCurrentSegment().setFragment(asmFragmentInstance.getFragmentName());
            asmFragmentInstance.generate(asm);
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            if(genCallPhiEntry) {
               ControlFlowBlock callSuccessor = getGraph().getCallSuccessor(block);
               if(callSuccessor != null && callSuccessor.hasPhiBlock()) {
                  PhiTransitions.PhiTransition transition = getTransitions(callSuccessor).getTransition(block);
                  if(transition.isGenerated()) {
                     throw new RuntimeException("Error! JSR transition already generated. Must modify PhiTransitions code to ensure this does not happen.");
                  }
                  genBlockPhiTransition(asm, block, callSuccessor, block.getScope());
               }
            }
            asm.addInstruction("jsr", AsmAddressingMode.ABS, call.getProcedure().getFullName(), false);
         } else if(statement instanceof StatementReturn) {
            asm.addInstruction("rts", AsmAddressingMode.NON, null, false);
         } else if(statement instanceof StatementAsm) {
            StatementAsm statementAsm = (StatementAsm) statement;
            HashMap<String, Value> bindings = new HashMap<>();
            AsmFragmentInstance asmFragmentInstance = new AsmFragmentInstance(program, "inline", block.getScope(), new AsmFragmentTemplate(statementAsm.getAsmLines()), bindings);
            asmFragmentInstance.generate(asm);
         } else {
            throw new RuntimeException("Statement not supported " + statement);
         }
      }
   }

   /**
    * Generate all block entry points (phi transitions) which have not already been generated.
    *
    * @param asm The ASM program to generate into
    * @param toBlock The block to generate remaining entry points for.
    */
   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock toBlock) {
      PhiTransitions transitions = getTransitions(toBlock);
      for(ControlFlowBlock fromBlock : transitions.getFromBlocks()) {
         PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
         if(!transition.isGenerated() && toBlock.getLabel().equals(fromBlock.getConditionalSuccessor())) {
            genBlockPhiTransition(asm, fromBlock, toBlock, toBlock.getScope());
            asm.addInstruction("JMP", AsmAddressingMode.ABS, toBlock.getLabel().getLocalName().replace('@', 'b').replace(':', '_'), false);
         }
      }
   }

   /**
    * Generate a phi block transition. The transition performs all necessary assignment operations when moving from one block to another.
    * The transition can be inserted either at the start of the to-block (used for conditional jumps)
    * or at the end of the from-block ( used at default block transitions and before JMP/JSR)
    *
    * @param asm The ASP program to generate the transition into.
    * @param fromBlock The from-block
    * @param toBlock The to-block
    * @param scope The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
    * If the transition code is inserted in the to-block, this is the scope of the to-block.
    * If the transition code is inserted in the from-block this is the scope of the from-block.
    */
   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock, ScopeRef scope) {
      PhiTransitions transitions = getTransitions(toBlock);
      PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
      if(!transition.isGenerated()) {
         Statement toFirstStatement = toBlock.getStatements().get(0);
         String segmentSrc = "[" + toFirstStatement.getIndex() + "] phi from ";
         for(ControlFlowBlock fBlock : transition.getFromBlocks()) {
            segmentSrc += fBlock.getLabel().getFullName() + " ";
         }
         segmentSrc += "to " + toBlock.getLabel().getFullName();
         asm.startSegment(toFirstStatement.getIndex(), segmentSrc);
         asm.getCurrentSegment().setPhiTransitionId(transition.getTransitionId());
         for(ControlFlowBlock fBlock : transition.getFromBlocks()) {
            asm.addLabel((toBlock.getLabel().getLocalName() + "_from_" + fBlock.getLabel().getLocalName()).replace('@', 'b').replace(':', '_'));
         }
         List<PhiTransitions.PhiTransition.PhiAssignment> assignments = transition.getAssignments();
         for(PhiTransitions.PhiTransition.PhiAssignment assignment : assignments) {
            LValue lValue = assignment.getVariable();
            RValue rValue = assignment.getrValue();
            Statement statement = assignment.getPhiBlock();
            // Generate an ASM move fragment
            asm.startSegment(statement.getIndex(), "[" + statement.getIndex() + "] phi " + lValue.toString(program) + " = " + rValue.toString(program));
            asm.getCurrentSegment().setPhiTransitionId(transition.getTransitionId());
            asm.getCurrentSegment().setPhiTransitionAssignmentIdx(assignment.getAssignmentIdx());
            if(isRegisterCopy(lValue, rValue)) {
               asm.getCurrentSegment().setFragment("register_copy");
            } else {
               AsmFragmentInstanceSpec asmFragmentInstanceSpec = new AsmFragmentInstanceSpec(lValue, rValue, program, scope);
               AsmFragmentInstance asmFragmentInstance = AsmFragmentTemplateSynthesizer.getFragmentInstance(asmFragmentInstanceSpec, program.getLog());
               asm.getCurrentSegment().setFragment(asmFragmentInstance.getFragmentName());
               asmFragmentInstance.generate(asm);
            }
         }
         transition.setGenerated(true);
      } else {
         program.getLog().append("Already generated transition from " + fromBlock.getLabel() + " to " + toBlock.getLabel() + " - not generating it again!");
      }
   }

   /**
    * Get phi transitions for a specific to-block.
    *
    * @param toBlock The block
    * @return The transitions into the block
    */
   private PhiTransitions getTransitions(ControlFlowBlock toBlock) {
      PhiTransitions transitions = this.blockTransitions.get(toBlock);
      if(transitions == null) {
         transitions = new PhiTransitions(program, toBlock);
         this.blockTransitions.put(toBlock, transitions);
      }
      return transitions;
   }

   private Registers.Register getRegister(RValue rValue) {
      if(rValue instanceof VariableRef) {
         VariableRef rValueRef = (VariableRef) rValue;
         return program.getSymbolInfos().getVariable(rValueRef).getAllocation();
      } else if(rValue instanceof CastValue) {
         return getRegister(((CastValue) rValue).getValue());
      } else {
         return null;
      }
   }

   private boolean isRegisterCopy(LValue lValue, RValue rValue) {
      return
            getRegister(lValue) != null &&
                  getRegister(rValue) != null &&
                  getRegister(lValue).equals(getRegister(rValue));
   }

   /**
    * Contains previous assignment added to the ALU register between calls to generateStatementAsm
    */
   public static class AsmCodegenAluState {

      private StatementAssignment aluAssignment;

      public StatementAssignment getAluAssignment() {
         return aluAssignment;
      }

      public void setAluAssignment(StatementAssignment aluAssignment) {
         this.aluAssignment = aluAssignment;
      }

      public boolean hasAluAssignment() {
         return aluAssignment != null;
      }

      public void clear() {
         aluAssignment = null;
      }
   }

}
