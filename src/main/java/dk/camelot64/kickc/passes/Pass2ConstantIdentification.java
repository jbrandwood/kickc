package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
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
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

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
      Map<VariableRef, ConstantVariableValue> constants = findConstantVariables();
      LinkedHashMap<VariableRef, RValue> constAliases = new LinkedHashMap<>();
      // Update symbol table with the constant value
      Set<VariableRef> constVars = new LinkedHashSet<>(constants.keySet());
      for(VariableRef constRef : constVars) {
         Variable variable = getProgram().getScope().getVariable(constRef);

         ConstantVariableValue constVarVal = constants.get(constRef);

         // Weed out all variables that are affected by the address-of operator
         if(isAddressOfUsed(constRef, getProgram())) {

            // If the assignment has an operator then replace it with the single constant value
            if(constVarVal.getAssignment() instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) constVarVal.getAssignment();
               if(assignment.getOperator() != null) {
                  getLog().append("Constant right-side identified " + assignment.toString(getProgram(), false));
                  assignment.setOperator(null);
                  assignment.setrValue1(null);
                  assignment.setrValue2(constVarVal.getConstantValue());
               }
            }

            // But do not remove the variable
            constants.remove(constRef);
            continue;
         }
         Scope constScope = variable.getScope();

         ConstantValue constVal = constVarVal.getConstantValue();
         SymbolType valueType = SymbolTypeInference.inferType(getScope(), constVal);
         SymbolType variableType = variable.getType();

         if(!SymbolType.NUMBER.equals(variableType) && SymbolType.NUMBER.equals(valueType)) {
            // Value is number - wait til it is cast to a proper type
            constants.remove(constRef);
            continue;
         }

         if(!SymbolTypeConversion.assignmentTypeMatch(variableType, valueType)) {
               throw new CompileError(
                     "Constant variable has a non-matching type \n variable: " + variable.toString(getProgram()) +
                           "\n value: (" + valueType.toString() + ") " + constVal.calculateLiteral(getScope()) +
                           "\n value definition: " + constVal.toString(getProgram())
               );
         }

         ConstantVar constantVar = new ConstantVar(
               variable.getName(),
               constScope,
               variableType,
               constVal);
         constantVar.setDeclaredAlignment(variable.getDeclaredAlignment());
         constantVar.setDeclaredRegister(variable.getDeclaredRegister());
         if(variable.getComments().size() > 0) {
            constantVar.setComments(variable.getComments());
         } else {
            constantVar.setComments(constVarVal.getAssignment().getComments());
         }
         constScope.remove(variable);
         constScope.add(constantVar);
         constAliases.put(constRef, constantVar.getRef());
         getLog().append("Constant " + constantVar.toString(getProgram()) + " = " + constantVar.getValue());
      }
      // Remove assignments to constants in the code
      removeAssignments(getGraph(), constants.keySet());
      // Replace VariableRef's with ConstantRef's
      replaceVariables(constAliases);
      return constants.size() > 0;
   }

   /**
    * A variable identified as a constant.
    */
   private static class ConstantVariableValue {

      /** The variable that has been determined to be constant. */
      private VariableRef variableRef;

      /** The constant value of the variable. */
      private ConstantValue constantValue;

      /**
       * The statement that assigns the variable its value (the assignment will be removed at the end).
       * Either a {@link StatementAssignment} or a {@link StatementPhiBlock}.
       */
      private Statement assignment;

      public ConstantVariableValue(VariableRef variableRef, ConstantValue constantValue, Statement assignment) {
         this.variableRef = variableRef;
         this.constantValue = constantValue;
         this.assignment = assignment;
      }

      public VariableRef getVariableRef() {
         return variableRef;
      }

      public ConstantValue getConstantValue() {
         return constantValue;
      }

      public Statement getAssignment() {
         return assignment;
      }
   }

   /**
    * Find variables that have constant values.
    *
    * @return Map from Variable to the Constant value
    */
   private Map<VariableRef, ConstantVariableValue> findConstantVariables() {
      final Map<VariableRef, ConstantVariableValue> constants = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               findConstantsAssignment(constants, assignment);
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phi = (StatementPhiBlock) statement;
               findConstantsPhi(constants, phi);
            }
         }
      }

      return constants;
   }

   private void findConstantsPhi(Map<VariableRef, ConstantVariableValue> constants, StatementPhiBlock phi) {
      for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
         if(phiVariable.getValues().size() == 1) {
            StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
            if(getConstant(phiRValue.getrValue()) != null) {
               VariableRef variable = phiVariable.getVariable();
               Variable var = getScope().getVariable(variable);
               if(var.isDeclaredVolatile()) {
                  // Volatile variables cannot be constant
                  continue;
               }
               ConstantValue constant = getConstant(phiRValue.getrValue());
               constants.put(variable, new ConstantVariableValue(variable, constant, phi));
            }
         }
      }
   }

   private void findConstantsAssignment(Map<VariableRef, ConstantVariableValue> constants, StatementAssignment assignment) {
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         VariableRef variable = (VariableRef) lValue;
         Variable var = getScope().getVariable(variable);
         if(var.isDeclaredVolatile()) {
            // Volatile variables cannot be constant
            return;
         }
         if(assignment.getrValue1()==null && assignment.getOperator()==null && assignment.getrValue2() instanceof ConstantValue) {
            constants.put(variable, new ConstantVariableValue(variable, (ConstantValue) assignment.getrValue2(), assignment));
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
      } else if(rValue instanceof CastValue) {
         CastValue castValue = (CastValue) rValue;
         ConstantValue castConstant = getConstant(castValue.getValue());
         if(castConstant != null) {
            return new ConstantCastValue(castValue.getToType(), castConstant);
         }
      } else if(rValue instanceof ArrayFilled) {
         ArrayFilled arrayFilled = (ArrayFilled) rValue;
         if(arrayFilled.getSize() instanceof ConstantValue) {
            return new ConstantArrayFilled(arrayFilled.getElementType(), (ConstantValue) arrayFilled.getSize());
         }
      }
      return null;
   }

   static ConstantValue createUnary(OperatorUnary operator, ConstantValue c) {
      if(Operators.DEREF.equals(operator)) {
         // Pointer dereferencing is not constant
         return null;
      }
      return new ConstantUnary(operator, c);
   }

   static ConstantValue createBinary(ConstantValue c1, OperatorBinary operator, ConstantValue c2, ProgramScope programScope) {

      // Special handling of string append using +
      if(Operators.PLUS.equals(operator) && SymbolType.STRING.equals(c1.getType(programScope))) {
         if(c1 instanceof ConstantRef) {
            c1 = programScope.getConstant((ConstantRef) c1).getValue();
         }
         if(c2 instanceof ConstantRef) {
            c2 = programScope.getConstant((ConstantRef) c2).getValue();
         }
         return new ConstantBinary(c1, operator, c2);
      }

      if(Operators.PLUS.equals(operator)) {
         return new ConstantBinary(c1, operator, c2);
      }

      switch(operator.getOperator()) {
         case "-":
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
    *
    * @param symbolRef tHe variable to examine
    * @return true if the address-of operator is used on the variable
    */
   public static boolean isAddressOfUsed(SymbolRef symbolRef, Program program) {
      final boolean[] found = {false};
      ProgramValueIterator.execute(program, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof ConstantSymbolPointer) {
            ConstantSymbolPointer constantSymbolPointer = (ConstantSymbolPointer) value;
            if(constantSymbolPointer.getToSymbol().equals(symbolRef)) {
               found[0] = true;
            }
         }
      });
      if(found[0]) {
         return true;
      }

      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && symbolRef.equals(assignment.getrValue2())) {
                  return true;
               }
            }
         }
      }
      return false;
   }


}
