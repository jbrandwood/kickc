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
               genBlockPhiTransition(asm, block, defaultSuccessor, defaultSuccessor.getScope());
            }
            asm.addInstruction("JMP", AsmAddressingMode.ABS, defaultSuccessor.getLabel().getLocalName().replace('@', 'b').replace(':', '_'), false);
         }
      }
      if (!ScopeRef.ROOT.equals(currentScope)) {
         asm.addScopeEnd();
      }
      program.setAsm(asm);
   }

   /**
    * Add label declarations for all scope variables assigned to ZP registers
    * @param asm The ASM program
    * @param scope The scope
    */
   private void addZpLabels(AsmProgram asm, ScopeRef scope) {
      Collection<Variable> scopeVars = program.getScope().getScope(scope).getAllVariables(false);
      Set<String> added = new LinkedHashSet<>();
      for (Variable scopeVar : scopeVars) {
         Registers.Register register = scopeVar.getAllocation();
         if(register!=null && register.isZp()) {
            Registers.RegisterZp registerZp = (Registers.RegisterZp) register;
            String asmName = scopeVar.getAsmName();
            if(asmName !=null && !added.contains(asmName)) {
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
               genBlockPhiTransition(asm, predecessor, block, block.getScope());
               asm.addInstruction("JMP", AsmAddressingMode.ABS, block.getLabel().getLocalName().replace('@', 'b').replace(':', '_'), false);
            }
         }
      }
   }


   /** Keeps track of the phi transitions into blocks during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    * Maps to-block label to the transition information*/
   private Map<LabelRef, PhiTransitions> transitions;

   /**
    * Keeps track of the phi transitions into a single block during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    */
   public static class PhiTransitions {

      /** Label of the to-block. */
      private ControlFlowBlock toBlock;

      /** The phi-block of the to-block. */
      private StatementPhiBlock phiBlock;

      public PhiTransition getTransition(LabelRef fromBlock) {
         return null;
      }


      /**
       * A single transition into a to-block.
       * The transition contains the assignments necessary to enter the to-block from specific from-block(s).
       * The transition may be shared between multiple from-blocks, if the assignments are identical.
       */
      public class PhiTransition {

         private List<ControlFlowBlock> fromBlocks;

         private boolean generated;

         public List<PhiAssignment> getAssignments() {
            return null;
         }

         public boolean isGenerated() {
            return generated;
         }

         public void setGenerated(boolean generated) {
            this.generated = generated;
         }

         /**
          * Assignment of a single value during a phi transition
          */
         public class PhiAssignment {

            private StatementPhiBlock.PhiVariable phiVariable;

            private StatementPhiBlock.PhiRValue phiRValue;

         }


      }

   }



   /**
    * Generate a phi block transition. The transition performs all necessary assignment operations when moving from one block to another.
    * The transition can be inserted either at the start of the to-block (used for conditional jumps)
    * or at the end of the from-block ( used at default block transitions and before JMP/JSR)
    * @param asm The ASP program to generate the transition into.
    * @param fromBlock The from-block
    * @param toBlock The to-block
    * @param scope The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
    *              If the transition code is inserted in the to-block, this is the scope of the to-block.
    *              If the transition code is inserted in the from-block this is the scope of the from-block.
    */
   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock, ScopeRef scope) {
      Statement toFirstStatement = toBlock.getStatements().get(0);
      asm.startSegment(toFirstStatement.getIndex(), "[" + toFirstStatement.getIndex() + "]" + " phi from " + fromBlock.getLabel().getFullName() + " to " + toBlock.getLabel().getFullName());
      asm.addLabel((toBlock.getLabel().getLocalName() + "_from_" + fromBlock.getLabel().getLocalName()).replace('@', 'b').replace(':', '_'));
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
                  genAsmMove(asm, phiVariable.getVariable(), phiRValue.getrValue(), phiBlock, scope);
                  break;
               }
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
    * @param asm The ASM program to generate into
    * @param lValue The lValue that should be assigned the value
    * @param rValue The rValue to assign to the lValue.
    * @param statement The ICL statement that is the cause of the assignment.
    * @param scope The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
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
