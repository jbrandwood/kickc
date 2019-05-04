package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Compiler Pass consolidating L-values that are constant into a single {@link ConstantValue}
 */
public class Pass2ConstantRValueConsolidation extends Pass2SsaOptimization {

   public Pass2ConstantRValueConsolidation(Program program) {
      super(program);
   }

   /**
    * Propagate constants, replacing variables with constants where possible.
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue1() != null || assignment.getOperator() != null || !(assignment.getrValue2() instanceof ConstantValue)) {
                  SymbolType lValueType = SymbolTypeInference.inferType(getScope(), assignment.getlValue());
                  ConstantValue constant = getConstantAssignmentValue(assignment, lValueType);
                  if(constant != null) {
                     getLog().append("Constant right-side identified " + assignment.toString(getProgram(), false));
                     assignment.setrValue2(constant);
                     assignment.setOperator(null);
                     assignment.setrValue1(null);
                     modified = true;
                  }
               }
            }
         }
      }
      return modified;
   }

   /**
    * Examine the right side of an assignment and if it is constant then return the constant value.
    *
    * @param assignment The assignment to examine
    * @param lValueType The type of the lvalue
    * @return The constant value if the right side is constant
    */
   private ConstantValue getConstantAssignmentValue(StatementAssignment assignment, SymbolType lValueType) {

      if(assignment.getrValue1() == null && Pass2ConstantIdentification.getConstant(assignment.getrValue2()) != null) {
         if(assignment.getOperator() == null) {
            // Constant assignment
            return Pass2ConstantIdentification.getConstant(assignment.getrValue2());
         } else {
            // Constant unary expression
            return Pass2ConstantIdentification.createUnary(
                  (OperatorUnary) assignment.getOperator(),
                  Pass2ConstantIdentification.getConstant(assignment.getrValue2())
            );
         }
      } else if(Pass2ConstantIdentification.getConstant(assignment.getrValue1()) != null && Pass2ConstantIdentification.getConstant(assignment.getrValue2()) != null) {
         // Constant binary expression
         return Pass2ConstantIdentification.createBinary(
               Pass2ConstantIdentification.getConstant(assignment.getrValue1()),
               (OperatorBinary) assignment.getOperator(),
               Pass2ConstantIdentification.getConstant(assignment.getrValue2()),
               getScope());
      } else if(assignment.getrValue2() instanceof ValueList && assignment.getOperator() == null && assignment.getrValue1() == null) {
         // A candidate for a constant list - examine to confirm
         if(lValueType instanceof SymbolTypeArray) {
            ValueList valueList = (ValueList) assignment.getrValue2();
            List<RValue> values = valueList.getList();
            boolean allConstant = true;
            // Type of the elements of the list (deducted from the type of all elements)
            SymbolType listType = null;
            List<ConstantValue> elements = new ArrayList<>();
            for(RValue elmValue : values) {
               if(elmValue instanceof ConstantValue) {
                  ConstantValue constantValue = (ConstantValue) elmValue;
                  SymbolType elmType = constantValue.getType(getScope());
                  if(listType == null) {
                     listType = elmType;
                  } else {
                     if(!listType.equals(elmType)) {
                        // No overlap between list type and element type
                        throw new RuntimeException("Array type " + listType + " does not match element type" + elmType + ". Array: " + valueList.toString(getProgram()));
                     }
                  }
                  elements.add(constantValue);
               } else {
                  allConstant = false;
                  listType = null;
                  break;
               }
            }
            if(allConstant && listType != null) {
               // Constant list confirmed!
               return new ConstantArrayList(elements, listType);
            }
         }
      } else if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && assignment.getrValue1() == null) {
         // Constant address-of variable
         if(assignment.getrValue2() instanceof SymbolRef) {
            return new ConstantSymbolPointer((SymbolRef) assignment.getrValue2());
         }
      }
      return null;
   }

}
