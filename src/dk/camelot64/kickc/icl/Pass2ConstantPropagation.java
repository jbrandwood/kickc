package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/** Compiler Pass propagating constants in expressions eliminating constant variables */
public class Pass2ConstantPropagation extends Pass2SsaOptimization {

   public Pass2ConstantPropagation(ControlFlowGraph graph, SymbolTable symbolTable) {
      super(graph, symbolTable);
   }

   /**
    * Propagate constants, replacing variables with constants where possible.
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      final Map<Variable, Constant> constants = findConstantVariables();
      for (Variable constantVar : constants.keySet()) {
         Constant constantValue = constants.get(constantVar);
         System.out.println("Constant " + constantVar + " " + constantValue);
      }
      removeAssignments(constants.keySet());
      deleteSymbols(constants.keySet());
      replaceVariables(constants);
      return constants.size() > 0;
   }

   /**
    * Find variables that have constant values.
    * @return Map from Variable to the Constant value
    */
   private Map<Variable, Constant> findConstantVariables() {
      final Map<Variable, Constant> constants = new HashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            if (assignment.getLValue() instanceof VariableVersion || assignment.getLValue() instanceof VariableIntermediate) {
               Variable variable = (Variable) assignment.getLValue();
               if (assignment.getRValue1() == null && assignment.getRValue2() instanceof Constant) {
                  if (assignment.getOperator() == null) {
                     // Constant assignment
                     Constant constant = (Constant) assignment.getRValue2();
                     constants.put(variable, constant);
                  } else {
                     // Constant unary expression
                     Constant constant = calculateUnary(assignment.getOperator(), (Constant) assignment.getRValue2());
                     if(constant!=null) {
                        constants.put(variable, constant);
                     }
                  }
               } else if (assignment.getRValue1() instanceof Constant && assignment.getRValue2() instanceof Constant) {
                  // Constant binary expression
                  Constant constant = calculateBinary(
                        assignment.getOperator(),
                        (Constant) assignment.getRValue1(),
                        (Constant) assignment.getRValue2());
                  constants.put(variable, constant);
               }
            }
            return null;
         }

         @Override
         public Void visitPhi(StatementPhi phi) {
            if (phi.getPreviousVersions().size() == 1) {
               StatementPhi.PreviousSymbol previousSymbol = phi.getPreviousVersions().get(0);
               if (previousSymbol.getRValue() instanceof Constant) {
                  VariableVersion variable = phi.getLValue();
                  Constant constant = (Constant) previousSymbol.getRValue();
                  constants.put(variable, constant);
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
         case "*": { // pointer dereference
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

}
