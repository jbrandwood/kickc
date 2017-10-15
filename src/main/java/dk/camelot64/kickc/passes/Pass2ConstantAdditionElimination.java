package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.Map;

/**
 * Compiler Pass eliminating several additions of constants by consolidating them to a single (compile time) constant c1+v+c2 => (c1+c2)+v
 *
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
   public boolean optimize() {
      boolean optimized = false;

      this.usages = countVarUsages();

      // Examine all assigments - performing constant consolidation
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getlValue() instanceof PointerDereferenceIndexed) {
                  optimized |= optimizePointerDereferenceIndexed(assignment);
               }
               Operator operator = assignment.getOperator();
               if (operator != null) {
                  switch (operator.getOperator()) {
                     case "+":
                        optimized |= optimizePlus(assignment);
                        break;
                     case "*idx":
                        optimized |= optimizeArrayDeref(assignment);
                        break;
                  }
               }
            }
         }
      }
      return optimized;
   }

   private boolean optimizePointerDereferenceIndexed(StatementAssignment assignment) {
      PointerDereferenceIndexed pointerDereferenceIndexed = (PointerDereferenceIndexed) assignment.getlValue();
      if(pointerDereferenceIndexed.getPointer() instanceof Constant && pointerDereferenceIndexed.getIndex() instanceof Constant) {
         Constant ptrConstant = (Constant) pointerDereferenceIndexed.getPointer();
         Constant idxConstant = (Constant) pointerDereferenceIndexed.getIndex();
         Constant newPtr = new ConstantBinary(ptrConstant, Operator.PLUS, idxConstant);
         assignment.setlValue(new PointerDereferenceSimple(newPtr));
         getLog().append("Consolidated assigned array index constant in assignment " + assignment.getlValue());
         return true;
      }
      if(pointerDereferenceIndexed.getPointer() instanceof Constant && pointerDereferenceIndexed.getIndex() instanceof VariableRef) {
         VariableRef variable = (VariableRef) pointerDereferenceIndexed.getIndex();
         Constant consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            Constant ptrConstant = (Constant) pointerDereferenceIndexed.getPointer();
            Constant newPtr = new ConstantBinary(ptrConstant, Operator.PLUS, consolidated);
            pointerDereferenceIndexed.setPointer(newPtr);
            getLog().append("Consolidated assigned array index constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizeArrayDeref(StatementAssignment assignment) {
      if (assignment.getrValue1() instanceof Constant && assignment.getrValue2() instanceof Constant) {
         Constant ptrConstant = (Constant) assignment.getrValue1();
         Constant idxConstant = (Constant) assignment.getrValue2();
         Constant newPtr = new ConstantBinary(ptrConstant, Operator.PLUS, idxConstant);
         assignment.setrValue1(null);
         assignment.setOperator(Operator.STAR);
         assignment.setrValue2(newPtr);
         getLog().append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
         return true;
      }
      if (assignment.getrValue1() instanceof Constant && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         Constant consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            Constant ptrConstant = (Constant) assignment.getrValue1();
            Constant newPtr = new ConstantBinary(ptrConstant, Operator.PLUS, consolidated);
            assignment.setrValue1(newPtr);
            getLog().append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizePlus(StatementAssignment assignment) {
      if (assignment.getrValue1() instanceof Constant && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         Constant consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            Constant const1 = (Constant) assignment.getrValue1();
            assignment.setrValue1(new ConstantBinary(const1, Operator.PLUS, consolidated));
            getLog().append("Consolidated constant in assignment " + assignment.getlValue());
            return true;
         }
      } else if (assignment.getrValue1() instanceof VariableRef && assignment.getrValue2() instanceof Constant) {
         VariableRef variable = (VariableRef) assignment.getrValue1();
         Constant consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            Constant const2 = (Constant) assignment.getrValue2();
            Constant newNumber = new ConstantBinary(consolidated, Operator.PLUS, const2);
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
   private Constant consolidateSubConstants(VariableRef variable) {
      if(getUsages(variable) >1) {
         getLog().append("Multiple usages for variable. Not optimizing sub-constant "+variable.toString(getProgram()));
         return null;
      }
      StatementAssignment assignment = getGraph().getAssignment(variable);
      if (assignment != null && assignment.getOperator() != null && "+".equals(assignment.getOperator().getOperator())) {
         if (assignment.getrValue1() instanceof Constant) {
            Constant constant = (Constant) assignment.getrValue1();
            assignment.setrValue1(null);
            assignment.setOperator(null);
            return constant;
         } else if (assignment.getrValue2() instanceof Constant) {
            Constant constant = (Constant) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return constant;
         } else {
            Constant const1 = null;
            if (assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            Constant const2 = null;
            if (assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            Constant result = null;
            if (const1 != null) {
               result = const1;
               if (const2 != null) {
                  result = new ConstantBinary(const1, Operator.PLUS, const2);
               }
            } else if (const2 != null) {
               result = const2;
            }
            return result;
         }
      }
      if (assignment != null && assignment.getOperator() != null && "-".equals(assignment.getOperator().getOperator())) {
         if (assignment.getrValue1() instanceof Constant) {
            Constant constant = (Constant) assignment.getrValue1();
            assignment.setrValue1(null);
            return constant;
         } else if (assignment.getrValue2() instanceof Constant) {
            Constant constant = (Constant) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return new ConstantUnary(Operator.MINUS, constant);
         } else {
            Constant const1 = null;
            if (assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            Constant const2 = null;
            if (assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            Constant result = null;
            if (const1 != null) {
               result = const1;
               if (const2 != null) {
                  result = new ConstantBinary(const1, Operator.MINUS,const2);
               }
            } else if (const2 != null) {
               result = const2;
            }
            return result;
         }
      }
      return null;
   }

   private Integer getUsages(VariableRef variable) {
      Integer useCount = usages.get(variable);
      if(useCount==null) useCount = 0;
      return useCount;
   }

}
