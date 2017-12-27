package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass propagating constants in expressions eliminating constant variables
 */
public class Pass2ConstantIdentification extends Pass2SsaOptimization {

   public Pass2ConstantIdentification(Program program) {
      super(program);
   }

   /**
    * Propagate constants, replacing variables with constants where possible.
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean optimize() {
      Map<VariableRef, ConstantValue> constants = findConstantVariables();
      LinkedHashMap<VariableRef, RValue> constAliases = new LinkedHashMap<>();
      // Update symbol table with the constant value
      for (VariableRef constRef : constants.keySet()) {
         Variable variable = getProgram().getScope().getVariable(constRef);
         ConstantValue constVal = constants.get(constRef);
         Scope constScope = variable.getScope();
         ConstantVar constantVar = new ConstantVar(
               variable.getName(),
               constScope,
               variable.getType(),
               constVal);
         constScope.remove(variable);
         constScope.add(constantVar);
         constAliases.put(constRef, constantVar.getRef());
         getLog().append("Constant " + constantVar.toString(getProgram()) + " = " + constantVar.getValue());
      }
      // Remove assignments to constants in the code
      removeAssignments(constants.keySet());
      // Replace VariableRef's with ConstantRef's
      replaceVariables(constAliases);
      return constants.size() > 0;
   }

   /**
    * Find variables that have constant values.
    *
    * @return Map from Variable to the Constant value
    */
   private Map<VariableRef, ConstantValue> findConstantVariables() {
      final Map<VariableRef, ConstantValue> constants = new LinkedHashMap<>();
      ControlFlowGraphBaseVisitor<Void> visitor = new ControlFlowGraphBaseVisitor<Void>() {
         @Override
         public Void visitAssignment(StatementAssignment assignment) {
            LValue lValue = assignment.getlValue();
            if (lValue instanceof VariableRef) {
               VariableRef variable = (VariableRef) lValue;
               if (assignment.getrValue1() == null && getConstant(assignment.getrValue2()) != null) {
                  if (assignment.getOperator() == null) {
                     // Constant assignment
                     ConstantValue constant = getConstant(assignment.getrValue2());
                     constants.put(variable, constant);
                  } else {
                     // Constant unary expression
                     ConstantValue constant = createUnary(assignment.getOperator(), getConstant(assignment.getrValue2()));
                     if (constant != null) {
                        constants.put(variable, constant);
                     }
                  }
               } else if (getConstant(assignment.getrValue1()) != null && getConstant(assignment.getrValue2()) != null) {
                  // Constant binary expression
                  ConstantValue constant = createBinary(
                        getConstant(assignment.getrValue1()),
                        assignment.getOperator(),
                        getConstant(assignment.getrValue2()));
                  if (constant != null) {
                     constants.put(variable, constant);
                  }
               } else if (assignment.getrValue2() instanceof ValueList && assignment.getOperator() == null && assignment.getrValue1() == null) {
                  if (lValue instanceof VariableRef) {
                     Variable lVariable = getSymbols().getVariable((VariableRef) lValue);
                     if (lVariable.getType() instanceof SymbolTypeArray) {
                        ValueList valueList = (ValueList) assignment.getrValue2();
                        List<RValue> values = valueList.getList();
                        boolean allConstant = true;
                        SymbolType elementType = null;
                        List<ConstantValue> elements = new ArrayList<>();
                        for (RValue value : values) {
                           if (value instanceof ConstantValue) {
                              ConstantValue constantValue = (ConstantValue) value;
                              SymbolType type = constantValue.getType(getSymbols());
                              if (elementType == null) {
                                 elementType = type;
                              } else {
                                 if (!SymbolTypeInference.typeMatch(type, elementType)) {
                                    throw new RuntimeException("Array type mismatch " + elementType + " does not match " + type + " " + valueList.toString(getProgram()));
                                 }
                              }
                              elements.add(constantValue);
                           } else {
                              allConstant = false;
                              elementType = null;
                              break;
                           }
                        }
                        if (allConstant && elementType != null) {
                           ConstantValue constant = new ConstantArray(elements, elementType);
                           constants.put(variable, constant);
                        }
                     }
                  }
               }
            }
            return null;
         }

         @Override
         public Void visitPhiBlock(StatementPhiBlock phi) {
            for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
               if (phiVariable.getValues().size() == 1) {
                  StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
                  if (getConstant(phiRValue.getrValue()) != null) {
                     VariableRef variable = phiVariable.getVariable();
                     ConstantValue constant = getConstant(phiRValue.getrValue());
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

   /**
    * If the rValue is a known constant return the constant value.
    *
    * @param rValue The rValue to examine
    * @return The constant value. null is the rValue is not a known constant.
    */
   private ConstantValue getConstant(RValue rValue) {
      if (rValue instanceof ConstantValue) {
         return (ConstantValue) rValue;
      } else if (rValue instanceof ConstantVar) {
         ConstantVar constantVar = (ConstantVar) rValue;
         return constantVar.getRef();
      }
      return null;
   }


   static ConstantValue createBinary(ConstantValue c1, Operator operator, ConstantValue c2) {
      switch (operator.getOperator()) {
         case "-":
         case "+":
         case "*":
         case "/":
         case "&":
         case "|":
         case "^":
         case "<<":
         case ">>":
            return new ConstantBinary(c1, operator, c2);
         case "w=":
            return new ConstantBinary(new ConstantBinary(c1, Operator.MULTIPLY, new ConstantInteger(256)), Operator.PLUS, c2);
         case "*idx":
            // Pointer dereference - not constant
            return null;
         default:
            throw new RuntimeException("Unhandled Binary Operator " + operator.getOperator());
      }
   }

   static ConstantValue createUnary(Operator operator, ConstantValue c) {
      switch (operator.getOperator()) {
         case "-":
         case "+":
         case "++":
         case "--":
         case "<":
         case ">":
         case "((byte))":
         case "((sbyte))":
         case "((word))":
         case "((signed word))":
         case "((byte*))":
            return new ConstantUnary(operator, c);
         case "*": { // pointer dereference - not constant
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

}
