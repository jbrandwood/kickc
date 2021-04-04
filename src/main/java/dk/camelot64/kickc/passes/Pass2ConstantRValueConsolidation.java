package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantSymbolPointer;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.SymbolRef;

/**
 * Compiler Pass consolidating R-values that are constant into a single {@link ConstantValue}
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
      } else if(Operators.BYTE1.equals(assignment.getOperator()) && assignment.getrValue1() == null) {
         final SymbolType rVal2Type = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
         if(SymbolType.isInteger(rVal2Type) && rVal2Type.getSizeBytes() < 2)
            return new ConstantInteger(0l, SymbolType.BYTE);
      } else if(Operators.BYTE2.equals(assignment.getOperator()) && assignment.getrValue1() == null) {
         final SymbolType rVal2Type = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
         if(SymbolType.isInteger(rVal2Type) && rVal2Type.getSizeBytes() < 3)
            return new ConstantInteger(0l, SymbolType.BYTE);
         else if(rVal2Type instanceof SymbolTypePointer)
            return new ConstantInteger(0l, SymbolType.BYTE);
      } else if(Operators.BYTE3.equals(assignment.getOperator()) && assignment.getrValue1() == null) {
         final SymbolType rVal2Type = SymbolTypeInference.inferType(getScope(), assignment.getrValue2());
         if(SymbolType.isInteger(rVal2Type) && rVal2Type.getSizeBytes() < 4)
            return new ConstantInteger(0l, SymbolType.BYTE);
         else if(rVal2Type instanceof SymbolTypePointer)
            return new ConstantInteger(0l, SymbolType.BYTE);
      } else if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && assignment.getrValue1() == null) {
         // Constant address-of variable
         if(assignment.getrValue2() instanceof SymbolRef) {
            return new ConstantSymbolPointer((SymbolRef) assignment.getrValue2());
         }
      }
      return null;
   }

}
