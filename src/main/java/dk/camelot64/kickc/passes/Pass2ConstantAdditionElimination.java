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

   public Pass2ConstantAdditionElimination(Program program, CompileLog log) {
      super(program, log);
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
      if(pointerDereferenceIndexed.getPointer() instanceof ConstantInteger && pointerDereferenceIndexed.getIndex() instanceof Constant) {
         ConstantInteger ptrConstant = (ConstantInteger) pointerDereferenceIndexed.getPointer();
         ConstantInteger idxConstant = (ConstantInteger) pointerDereferenceIndexed.getIndex();
         int newPtr = ptrConstant.getNumber() + idxConstant.getNumber();
         assignment.setlValue(new PointerDereferenceSimple(new ConstantInteger(newPtr)));
         log.append("Consolidated assigned array index constant in assignment " + assignment.getlValue());
         return true;
      }
      if(pointerDereferenceIndexed.getPointer() instanceof ConstantInteger && pointerDereferenceIndexed.getIndex() instanceof VariableRef) {
         VariableRef variable = (VariableRef) pointerDereferenceIndexed.getIndex();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger ptrConstant = (ConstantInteger) pointerDereferenceIndexed.getPointer();
            int newPtr = ptrConstant.getNumber() + consolidated.getNumber();
            pointerDereferenceIndexed.setPointer(new ConstantInteger(newPtr));
            log.append("Consolidated assigned array index constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizeArrayDeref(StatementAssignment assignment) {
      if (assignment.getrValue1() instanceof ConstantInteger && assignment.getrValue2() instanceof ConstantInteger) {
         ConstantInteger ptrConstant = (ConstantInteger) assignment.getrValue1();
         ConstantInteger idxConstant = (ConstantInteger) assignment.getrValue2();
         int newPtr = ptrConstant.getNumber() + idxConstant.getNumber();
         assignment.setrValue1(null);
         assignment.setOperator(new Operator("*"));
         assignment.setrValue2(new ConstantInteger(newPtr));
         log.append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
         return true;
      }
      if (assignment.getrValue1() instanceof ConstantInteger && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger ptrConstant = (ConstantInteger) assignment.getrValue1();
            int newPtr = ptrConstant.getNumber() + consolidated.getNumber();
            assignment.setrValue1(new ConstantInteger(newPtr));
            log.append("Consolidated referenced array index constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizePlus(StatementAssignment assignment) {
      if (assignment.getrValue1() instanceof ConstantInteger && assignment.getrValue2() instanceof VariableRef) {
         VariableRef variable = (VariableRef) assignment.getrValue2();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger const1 = (ConstantInteger) assignment.getrValue1();
            assignment.setrValue1(new ConstantInteger(const1.getNumber() + consolidated.getNumber()));
            log.append("Consolidated constant in assignment " + assignment.getlValue());
            return true;
         }
      } else if (assignment.getrValue1() instanceof VariableRef && assignment.getrValue2() instanceof ConstantInteger) {
         VariableRef variable = (VariableRef) assignment.getrValue1();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger const2 = (ConstantInteger) assignment.getrValue2();
            int newNumber = const2.getNumber() + consolidated.getNumber();
            if (newNumber < 0) {
               assignment.setrValue2(new ConstantInteger(-newNumber));
               assignment.setOperator(new Operator("-"));
            } else {
               assignment.setrValue2(new ConstantInteger(newNumber));
            }
            log.append("Consolidated constant in assignment " + assignment.getlValue());
            return true;
         }
      }
      return false;
   }

   /**
    * Gather up constants from sub addition expressions of a variable, remove them there, and return the aggregated sum.
    *
    * @param variable The variable to examine
    * @return The consolidated constant. Null if no sub-constants were found.
    */
   private ConstantInteger consolidateSubConstants(VariableRef variable) {
      if(getUsages(variable) >1) {
         log.append("Multiple usages for variable. Not optimizing sub-constant "+variable.toString(getSymbols()));
         return null;
      }
      Variable var = getSymbols().getVariable(variable);
      StatementAssignment assignment = getGraph().getAssignment(variable);
      if (assignment != null && assignment.getOperator() != null && "+".equals(assignment.getOperator().getOperator())) {
         if (assignment.getrValue1() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getrValue1();
            assignment.setrValue1(null);
            assignment.setOperator(null);
            return constant;
         } else if (assignment.getrValue2() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return constant;
         } else {
            ConstantInteger const1 = null;
            if (assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            ConstantInteger const2 = null;
            if (assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            ConstantInteger result = null;
            if (const1 != null) {
               result = const1;
               if (const2 != null) {
                  result = new ConstantInteger(const1.getNumber() + const2.getNumber());
               }
            } else if (const2 != null) {
               result = const2;
            }
            return result;
         }
      }
      if (assignment != null && assignment.getOperator() != null && "-".equals(assignment.getOperator().getOperator())) {
         if (assignment.getrValue1() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getrValue1();
            assignment.setrValue1(null);
            return constant;
         } else if (assignment.getrValue2() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getrValue2();
            assignment.setrValue2(assignment.getrValue1());
            assignment.setOperator(null);
            assignment.setrValue1(null);
            return new ConstantInteger(-constant.getNumber());
         } else {
            ConstantInteger const1 = null;
            if (assignment.getrValue1() instanceof VariableRef) {
               const1 = consolidateSubConstants((VariableRef) assignment.getrValue1());
            }
            ConstantInteger const2 = null;
            if (assignment.getrValue2() instanceof VariableRef) {
               const2 = consolidateSubConstants((VariableRef) assignment.getrValue2());
            }
            ConstantInteger result = null;
            if (const1 != null) {
               result = const1;
               if (const2 != null) {
                  result = new ConstantInteger(const1.getNumber() - const2.getNumber());
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
