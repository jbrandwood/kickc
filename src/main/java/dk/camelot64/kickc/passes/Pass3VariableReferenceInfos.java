package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Identify variables defined/referenced for each block & statement.
 */
public class Pass3VariableReferenceInfos extends Pass2Base {

   public Pass3VariableReferenceInfos(Program program) {
      super(program);
   }

   /** Create defined/referenced maps */
   public void generateVariableReferenceInfos() {
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockReferenced = new LinkedHashMap<>();
      LinkedHashMap<LabelRef, Collection<VariableRef>> blockUsed = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtReferenced = new LinkedHashMap<>();
      LinkedHashMap<Integer, Collection<VariableRef>> stmtDefined = new LinkedHashMap<>();
      for (ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         LabelRef blockLabel = block.getLabel();
         blockReferenced.put(blockLabel, getReferenced(blockLabel, new ArrayList<LabelRef>()));
         blockUsed.put(blockLabel, getUsed(blockLabel, new ArrayList<LabelRef>()));
         for (Statement statement : block.getStatements()) {
            stmtDefined.put(statement.getIndex(), getDefined(statement));
            stmtReferenced.put(statement.getIndex(), getReferenced(statement));
         }
      }
      getProgram().setVariableReferenceInfos(new VariableReferenceInfos(blockReferenced, blockUsed, stmtReferenced, stmtDefined));
   }


   /**
    * Get all variables used inside a block and its successors (including any called method)
    * @param labelRef The block to examine
    * @param  visited The blocks already visited during the search. Used to stop infinite recursion
    * @return All used variables
    */
   private Collection<VariableRef> getUsed(LabelRef labelRef, Collection<LabelRef> visited) {
      if (labelRef == null) {
         return new ArrayList<>();
      }
      if (visited.contains(labelRef)) {
         return new ArrayList<>();
      }
      visited.add(labelRef);
      ControlFlowBlock block = getProgram().getGraph().getBlock(labelRef);
      if (block == null) {
         return new ArrayList<>();
      }
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      for (Statement statement : block.getStatements()) {
         used.addAll(getUsed(statement));
         if (statement instanceof StatementCall) {
            ProcedureRef procedure = ((StatementCall) statement).getProcedure();
            used.addAll(getUsed(procedure.getLabelRef(), visited));
         }
      }
      used.addAll(getUsed(block.getDefaultSuccessor(), visited));
      used.addAll(getUsed(block.getConditionalSuccessor(), visited));
      return used;
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    * @param labelRef The block to examine
    * @param  visited The blocks already visited during the search. Used to stop infinite recursion
    * @return All used variables
    */
   private Collection<VariableRef> getReferenced(LabelRef labelRef, Collection<LabelRef> visited) {
      if (labelRef == null) {
         return new ArrayList<>();
      }
      if (visited.contains(labelRef)) {
         return new ArrayList<>();
      }
      visited.add(labelRef);
      ControlFlowBlock block = getProgram().getGraph().getBlock(labelRef);
      if (block == null) {
         return new ArrayList<>();
      }
      LinkedHashSet<VariableRef> referenced = new LinkedHashSet<>();
      for (Statement statement : block.getStatements()) {
         referenced.addAll(getReferenced(statement));
         if (statement instanceof StatementCall) {
            ProcedureRef procedure = ((StatementCall) statement).getProcedure();
            referenced.addAll(getReferenced(procedure.getLabelRef(), visited));
         }
      }
      referenced.addAll(getReferenced(block.getDefaultSuccessor(), visited));
      referenced.addAll(getReferenced(block.getConditionalSuccessor(), visited));
      return referenced;
   }

   /**
    * Get the variables defined by a statement
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   private Collection<VariableRef> getDefined(Statement stmt) {
      if (stmt instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) stmt;
         LValue lValue = assignment.getlValue();
         if (lValue instanceof VariableRef) {
            return Arrays.asList((VariableRef) lValue);
         }
      } else if (stmt instanceof StatementPhiBlock) {
         List<VariableRef> defined = new ArrayList<>();
         StatementPhiBlock phi = (StatementPhiBlock) stmt;
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            defined.add(phiVariable.getVariable());
         }
         return defined;
      }
      return new ArrayList<>();
   }

   /**
    * Get the variables used, but not defined, in a statement
    * @param statement The statement to examine
    * @return The used variables (not including defined variables)
    */
   private  Collection<VariableRef> getUsed(Statement statement) {
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      used.addAll(getReferenced(statement));
      used.removeAll(getDefined(statement));
      return used;
   }

   /**
    * Get the variables referenced (used or defined) in a statement
    * @param statement The statement to examine
    * @return The referenced variables
    */
   private  Collection<VariableRef> getReferenced(Statement statement) {
      LinkedHashSet<VariableRef> referenced = new LinkedHashSet<>();
      if (statement instanceof StatementPhiBlock) {
         StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
         for (StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
            referenced.add(phiVariable.getVariable());
            for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
               referenced.addAll(getReferenced(phiRValue.getrValue()));
            }
         }
      } else if (statement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) statement;
         referenced.addAll(getReferenced(assignment.getlValue()));
         referenced.addAll(getReferenced(assignment.getrValue1()));
         referenced.addAll(getReferenced(assignment.getrValue2()));
      } else if (statement instanceof StatementConditionalJump) {
         StatementConditionalJump conditionalJump = (StatementConditionalJump) statement;
         referenced.addAll(getReferenced(conditionalJump.getrValue1()));
         referenced.addAll(getReferenced(conditionalJump.getrValue2()));
      } else if (statement instanceof StatementCall) {
         StatementCall call = (StatementCall) statement;
         referenced.addAll(getReferenced(call.getlValue()));
         if (call.getParameters() != null) {
            for (RValue param : call.getParameters()) {
               referenced.addAll(getReferenced(param));
            }
         }
      } else if (statement instanceof StatementReturn) {
         StatementReturn statementReturn = (StatementReturn) statement;
         referenced.addAll(getReferenced(statementReturn.getValue()));
      } else if (statement instanceof StatementAsm) {
         // No references in ASM atm.
      } else {
         throw new RuntimeException("Unknown statement type " + statement);
      }
      return referenced;
   }

   /**
    * Get all variables referenced in an rValue
    * @param rValue The rValue
    * @return All referenced variables
    */
   public static Collection<VariableRef> getReferenced(RValue rValue) {
      if (rValue == null) {
         return new ArrayList<>();
      } else if (rValue instanceof ConstantValue) {
         return new ArrayList<>();
      } else if (rValue instanceof PointerDereferenceSimple) {
         return getReferenced(((PointerDereferenceSimple) rValue).getPointer());
      } else if (rValue instanceof PointerDereferenceIndexed) {
         Collection<VariableRef> used = new LinkedHashSet<>();
         used.addAll(getReferenced(((PointerDereferenceIndexed) rValue).getPointer()));
         used.addAll(getReferenced(((PointerDereferenceIndexed) rValue).getIndex()));
         return used;
      } else if (rValue instanceof VariableRef) {
         return Arrays.asList((VariableRef) rValue);
      } else {
         throw new RuntimeException("Unhandled RValue type " + rValue);
      }
   }



}
