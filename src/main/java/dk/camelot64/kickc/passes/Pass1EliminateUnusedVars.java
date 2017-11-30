package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * Eliminate unused variables
 */
public class Pass1EliminateUnusedVars extends Pass1Base {

   public Pass1EliminateUnusedVars(Program program) {
      super(program);
   }

   @Override
   boolean executeStep() {
      Collection<RValue> allUsedVars = getAllVarUsage();

      boolean modified = false;
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while (stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if (lValue instanceof VariableRef && !allUsedVars.contains(lValue)) {
                  getLog().append("Eliminating unused variable "+ lValue.toString(getProgram()) + " and assignment "+ assignment.toString(getProgram(), false));
                  stmtIt.remove();
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  modified = true;
               }
            } else if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               LValue lValue = call.getlValue();
               if(lValue instanceof VariableRef && !allUsedVars.contains(lValue)) {
                  getLog().append("Eliminating unused variable - keeping the call "+ lValue.toString(getProgram()));
                  Variable variable = getScope().getVariable((VariableRef) lValue);
                  variable.getScope().remove(variable);
                  call.setlValue(null);
                  modified = true;
               }
            }
         }
      }
      return modified;
   }

   /**
    * Get all Variable or Constant usage in RValues.
    *
    * @return Collection containing VariableRef and ConstantRef for all used vars/constants.
    */
   private Collection<RValue> getAllVarUsage() {
      Collection<RValue> allRvalues = new LinkedHashSet<>();
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               addLvalueUses(allRvalues, ((StatementAssignment) statement).getlValue());
               addRvalueUses(allRvalues, ((StatementAssignment) statement).getrValue1());
               addRvalueUses(allRvalues, ((StatementAssignment) statement).getrValue2());
            } else if (statement instanceof StatementCall) {
               addLvalueUses(allRvalues, ((StatementCall) statement).getlValue());
               for (RValue param : ((StatementCall) statement).getParameters()) {
                  addRvalueUses(allRvalues, param);
               }
            } else if (statement instanceof StatementConditionalJump) {
               addRvalueUses(allRvalues, ((StatementConditionalJump) statement).getrValue1());
               addRvalueUses(allRvalues, ((StatementConditionalJump) statement).getrValue2());
            } else if (statement instanceof StatementReturn) {
               addRvalueUses(allRvalues, ((StatementReturn) statement).getValue());
            } else if (statement instanceof StatementPhiBlock) {
               for (StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  addLvalueUses(allRvalues, phiVariable.getVariable());
                  for (StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     addRvalueUses(allRvalues, phiRValue.getrValue());
                  }
               }
            }
         }
      }
      return allRvalues;
   }

   private void addLvalueUses(Collection<RValue> allUses, LValue lValue) {
      if (lValue == null) {
         return;
      } else if (lValue instanceof VariableRef) {
         return;
      } else if (lValue instanceof LvalueLoHiByte) {
         addRvalueUses(allUses, ((LvalueLoHiByte) lValue).getVariable());
      } else if (lValue instanceof PointerDereferenceSimple) {
         addRvalueUses(allUses, ((PointerDereference) lValue).getPointer());
      } else if (lValue instanceof PointerDereferenceIndexed) {
         addRvalueUses(allUses, ((PointerDereferenceIndexed) lValue).getPointer());
         addRvalueUses(allUses, ((PointerDereferenceIndexed) lValue).getIndex());
      } else {
         throw new RuntimeException("Unknown LValue type " + lValue);
      }
   }

   private void addRvalueUses(Collection<RValue> allUses, RValue rValue) {
      if (rValue == null) {
         return;
      } else if (rValue instanceof VariableRef || rValue instanceof ConstantRef) {
         allUses.add(rValue);
      } else if (rValue instanceof LValue) {
         addLvalueUses(allUses, (LValue) rValue);
      } else if (rValue instanceof ConstantString || rValue instanceof ConstantInteger || rValue instanceof ConstantBool || rValue instanceof ConstantChar || rValue instanceof ConstantDouble) {
         return;
      } else if (rValue instanceof ConstantArray) {
         for (ConstantValue constantValue : ((ConstantArray) rValue).getElements()) {
            addRvalueUses(allUses, constantValue);
         }
      } else if (rValue instanceof ValueArray) {
         for (RValue value : ((ValueArray) rValue).getList()) {
            addRvalueUses(allUses, value);
         }
      } else if (rValue instanceof ConstantUnary) {
         addRvalueUses(allUses, ((ConstantUnary) rValue).getOperand());
      } else if (rValue instanceof ConstantBinary) {
         addRvalueUses(allUses, ((ConstantBinary) rValue).getLeft());
         addRvalueUses(allUses, ((ConstantBinary) rValue).getRight());
      } else {
         throw new RuntimeException("Unknown RValue type " + rValue);
      }
   }

}
