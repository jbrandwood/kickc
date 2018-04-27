package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

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
   public boolean step() {
      Map<VariableRef, ConstantValue> constants = findConstantVariables();
      LinkedHashMap<VariableRef, RValue> constAliases = new LinkedHashMap<>();
      // Update symbol table with the constant value
      Set<VariableRef> constVars = new LinkedHashSet<>(constants.keySet());
      for(VariableRef constRef : constVars) {
         Variable variable = getProgram().getScope().getVariable(constRef);

         // Weed out all variables that are affected by the address-of operator
         if(isAddressOfUsed(constRef, getProgram())) {
            constants.remove(constRef);
            continue;
         }

         ConstantValue constVal = constants.get(constRef);
         Scope constScope = variable.getScope();

         SymbolType valueType = SymbolTypeInference.inferType(getScope(), constVal);
         SymbolType variableType = variable.getType();
         SymbolType constType = variableType;

         if(!valueType.equals(variableType)) {
            if(SymbolTypeInference.typeMatch(valueType, variableType)) {
               constType = valueType;
            } else if(SymbolTypeInference.typeMatch(variableType, valueType)) {
               constType = variableType;
            } else {
               throw new CompileError(
                     "Constant variable has a non-matching type \n variable: " + variable.toString(getProgram()) +
                           "\n value: (" + valueType.toString() + ") " + constVal.calculateLiteral(getScope()) +
                           "\n value definition: " + constVal.toString(getProgram()));
            }
         }

         ConstantVar constantVar = new ConstantVar(
               variable.getName(),
               constScope,
               constType,
               constVal);
         constantVar.setDeclaredAlignment(variable.getDeclaredAlignment());
         constantVar.setDeclaredRegister(variable.getDeclaredRegister());
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
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               findConstantsAssignment(constants, assignment);
            } else if( statement instanceof StatementPhiBlock) {
               StatementPhiBlock phi = (StatementPhiBlock) statement;
               findConstantsPhi(constants, phi);
            }
         }
      }

      return constants;
   }

   private void findConstantsPhi(Map<VariableRef, ConstantValue> constants, StatementPhiBlock phi) {
      for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
         if(phiVariable.getValues().size() == 1) {
            StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
            if(getConstant(phiRValue.getrValue()) != null) {
               VariableRef variable = phiVariable.getVariable();
               ConstantValue constant = getConstant(phiRValue.getrValue());
               constants.put(variable, constant);
            }
         }
      }
   }

   private void findConstantsAssignment(Map<VariableRef, ConstantValue> constants, StatementAssignment assignment) {
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         VariableRef variable = (VariableRef) lValue;
         if(assignment.getrValue1() == null && getConstant(assignment.getrValue2()) != null) {
            if(assignment.getOperator() == null) {
               // Constant assignment
               ConstantValue constant = getConstant(assignment.getrValue2());
               constants.put(variable, constant);
            } else {
               // Constant unary expression
               ConstantValue constant = createUnary(
                     (OperatorUnary) assignment.getOperator(),
                     getConstant(assignment.getrValue2())
               );
               if(constant != null) {
                  constants.put(variable, constant);
               }
            }
         } else if(getConstant(assignment.getrValue1()) != null && getConstant(assignment.getrValue2()) != null) {
            // Constant binary expression
            ConstantValue constant = createBinary(
                  getConstant(assignment.getrValue1()),
                  (OperatorBinary) assignment.getOperator(),
                  getConstant(assignment.getrValue2()),
                  getScope());
            if(constant != null) {

               constants.put(variable, constant);
            }
         } else if(assignment.getrValue2() instanceof ValueList && assignment.getOperator() == null && assignment.getrValue1() == null) {
            // A candidate for a constant list - examine to confirm
            Variable lVariable = getScope().getVariable((VariableRef) lValue);
            if(lVariable.getType() instanceof SymbolTypeArray) {
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
                        if(!SymbolTypeInference.typeMatch(listType, elmType)) {
                           SymbolType intersectType = SymbolTypeInference.intersectTypes(listType, elmType);
                           if(intersectType==null) {
                              // No overlap between list type and element type
                              throw new RuntimeException("Array type " + listType + " does not match element type" + elmType + ". Array: " + valueList.toString(getProgram()));
                           } else {
                              listType = intersectType;
                           }
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
                  ConstantValue constant = new ConstantArrayList(elements, listType);
                  constants.put(variable, constant);
               }
            }
         } else if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && assignment.getrValue1()==null) {
            // Constant address-of variable
            if(assignment.getrValue2() instanceof VariableRef) {
               ConstantVarPointer constantVarPointer = new ConstantVarPointer((VariableRef) assignment.getrValue2());
               constants.put(variable, constantVarPointer);
            }
         }
      }
   }

   /**
    * If the rValue is a known constant return the constant value.
    *
    * @param rValue The rValue to examine
    * @return The constant value. null is the rValue is not a known constant.
    */
   public static ConstantValue getConstant(RValue rValue) {
      if(rValue instanceof ConstantValue) {
         return (ConstantValue) rValue;
      } else if(rValue instanceof ConstantVar) {
         ConstantVar constantVar = (ConstantVar) rValue;
         return constantVar.getRef();
      }
      return null;
   }

   static ConstantValue createUnary(OperatorUnary operator, ConstantValue c) {
      switch(operator.getOperator()) {
         case "-":
         case "+":
         case "++":
         case "--":
         case "<":
         case ">":
         case "((byte))":
         case "((signed byte))":
         case "((sbyte))":
         case "((word))":
         case "((signed word))":
         case "((dword))":
         case "((signed dword))":
         case "((byte*))":
         case "((boolean*))":
         case "!":
            return new ConstantUnary(operator, c);
         case "*": { // pointer dereference - not constant
            return null;
         }
         default:
            throw new RuntimeException("Unhandled Unary Operator " + operator.getOperator());
      }
   }

   static ConstantValue createBinary(ConstantValue c1, OperatorBinary operator, ConstantValue c2, ProgramScope programScope) {
      switch(operator.getOperator()) {
         case "-":
         case "+":
            if(SymbolType.STRING.equals(c1.getType(programScope))) {
               if(c1 instanceof ConstantRef) {
                  c1 = programScope.getConstant((ConstantRef) c1).getValue();
               }
               if(c2 instanceof ConstantRef) {
                  c2 = programScope.getConstant((ConstantRef) c2).getValue();
               }
               return new ConstantBinary(c1, operator, c2);
            }
         case "*":
         case "/":
         case "%":
         case "&":
         case "|":
         case "&&":
         case "||":
         case "^":
         case "<<":
         case ">>":
         case "==":
         case "!=":
         case ">":
         case "<":
         case ">=":
         case "<=":
            return new ConstantBinary(c1, operator, c2);
         case "w=":
            return new ConstantBinary(new ConstantBinary(c1, Operators.MULTIPLY, new ConstantInteger(256L)), Operators.PLUS, c2);
         case "dw=":
            return new ConstantBinary(new ConstantBinary(c1, Operators.MULTIPLY, new ConstantInteger(65536L)), Operators.PLUS, c2);
         case "*idx":
            // Pointer dereference - not constant
            return null;
         default:
            throw new RuntimeException("Unhandled Binary Operator " + operator.getOperator());
      }
   }


   /**
    * Determines if the variable is ever operated on by the address-of operator
    * @param var tHe variable to examine
    * @return true if the address-of operator is used on the variable
    */
   public static boolean isAddressOfUsed(VariableRef var, Program program) {

      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && var.equals(assignment.getrValue2())) {
                  return true;
               }
            } else if(statement instanceof StatementPhiBlock) {
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getrValue() instanceof ConstantVarPointer) {
                        if(((ConstantVarPointer)phiRValue.getrValue()).getToVar().equals(var)) {
                           return true;
                        }

                     }
                  }
               }
            }
         }
      }
      for(ConstantVar constVar : program.getScope().getAllConstants(true)) {
         ConstantValue constantValue = constVar.getValue();
         if(constantValue instanceof ConstantVarPointer) {
            ConstantVarPointer constantVarPointer = (ConstantVarPointer) constantValue;
            if(constantVarPointer.getToVar().equals(var)) {
               return true;
            }
         }
      }
      return false;
   }



}
