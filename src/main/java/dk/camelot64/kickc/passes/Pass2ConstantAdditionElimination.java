package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementConditionalJump;

import java.util.Map;

/**
 * Compiler Pass eliminating several additions of constants by consolidating them to a single (compile time) constant c1+v+c2 => (c1+c2)+v
 * <p>
 * TODO:
 * - If sub variable is used in other places consolidation is not allowed!
 * Example: With only a & b the constants c1 & c2 could be consolidated to b=(c1+c2)+a, a=v. Since c also uses a this is not an option.
 * a = c1 + v
 * b = c2 + a
 * c = a + c3
 */
public class Pass2ConstantAdditionElimination extends Pass2SsaOptimization {

   private Map<VariableRef, Integer> usages;

   public Pass2ConstantAdditionElimination(Program program) {
      super(program);
   }

   /**
    * For assignments with a constant part the variable part is examined looking for constants to consolidate into the constant.
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      boolean optimized = false;

      this.usages = countVarUsages();

      // Examine all assignments - performing constant consolidation
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(new ProgramValue.LValue(assignment));
               }
               if(assignment.getrValue1() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(new ProgramValue.RValue1(assignment));
               }
               if(assignment.getrValue2() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(new ProgramValue.RValue2(assignment));
               }

               Operator operator = assignment.getOperator();
               if(operator != null) {
                  switch(operator.getOperator()) {
                     case "+":
                        optimized |= optimizePlus(assignment);
                        break;
                     case "*idx":
                        optimized |= optimizeArrayDeref(assignment);
                        break;
                  }
               }
            } else if(statement instanceof StatementConditionalJump) {
               StatementConditionalJump jump = (StatementConditionalJump) statement;
               if(jump.getrValue1() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(new ProgramValue.CondRValue1(jump));
               }
               if(jump.getrValue2() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(new ProgramValue.CondRValue2(jump));
               }
            }
         }
      }
      return optimized;
   }

   private boolean optimizePointerDereferenceIndexed(ProgramValue value) {
      PointerDereferenceIndexed pointerDereferenceIndexed = (PointerDereferenceIndexed) value.get();
      if(pointerDereferenceIndexed.getPointer() instanceof ConstantValue && pointerDereferenceIndexed.getIndex() instanceof ConstantValue) {
         ConstantValue ptrConstant = (ConstantValue) pointerDereferenceIndexed.getPointer();
         ConstantValue idxConstant = (ConstantValue) pointerDereferenceIndexed.getIndex();
         ConstantValue newPtr = new ConstantBinary(ptrConstant, Operators.PLUS, idxConstant);
         value.set(new PointerDereferenceSimple(newPtr));
         getLog().append("Consolidated array index constant in " + value.get().toString());
         return true;
      }
      if(pointerDereferenceIndexed.getPointer() instanceof ConstantValue && pointerDereferenceIndexed.getIndex() instanceof VariableRef) {
         VariableRef variable = (VariableRef) pointerDereferenceIndexed.getIndex();
         ConstantValue consolidated = consolidateSubConstants(variable);
         if(consolidated != null) {
            ConstantValue ptrConstant = (ConstantValue) pointerDereferenceIndexed.getPointer();
            ConstantValue newPtr = new ConstantBinary(ptrConstant, Operators.PLUS, consolidated);
            pointerDereferenceIndexed.setPointer(newPtr);
            getLog().append("Consolidated array index constant in assignment " + value.get().toString());
            return true;
         }
      }
      return false;
   }

   private boolean optimizeArrayDeref(StatementAssignment assignment) {
      if(assignment.getrValue1() instanceof ConstantValue && assignment.getrValue2() instanceof ConstantValue) {
         ConstantValue ptrConstant = (ConstantValue) assignment.getrValue1();
         ConstantValue idxConstant = (ConstantValue) assignment.getrValue2();
         ConstantValue newPtr = new ConstantBinary(ptrConstant, Operators.PLUS, idxConstant);
         assignment.setrValue1(null);
         assignment.setOperator(Operators.DEREF);
         assignment.setrValue2(newPtr);
         getLog().append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
         return true;
      }
      if(assignment.getrValue1() instanceof ConstantValue && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         ConstantValue consolidated = consolidateSubConstants(variable);
         if(consolidated != null) {
            ConstantValue ptrConstant = (ConstantValue) assignment.getrValue1();
            ConstantValue newPtr = new ConstantBinary(ptrConstant, Operators.PLUS, consolidated);
            assignment.setrValue1(newPtr);
            getLog().append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizePlus(StatementAssignment assignment) {
      if(assignment.getrValue1() instanceof ConstantValue && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         ConstantValue consolidated = consolidateSubConstants(variable);
         if(consolidated != null) {
            ConstantValue const1 = (ConstantValue) assignment.getrValue1();
            assignment.setrValue1(new ConstantBinary(const1, Operators.PLUS, consolidated));
            getLog().append("Consolidated constant in assignment " + assignment.getlValue());
            return true;
         }
      } else if(assignment.getrValue1() instanceof VariableRef && assignment.getrValue2() instanceof ConstantValue) {
         VariableRef variable = (VariableRef) assignment.getrValue1();
         ConstantValue consolidated = consolidateSubConstants(variable);
         if(consolidated != null) {
            ConstantValue const2 = (ConstantValue) assignment.getrValue2();
            ConstantValue newNumber = new ConstantBinary(consolidated, Operators.PLUS, const2);
            assignment.setrValue2(newNumber);
            // Handling of negative consolidated numbers?
            getLog().append("Consolidated constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   /**
    * Gather up constants from sub addition expressions of a variable, remove them there, and return the aggregated sum.
    *
    * @param variable The variable to examine
    * @return The consolidated constant. Null if no sub-constants were found, or if the constants cannot be consolidated.
    */
   private ConstantValue consolidateSubConstants(VariableRef variable) {
      if(getUsages(variable) > 1) {
         //getLog().append("Multiple usages for variable. Not optimizing sub-constant " + variable.toString(getProgram()));
         return null;
      }
      StatementAssignment assignment = getGraph().getAssignment(variable);
      if(assignment != null && assignment.getOperator() != null && "+".equals(assignment.getOperator().getOperator())) {
         if(assignment.getrValue1() instanceof ConstantValue) {
            ConstantValue constant = (ConstantValue) assignment.getrValue1();
            assignment.setrValue1(null);
            assignment.setOperator(null);
            return constant;
         } else if(assignment.getrValue2() instanceof ConstantValue) {
            ConstantValue constant = (ConstantValue) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return constant;
         } else {
            ConstantValue const1 = null;
            if(assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            ConstantValue const2 = null;
            if(assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            ConstantValue result = null;
            if(const1 != null) {
               result = const1;
               if(const2 != null) {
                  result = new ConstantBinary(const1, Operators.PLUS, const2);
               }
            } else if(const2 != null) {
               result = const2;
            }
            return result;
         }
      }
      if(assignment != null && assignment.getOperator() != null && "-".equals(assignment.getOperator().getOperator())) {
         if(assignment.getrValue1() instanceof ConstantValue) {
            ConstantValue constant = (ConstantValue) assignment.getrValue1();
            assignment.setrValue1(null);
            return constant;
         } else if(assignment.getrValue2() instanceof ConstantValue) {
            ConstantValue constant = (ConstantValue) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return new ConstantUnary(Operators.NEG, constant);
         } else {
            ConstantValue const1 = null;
            if(assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            ConstantValue const2 = null;
            if(assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            ConstantValue result = null;
            if(const1 != null) {
               result = const1;
               if(const2 != null) {
                  result = new ConstantBinary(const1, Operators.MINUS, const2);
               }
            } else if(const2 != null) {
               result = const2;
            }
            return result;
         }
      }
      return null;
   }

   private Integer getUsages(VariableRef variable) {
      Integer useCount = usages.get(variable);
      if(useCount == null) useCount = 0;
      return useCount;
   }

}
