package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.icl.*;

import java.util.LinkedHashMap;
import java.util.Map;

/** Compiler Pass propagating constants in expressions eliminating constant variables */
public class Pass2ConstantPropagation extends Pass2SsaOptimization {

   public Pass2ConstantPropagation(Program program, CompileLog log) {
      super(program, log);
   }

   /**
    * Propagate constants, replacing variables with constants where possible.
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      final Map<VariableRef, Constant> constants = findConstantVariables();
      for (VariableRef constantVar : constants.keySet()) {
         Constant constantValue = constants.get(constantVar);
         log.append("Constant " + constantVar.toString(getSymbols()) + " " + constantValue.toString(getSymbols()));
      }
      removeAssignments(constants.keySet());
      deleteVariables(constants.keySet());
      replaceVariables(constants);
      return constants.size() > 0;
   }

   /**
    * Find variables that have constant values.
    * @return Map from Variable to the Constant value
    */
   private Map<VariableRef, Constant> findConstantVariables() {
      final Map<VariableRef, Constant> constants = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if (assignment.getlValue() instanceof VariableRef ) {
               VariableRef variable = (VariableRef) assignment.getlValue();
               if (assignment.getrValue1() == null && assignment.getrValue2() instanceof Constant) {
                  if (assignment.getOperator() == null) {
                     // Constant assignment
                     Constant constant = (Constant) assignment.getrValue2();
                     constants.put(variable, constant);
                  } else {
                     // Constant unary expression
                     Constant constant = calculateUnary(assignment.getOperator(), (Constant) assignment.getrValue2());
                     if(constant!=null) {
                        constants.put(variable, constant);
                     }
                  }
               } else if (assignment.getrValue1() instanceof Constant && assignment.getrValue2() instanceof Constant) {
                  // Constant binary expression
                  Constant constant = calculateBinary(
                        assignment.getOperator(),
                        (Constant) assignment.getrValue1(),
                        (Constant) assignment.getrValue2());
                  if(constant!=null) {
                     constants.put(variable, constant);
                  }
               }
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               if(phiVariable.getValues().size()==1) {
                  StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
                  if (phiRValue.getrValue() instanceof Constant) {
                     VariableRef variable = phiVariable.getVariable();
                     Constant constant = (Constant) phiRValue.getrValue();
                     constants.put(variable, constant);
                  }
               }
            }
            return null;
         }


      };
      visitor.visitGraph(getGraph());
      return constants;
   }


   public static Constant calculateBinary(Operator operator, Constant c1, Constant c2) {
      switch (operator.getOperator()) {
         case "-": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) - getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) - getDouble(c2));
            }
         }
         case "+": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) + getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) + getDouble(c2));
            }
         }
         case "*": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) * getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) * getDouble(c2));
            }
         }
         case "/": {
            if (c1 instanceof ConstantInteger && c2 instanceof ConstantInteger) {
               return new ConstantInteger(getInteger(c1) / getInteger(c2));
            } else {
               return new ConstantDouble(getDouble(c1) / getDouble(c2));
            }
         }
         case "*idx": {
            // Cannot be directly propagated
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Binary Operator " + operator.getOperator());
      }
   }

   private static Integer getInteger(Constant constant) {
      if (constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getNumber();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not an integer number " + constant);
      }
   }

   private static Double getDouble(Constant constant) {
      if (constant instanceof ConstantDouble) {
         return ((ConstantDouble) constant).getNumber();
      } else if (constant instanceof ConstantInteger) {
         return ((ConstantInteger) constant).getNumber().doubleValue();
      } else {
         throw new RuntimeException("Type Mismatch. Constant is not a number " + constant);
      }
   }

   public static Constant calculateUnary(Operator operator, Constant c) {
      switch (operator.getOperator()) {
         case "-": {
            if (c instanceof ConstantInteger) {
               ConstantInteger cInt = (ConstantInteger) c;
               return new ConstantInteger(-cInt.getNumber());
            } else if (c instanceof ConstantDouble) {
               ConstantDouble cDoub = (ConstantDouble) c;
               return new ConstantDouble(-cDoub.getNumber());
            } else {
               throw new RuntimeException("Type mismatch. Unary Minus cannot handle value " + c);
            }
         }
         case "+": {
            return c;
         }
         case "++": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getNumber()+1);
         }
         case "--": {
            ConstantInteger cInt = (ConstantInteger) c;
            return new ConstantInteger(cInt.getNumber()-1);
         }
         case "*": { // pointer dereference
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

}
