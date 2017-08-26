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
      ScopeRef currentScope = ScopeRef.ROOT;

      // Generate global ZP labels
      asm.startSegment(null, "Global ZP labels");
      addZpLabels(asm, currentScope);
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         if (!block.getScope().equals(currentScope)) {
            if (!ScopeRef.ROOT.equals(currentScope)) {
               asm.addScopeEnd();
            }
            currentScope = block.getScope();
            asm.startSegment(null, block.getLabel().getFullName());
            asm.addScopeBegin(block.getLabel().getFullName().replace('@', 'b').replace(':', '_'));
            // Add all ZP labels for the scope
            addZpLabels(asm, currentScope);
         }
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);
         if (!block.isProcedureEntry(program)) {
            // Generate label
            asm.startSegment(null, block.getLabel().getFullName());
            asm.addLabel(block.getLabel().getLocalName().replace('@', 'b').replace(':', '_'));
         }
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if (defaultSuccessor != null) {
            if (defaultSuccessor.hasPhiBlock()) {
               PhiTransitions.PhiTransition transition = getTransitions(defaultSuccessor).getTransition(block);
               if (!transition.isGenerated()) {
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
      if (!ScopeRef.ROOT.equals(currentScope)) {
         asm.addScopeEnd();
      }
      program.setAsm(asm);
   }

   /**
    * Add label declarations for all scope variables assigned to ZP registers
    *
    * @param asm   The ASM program
    * @param scope The scope
    */
   private void addZpLabels(AsmProgram asm, ScopeRef scope) {
      Collection<Variable> scopeVars = program.getScope().getScope(scope).getAllVariables(false);
      Set<String> added = new LinkedHashSet<>();
      for (Variable scopeVar : scopeVars) {
         Registers.Register register = scopeVar.getAllocation();
         if (register != null && register.isZp()) {
            Registers.RegisterZp registerZp = (Registers.RegisterZp) register;
            String asmName = scopeVar.getAsmName();
            if (asmName != null && !added.contains(asmName)) {
               asm.addLabelDecl(asmName, registerZp.getZp());
               added.add(asmName);
            }
         }
      }
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      Iterator<Statement> statementsIt = block.getStatements().iterator();
      AsmCodegenAluState aluState = new AsmCodegenAluState();
      while (statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         if (!(statement instanceof StatementPhiBlock)) {
            generateStatementAsm(asm, block, statement, aluState, true);
         }
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
   public void generateStatementAsm(AsmProgram asm, ControlFlowBlock block, Statement statement, AsmCodegenAluState aluState, boolean genCallPhiEntry) {

      asm.startSegment(statement.getIndex(), statement.toString(program));

      // IF the previous statement was added to the ALU register - generate the composite ASM fragment
      if (aluState.hasAluAssignment()) {
         StatementAssignment assignmentAlu = aluState.getAluAssignment();
         if (!(statement instanceof StatementAssignment)) {
            throw new AsmFragment.AluNotApplicableException();
         }
         StatementAssignment assignment = (StatementAssignment) statement;
         AsmFragment asmFragment = new AsmFragment(assignment, assignmentAlu, program);
         asm.getCurrentSegment().setFragment(asmFragment.getSignature());
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
               Registers.Register lValRegister = program.getScope().getVariable(lValueRef).getAllocation();
               if (lValRegister.getType().equals(Registers.RegisterType.REG_ALU_BYTE)) {
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
                  asm.getCurrentSegment().setFragment(asmFragment.getSignature());
                  asmFragment.generate(asm);
               }
            }
         } else if (statement instanceof StatementConditionalJump) {
            AsmFragment asmFragment = new AsmFragment((StatementConditionalJump) statement, block, program, getGraph());
            asm.getCurrentSegment().setFragment(asmFragment.getSignature());
            asmFragment.generate(asm);
         } else if (statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            if (genCallPhiEntry) {
               ControlFlowBlock callSuccessor = getGraph().getCallSuccessor(block);
               if (callSuccessor != null && callSuccessor.hasPhiBlock()) {
                  PhiTransitions.PhiTransition transition = getTransitions(callSuccessor).getTransition(block);
                  if (transition.isGenerated()) {
                     throw new RuntimeException("Error! JSR transition already generated. Must modify PhiTransitions code to ensure this does not happen.");
                  }
                  genBlockPhiTransition(asm, block, callSuccessor, block.getScope());
               }
            }
            asm.addInstruction("jsr", AsmAddressingMode.ABS, call.getProcedure().getFullName(), false);
         } else if (statement instanceof StatementReturn) {
            asm.addInstruction("rts", AsmAddressingMode.NON, null, false);
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

   /**
    * Generate all block entry points (phi transitions) which have not already been generated.
    *
    * @param asm     The ASM program to generate into
    * @param toBlock The block to generate remaining entry points for.
    */
   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock toBlock) {
      PhiTransitions transitions = getTransitions(toBlock);
      for (ControlFlowBlock fromBlock : transitions.getFromBlocks()) {
         PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
         if (!transition.isGenerated() && toBlock.getLabel().equals(fromBlock.getConditionalSuccessor())) {
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
    * @param asm       The ASP program to generate the transition into.
    * @param fromBlock The from-block
    * @param toBlock   The to-block
    * @param scope     The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
    *                  If the transition code is inserted in the to-block, this is the scope of the to-block.
    *                  If the transition code is inserted in the from-block this is the scope of the from-block.
    */
   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock, ScopeRef scope) {
      PhiTransitions transitions = getTransitions(toBlock);
      PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
      if (!transition.isGenerated()) {

         Statement toFirstStatement = toBlock.getStatements().get(0);
         String segmentSrc = "[" + toFirstStatement.getIndex() + "] phi from ";
         for (ControlFlowBlock fBlock : transition.getFromBlocks()) {
            segmentSrc += fBlock.getLabel().getFullName() + " ";
         }
         segmentSrc += "to " + toBlock.getLabel().getFullName();
         asm.startSegment(toFirstStatement.getIndex(), segmentSrc);

         for (ControlFlowBlock fBlock : transition.getFromBlocks()) {
            asm.addLabel((toBlock.getLabel().getLocalName() + "_from_" + fBlock.getLabel().getLocalName()).replace('@', 'b').replace(':', '_'));
         }

         List<PhiTransitions.PhiTransition.PhiAssignment> assignments = transition.getAssignments();
         for (PhiTransitions.PhiTransition.PhiAssignment assignment : assignments) {
            genAsmMove(asm, assignment.getVariable(), assignment.getrValue(), assignment.getPhiBlock(), scope);
         }
         transition.setGenerated(true);
      } else {
         program.getLog().append("Already generated transition from "+fromBlock.getLabel()+" to "+toBlock.getLabel()+ " - not generating it again!");
      }
   }


   /**
    * Keeps track of the phi transitions into blocks during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    * Maps to-blocks to the transition information for the block
    */
   private Map<ControlFlowBlock, PhiTransitions> blockTransitions = new LinkedHashMap<>();

   /**
    * Get phi transitions for a specific to-block.
    *
    * @param toBlock The block
    * @return The transitions into the block
    */
   private PhiTransitions getTransitions(ControlFlowBlock toBlock) {
      PhiTransitions transitions = this.blockTransitions.get(toBlock);
      if (transitions == null) {
         transitions = new PhiTransitions(toBlock);
         this.blockTransitions.put(toBlock, transitions);
      }
      return transitions;
   }

   /**
    * Keeps track of the phi transitions into a single block during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    */
   public class PhiTransitions {

      /**
       * Label of the to-block.
       */
      private ControlFlowBlock toBlock;

      /**
       * The phi-block of the to-block.
       */
      private StatementPhiBlock phiBlock;

      /**
       * Maps from-block to the transition from the from-block to the to-block.
       */
      private Map<ControlFlowBlock, PhiTransition> transitions;

      public PhiTransitions(ControlFlowBlock toBlock) {
         this.toBlock = toBlock;
         this.transitions = new LinkedHashMap<>();
         if (toBlock.hasPhiBlock()) {
            this.phiBlock = toBlock.getPhiBlock();
            List<ControlFlowBlock> predecessors = new ArrayList<>(getGraph().getPredecessors(toBlock));
            Collections.sort(predecessors, new Comparator<ControlFlowBlock>() {
               @Override
               public int compare(ControlFlowBlock o1, ControlFlowBlock o2) {
                  return o1.getLabel().getFullName().compareTo(o2.getLabel().getFullName());
               }
            });
            for (ControlFlowBlock predecessor : predecessors) {
               PhiTransition transition = findTransition(predecessor);
               transitions.put(predecessor, transition);
            }
         }
      }

      /**
       * Find the transition from a specific fromBlock.
       * If another transition already has the same assignments it is reused. If not a new transition is created.
       *
       * @param fromBlock
       * @return
       */
      private PhiTransition findTransition(ControlFlowBlock fromBlock) {
         PhiTransition transition = new PhiTransition(fromBlock);
         for (PhiTransition candidate : transitions.values()) {
            if (candidate.equalAssignments(transition)) {
               candidate.addFromBlock(fromBlock);
               return candidate;
            }
         }
         return transition;
      }

      public Collection<ControlFlowBlock> getFromBlocks() {
         return transitions.keySet();
      }

      /**
       * Get the transition into the to-block from a specific from-block
       *
       * @param fromBlock The from-block
       * @return The transition from the from-block into the to-block
       */
      public PhiTransition getTransition(ControlFlowBlock fromBlock) {
         PhiTransition transition = transitions.get(fromBlock);
         if (transition == null) {
            transition = findTransition(fromBlock);
            transitions.put(fromBlock, transition);
         }
         return transition;
      }


      /**
       * A single transition into a to-block.
       * The transition contains the assignments necessary to enter the to-block from specific from-block(s).
       * The transition may be shared between multiple from-blocks, if the assignments are identical.
       */
      public class PhiTransition {

         private List<ControlFlowBlock> fromBlocks;

         private List<PhiAssignment> assignments;

         private boolean generated;

         public PhiTransition(ControlFlowBlock fromBlock) {
            this.fromBlocks = new ArrayList<>();
            this.fromBlocks.add(fromBlock);
            this.generated = false;
            initAssignments(fromBlock);
         }

         private void initAssignments(ControlFlowBlock fromBlock) {
            this.assignments = new ArrayList<>();
            if (phiBlock != null) {
               List<StatementPhiBlock.PhiVariable> phiVariables = new ArrayList<>(phiBlock.getPhiVariables());
               Collections.reverse(phiVariables);
               for (StatementPhiBlock.PhiVariable phiVariable : phiVariables) {
                  List<StatementPhiBlock.PhiRValue> phiRValues = new ArrayList<>(phiVariable.getValues());
                  Collections.sort(phiRValues, new Comparator<StatementPhiBlock.PhiRValue>() {
                     @Override
                     public int compare(StatementPhiBlock.PhiRValue o1, StatementPhiBlock.PhiRValue o2) {
                        return o1.getPredecessor().getFullName().compareTo(o2.getPredecessor().getFullName());
                     }
                  });
                  for (StatementPhiBlock.PhiRValue phiRValue : phiRValues) {
                     if (phiRValue.getPredecessor().equals(fromBlock.getLabel())) {
                        this.assignments.add(new PhiAssignment(phiVariable, phiRValue));
                     }
                  }
               }
            }
         }

         public List<PhiAssignment> getAssignments() {
            return assignments;
         }

         public boolean isGenerated() {
            return generated;
         }

         public void setGenerated(boolean generated) {
            this.generated = generated;
         }

         public void addFromBlock(ControlFlowBlock fromBlock) {
            fromBlocks.add(fromBlock);
         }

         /**
          * Determines if another transition has the exact same assignments as this block
          *
          * @param other The other transition to examine
          * @return true if the assignments are identical
          */
         public boolean equalAssignments(PhiTransition other) {
            List<PhiAssignment> otherAssignments = other.getAssignments();
            if (assignments.size() != otherAssignments.size()) {
               return false;
            }
            for (int i = 0; i < assignments.size(); i++) {
               PhiAssignment assignment = assignments.get(i);
               PhiAssignment otherAssignment = otherAssignments.get(i);
               ProgramScope scope = program.getScope();
               if (assignment.getVariable() instanceof VariableRef && otherAssignment.getVariable() instanceof VariableRef) {
                  Variable var = scope.getVariable((VariableRef) assignment.getVariable());
                  Variable otherVar = scope.getVariable((VariableRef) otherAssignment.getVariable());
                  if (!var.getAllocation().equals(otherVar.getAllocation())) {
                     return false;
                  }
               } else if (!assignment.getVariable().equals(otherAssignment.getVariable())) {
                  return false;
               }
               if (assignment.getrValue() instanceof VariableRef && otherAssignment.getrValue() instanceof VariableRef) {
                  Variable var = scope.getVariable((VariableRef) assignment.getrValue());
                  Variable otherVar = scope.getVariable((VariableRef) otherAssignment.getrValue());
                  if (!var.getAllocation().equals(otherVar.getAllocation())) {
                     return false;
                  }
               } else if (!assignment.getrValue().equals(otherAssignment.getrValue())) {
                  return false;
               }
            }
            return true;
         }

         public List<ControlFlowBlock> getFromBlocks() {
            return fromBlocks;
         }

         /**
          * Assignment of a single value during a phi transition
          */
         public class PhiAssignment {

            private StatementPhiBlock.PhiVariable phiVariable;

            private StatementPhiBlock.PhiRValue phiRValue;

            public PhiAssignment(StatementPhiBlock.PhiVariable phiVariable, StatementPhiBlock.PhiRValue phiRValue) {
               this.phiVariable = phiVariable;
               this.phiRValue = phiRValue;
            }

            public LValue getVariable() {
               return phiVariable.getVariable();
            }

            public RValue getrValue() {
               return phiRValue.getrValue();
            }

            public Statement getPhiBlock() {
               return phiBlock;
            }

         }

      }

   }

   private Registers.Register getRegister(RValue rValue) {
      if (rValue instanceof VariableRef) {
         VariableRef rValueRef = (VariableRef) rValue;
         return program.getScope().getVariable(rValueRef).getAllocation();
      } else {
         return null;
      }
   }

   /**
    * Generate ASM assigning a value (rValue) to a variable (lValue).
    *
    * @param asm       The ASM program to generate into
    * @param lValue    The lValue that should be assigned the value
    * @param rValue    The rValue to assign to the lValue.
    * @param statement The ICL statement that is the cause of the assignment.
    * @param scope     The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
    */
   private void genAsmMove(AsmProgram asm, LValue lValue, RValue rValue, Statement statement, ScopeRef scope) {
      asm.startSegment(statement.getIndex(), "[" + statement.getIndex() + "] phi " + lValue.toString(program) + " = " + rValue.toString(program));
      if (isRegisterCopy(lValue, rValue)) {
         asm.getCurrentSegment().setFragment("register_copy");
      } else {
         AsmFragment asmFragment = new AsmFragment(lValue, rValue, program, scope);
         asm.getCurrentSegment().setFragment(asmFragment.getSignature());
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
