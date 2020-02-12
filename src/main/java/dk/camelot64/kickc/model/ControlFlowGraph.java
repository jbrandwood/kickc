package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.Pass2ConstantIdentification;

import java.io.Serializable;
import java.util.*;

/**
 * The control flow graph of the program.
 * The control flow  graph is a set of connected basic blocks.
 */
public class ControlFlowGraph implements Serializable {

   private List<ControlFlowBlock> blocks;
   private LabelRef firstBlockRef;

   /**
    * Sequence of blocks used when generating ASM
    */
   private List<LabelRef> sequence;

   public ControlFlowGraph(List<ControlFlowBlock> blocks, LabelRef firstBlockRef) {
      this.blocks = blocks;
      this.firstBlockRef = firstBlockRef;
   }

   public ControlFlowBlock getBlock(LabelRef symbol) {
      for(ControlFlowBlock block : blocks) {
         if(block.getLabel().equals(symbol)) {
            return block;
         }
      }
      return null;
   }

   public void addBlock(ControlFlowBlock block) {
      blocks.add(block);
   }

   public ControlFlowBlock getFirstBlock() {
      return getBlock(firstBlockRef);
   }

   public List<ControlFlowBlock> getAllBlocks() {
         return blocks;
   }

   public void remove(LabelRef label) {
      ListIterator<ControlFlowBlock> blocksIt = blocks.listIterator();
      while(blocksIt.hasNext()) {
         ControlFlowBlock block = blocksIt.next();
         if(block.getLabel().equals(label)) {
            blocksIt.remove();
            return;
         }
      }
   }

   /**
    * Get the assignment of the passed variable. Assumes that only a single assignment exists.
    *
    * @param variable The variable to find the assignment for
    * @return The assignment. null if the variable is not assigned. The variable is assigned by a Phi-statement instead.
    */
   public StatementLValue getAssignment(VariableRef variable) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
                  return assignment;
               }
            }
         }
      }
      return null;
   }

   /** Any assignment of a value to a SymbolVariable.
    * Potential assignments include StatementLValue, StatementPhi and Variable.initValue
    * */
   public static class VarAssignment {

      public enum Type {
         STATEMENT_LVALUE,
         STATEMENT_PHI,
         INIT_VALUE
      }

      /** The type of assignment. */
      public final Type type;

      /** The block  containing the assignment statement. Null if type is not STATEMENT_LVALUE or STATEMENT_PHI */
      public final ControlFlowBlock block;

      /* The LValue-statement. Null if type is not STATEMENT_LVALUE. */
      public final StatementLValue statementLValue;

      /* The PHI-statement. Null if type is not STATEMENT_PHI. */
      public final StatementPhiBlock statementPhi;
      public final StatementPhiBlock.PhiVariable statementPhiVariable;

      /* The Variable with initValue. Null if type is not INIT_VALUE. */
      public final Variable variableInitValue;

      public VarAssignment(Type type, ControlFlowBlock block, StatementLValue statementLValue, StatementPhiBlock statementPhi, StatementPhiBlock.PhiVariable statementPhiVariable, Variable variableInitValue) {
         this.type = type;
         this.block = block;
         this.statementLValue = statementLValue;
         this.statementPhi = statementPhi;
         this.statementPhiVariable = statementPhiVariable;
         this.variableInitValue = variableInitValue;
      }

      @Override
      public String toString() {
         StringBuilder s = new StringBuilder();
         if(block!=null)
            s.append(block.getLabel()).append("::");
         if(statementLValue!=null)
            s.append(statementLValue.toString());
         if(statementPhi!=null)
            s.append(statementPhi.toString()).append(" ");
         if(statementPhiVariable!=null)
            s.append(statementPhiVariable.toString());
         if(variableInitValue!=null)
            s.append(variableInitValue.toString());
         return s.toString();
      }

      public StatementSource getSource() {
         if(statementLValue!=null)
            return statementLValue.getSource();
         if(statementPhi!=null)
            return statementPhi.getSource();
         return null;
      }

   }

   /**
    * Get all assignments of value to a variable.
    *
    * @param variable The variable to find the assignment for
    * @return All assignments of values to the variable
    */
   public static List<VarAssignment> getVarAssignments(SymbolVariableRef variable, ControlFlowGraph graph, ProgramScope programScope) {
      ArrayList<VarAssignment> varAssignments = new ArrayList<>();
      Variable varDef = programScope.getVariable(variable);
      if(varDef.getInitValue()!=null) {
         varAssignments.add(new VarAssignment(VarAssignment.Type.INIT_VALUE, null, null, null, null, varDef));
      }
      for(ControlFlowBlock block : graph.getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.equals(assignment.getlValue())) {
                  varAssignments.add(new VarAssignment(VarAssignment.Type.STATEMENT_LVALUE, block, assignment, null, null, null));
               }
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  if(phiVariable.getVariable().equals(variable)) {
                     varAssignments.add(new VarAssignment(VarAssignment.Type.STATEMENT_PHI, block, null, (StatementPhiBlock) statement, phiVariable, null));
                  }
               }
            }
         }
      }
      return varAssignments;
   }

   public ControlFlowBlock getDefaultSuccessor(ControlFlowBlock block) {
      if(block.getDefaultSuccessor() != null) {
         return getBlock(block.getDefaultSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getCallSuccessor(ControlFlowBlock block) {
      if(block.getCallSuccessor() != null) {
         return getBlock(block.getCallSuccessor());
      } else {
         return null;
      }
   }

   public ControlFlowBlock getConditionalSuccessor(ControlFlowBlock block) {
      if(block.getConditionalSuccessor() != null) {
         return getBlock(block.getConditionalSuccessor());
      } else {
         return null;
      }
   }

   public List<ControlFlowBlock> getPredecessors(ControlFlowBlock block) {
      ArrayList<ControlFlowBlock> predecessorBlocks = new ArrayList<>();
      for(ControlFlowBlock other : getAllBlocks()) {
         if(block.getLabel().equals(other.getDefaultSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getConditionalSuccessor())) {
            predecessorBlocks.add(other);
         }
         if(block.getLabel().equals(other.getCallSuccessor())) {
            predecessorBlocks.add(other);
         }
      }
      Collections.sort(predecessorBlocks, Comparator.comparing(o -> o.getLabel().getFullName()));
      return predecessorBlocks;
   }

   public List<LabelRef> getSequence() {
      return sequence;
   }

   public void setSequence(List<LabelRef> sequence) {
      if(sequence.size()!=blocks.size()) {
         throw new CompileError("ERROR! Sequence does not contain all blocks from the program. Sequence: "+sequence.size()+" Blocks: "+blocks.size());
      }
      this.sequence = sequence;
      ArrayList<ControlFlowBlock> seqBlocks = new ArrayList<>();
      for(LabelRef labelRef : sequence) {
         seqBlocks.add(getBlock(labelRef));
      }
      this.blocks = seqBlocks;
   }

   public ControlFlowBlock getMainBlock() {
      for(ControlFlowBlock block : getAllBlocks()) {
         LabelRef label = block.getLabel();
         if(label.getFullName().equals(SymbolRef.MAIN_PROC_NAME)) {
            return block;
         }
      }
      return null;
   }

   /**
    * Get all blocks that are program entry points.
    * This is the main-block and any blocks referenced by the address-off operator (&)
    * @param program The program
    * @return All entry-point blocks
    */
   public List<ControlFlowBlock> getEntryPointBlocks(Program program) {
      List<ControlFlowBlock> entryPointBlocks = new ArrayList<>();
      for(Procedure procedure : program.getScope().getAllProcedures(true)) {
         if(Pass2ConstantIdentification.isAddressOfUsed(procedure.getRef(), program) || procedure.getCallingConvension().equals(Procedure.CallingConvension.STACK_CALL)) {
            // Address-of is used on the procedure
            Label procedureLabel = procedure.getLabel();
            ControlFlowBlock procedureBlock = getBlock(procedureLabel.getRef());
            entryPointBlocks.add(procedureBlock);
         }
      }

      ControlFlowBlock mainBlock = getMainBlock();
      if(mainBlock != null) {
         entryPointBlocks.add(mainBlock);
      }
      entryPointBlocks.add(getFirstBlock());
      return entryPointBlocks;
   }


   @Override
   public String toString() {
      return toString(null);
   }

   public String toString(Program program) {
      StringBuffer out = new StringBuffer();
      for(ControlFlowBlock block : getAllBlocks()) {
         out.append(block.toString(program));
      }
      return out.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;

      ControlFlowGraph that = (ControlFlowGraph) o;

      if(!blocks.equals(that.blocks)) return false;
      if(!firstBlockRef.equals(that.firstBlockRef)) return false;
      return sequence != null ? sequence.equals(that.sequence) : that.sequence == null;
   }

   @Override
   public int hashCode() {
      int result = blocks.hashCode();
      result = 31 * result + firstBlockRef.hashCode();
      result = 31 * result + (sequence != null ? sequence.hashCode() : 0);
      return result;
   }

   /**
    * Get a statement from its statement index
    *
    * @param statementIdx The statement index
    * @return The statement
    */
   public Statement getStatementByIndex(int statementIdx) {
      for(ControlFlowBlock block : getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statementIdx == statement.getIndex()) {
               return statement;
            }
         }
      }
      return null;
   }

   /**
    * Get all blocks that are part of the execution of a specific scope. (mostly a procedure)
    *
    * @param scope The scope to find blocks for
    * @return All blocks that are part of the execution of the scope
    */
   public List<ControlFlowBlock> getScopeBlocks(ScopeRef scope) {
      ArrayList<ControlFlowBlock> scopeBlocks = new ArrayList<>();
      for(ControlFlowBlock block : getAllBlocks()) {
         if(block.getScope().equals(scope)) {
            scopeBlocks.add(block);
         }
      }
      return scopeBlocks;
   }

   /**
    * Get information about the size of the program
    * @return Size information
    */
   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      sizeInfo.append("SIZE blocks "+ getAllBlocks().size()).append("\n");
      int numStmt = getAllBlocks().stream().mapToInt(block -> block.getStatements().size()).sum();
      sizeInfo.append("SIZE statements "+ numStmt).append("\n");
      int numPhiVars =  getAllBlocks().stream().mapToInt(value -> value.getStatements().stream().mapToInt(value1 -> (value1 instanceof StatementPhiBlock)?((StatementPhiBlock) value1).getPhiVariables().size():0).sum()).sum();
      sizeInfo.append("SIZE phi variables "+ numPhiVars).append("\n");
      return sizeInfo.toString();
   }

}
