package dk.camelot64.kickc.icl;

/**
 * Compiler Pass eliminating several additions of constants by consolidating them to a  single (compile time) constant c1+v+c2 => (c1+c2)+v
 */
public class Pass2ConstantAdditionElimination extends Pass2SsaOptimization {

   public Pass2ConstantAdditionElimination(ControlFlowGraph graph, Scope scope) {
      super(graph, scope);
   }

   /**
    * For assignments with a constant part the variable part is examined looking for constants to consolidate into the constant.
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      boolean optimized = false;
      // Examine all assigments - performing constant consolidation
      for (ControlFlowBlock block : getGraph().getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getLValue() instanceof PointerDereferenceIndexed) {
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
      PointerDereferenceIndexed pointerDereferenceIndexed = (PointerDereferenceIndexed) assignment.getLValue();
      if(pointerDereferenceIndexed.getPointer() instanceof ConstantInteger && pointerDereferenceIndexed.getIndex() instanceof Variable) {
         Variable variable = (Variable) pointerDereferenceIndexed.getIndex();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger ptrConstant = (ConstantInteger) pointerDereferenceIndexed.getPointer();
            int newPtr = ptrConstant.getNumber() + consolidated.getNumber();
            pointerDereferenceIndexed.setPointer(new ConstantInteger(newPtr));
            System.out.println("Consolidated assigned array index constant in assignment " + assignment.getLValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizeArrayDeref(StatementAssignment assignment) {
      if (assignment.getRValue1() instanceof ConstantInteger && assignment.getRValue2() instanceof Variable) {
         Variable variable = (Variable) assignment.getRValue2();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger ptrConstant = (ConstantInteger) assignment.getRValue1();
            int newPtr = ptrConstant.getNumber() + consolidated.getNumber();
               assignment.setRValue1(new ConstantInteger(newPtr));
            System.out.println("Consolidated referenced array index constant in assignment " + assignment.getLValue());
            return true;
         }
      }
      return false;
   }

   private boolean optimizePlus(StatementAssignment assignment) {
      if (assignment.getRValue1() instanceof ConstantInteger && assignment.getRValue2() instanceof Variable) {
         Variable variable = (Variable) assignment.getRValue2();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger const1 = (ConstantInteger) assignment.getRValue1();
            assignment.setRValue1(new ConstantInteger(const1.getNumber() + consolidated.getNumber()));
            System.out.println("Consolidated constant in assignment " + assignment.getLValue());
            return true;
         }
      } else if (assignment.getRValue1() instanceof Variable && assignment.getRValue2() instanceof ConstantInteger) {
         Variable variable = (Variable) assignment.getRValue1();
         ConstantInteger consolidated = consolidateSubConstants(variable);
         if (consolidated != null) {
            ConstantInteger const2 = (ConstantInteger) assignment.getRValue2();
            int newNumber = const2.getNumber() + consolidated.getNumber();
            if (newNumber < 0) {
               assignment.setRValue2(new ConstantInteger(-newNumber));
               assignment.setOperator(new Operator("-"));
            } else {
               assignment.setRValue2(new ConstantInteger(newNumber));
            }
            System.out.println("Consolidated constant in assignment " + assignment.getLValue());
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
   private ConstantInteger consolidateSubConstants(Variable variable) {
      StatementAssignment assignment = getGraph().getAssignment(variable);
      if (assignment != null && assignment.getOperator() != null && "+".equals(assignment.getOperator().getOperator())) {
         if (assignment.getRValue1() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getRValue1();
            assignment.setRValue1(null);
            assignment.setOperator(null);
            return constant;
         } else if (assignment.getRValue2() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getRValue2();
            assignment.setRValue2(assignment.getRValue1());
            assignment.setOperator(null);
            assignment.setRValue1(null);
            return constant;
         } else {
            ConstantInteger const1 = null;
            if (assignment.getRValue1() instanceof Variable) {
               const1 = consolidateSubConstants((Variable) assignment.getRValue1());
            }
            ConstantInteger const2 = null;
            if (assignment.getRValue2() instanceof Variable) {
               const2 = consolidateSubConstants((Variable) assignment.getRValue2());
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
         if (assignment.getRValue1() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getRValue1();
            assignment.setRValue1(null);
            return constant;
         } else if (assignment.getRValue2() instanceof ConstantInteger) {
            ConstantInteger constant = (ConstantInteger) assignment.getRValue2();
            assignment.setRValue2(assignment.getRValue1());
            assignment.setOperator(null);
            assignment.setRValue1(null);
            return new ConstantInteger(-constant.getNumber());
         } else {
            ConstantInteger const1 = null;
            if (assignment.getRValue1() instanceof Variable) {
               const1 = consolidateSubConstants((Variable) assignment.getRValue1());
            }
            ConstantInteger const2 = null;
            if (assignment.getRValue2() instanceof Variable) {
               const2 = consolidateSubConstants((Variable) assignment.getRValue2());
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

}
