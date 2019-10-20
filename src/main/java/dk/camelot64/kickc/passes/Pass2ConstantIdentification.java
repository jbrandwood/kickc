package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
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
      Map<VariableRef, ConstantVariableValue> constants = findConstantVariables();
      LinkedHashMap<VariableRef, RValue> constAliases = new LinkedHashMap<>();
      // Update symbol table with the constant value
      Set<VariableRef> constVars = new LinkedHashSet<>(constants.keySet());
      for(VariableRef constRef : constVars) {
         Variable variable = getProgram().getScope().getVariable(constRef);
         ConstantVariableValue constVarVal = constants.get(constRef);
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
            ConstantLiteral constantLiteral = null;
            try {
               constantLiteral = constVal.calculateLiteral(getScope());
            } catch(ConstantNotLiteral e) {
               // ignore
            }
            String literalStr = (constantLiteral == null) ? "null" : constantLiteral.toString(getProgram());
            throw new CompileError(
                  "Constant variable has a non-matching type \n variable: " + variable.toString(getProgram()) +
                        "\n value: (" + valueType.toString() + ") " + literalStr +
                        "\n value definition: " + constVal.toString(getProgram())
            );
         }

         ConstantVar constantVar = new ConstantVar(
               variable.getName(),
               constScope,
               variableType,
               constVal,
               variable.getDataSegment()
         );

         constantVar.setInferredType(variable.isInferredType());
         constantVar.setDeclaredAlignment(variable.getDeclaredAlignment());
         constantVar.setDeclaredAsRegister(variable.isDeclaredAsRegister());
         constantVar.setDeclaredRegister(variable.getDeclaredRegister());
         constantVar.setDeclaredNotRegister(variable.isDeclaredAsNotRegister());
         constantVar.setDeclaredExport(variable.isDeclaredExport());
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

      // Look for constants among versions, intermediates & declared constants
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef varRef = (VariableRef) lValue;
                  Variable var = getScope().getVariable(varRef);
                  if(var.isVolatile() || var.isDeclaredNotConstant() || var.isStorageLoadStore())
                     // Do not examine volatiles and non-versioned variables
                     continue;
                  ConstantValue constant = getConstant(assignment.getrValue2());
                  if(assignment.getrValue1() == null && assignment.getOperator() == null && constant != null) {
                     constants.put(varRef, new ConstantVariableValue(varRef, constant, assignment));
                  }
               }
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phi = (StatementPhiBlock) statement;
               for(StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
                  if(phiVariable.getValues().size() == 1) {
                     StatementPhiBlock.PhiRValue phiRValue = phiVariable.getValues().get(0);
                     if(getConstant(phiRValue.getrValue()) != null) {
                        VariableRef varRef = phiVariable.getVariable();
                        Variable var = getScope().getVariable(varRef);
                        if(var.isVolatile() || var.isDeclaredNotConstant() || var.isStorageLoadStore())
                           // Do not examine volatiles and non-versioned variables
                           continue;
                        ConstantValue constant = getConstant(phiRValue.getrValue());
                        constants.put(varRef, new ConstantVariableValue(varRef, constant, phi));
                     }
                  }
               }
            }
         }
      }

      // Look for constants among non-versioned variables
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.isVolatile() || variable.isDeclaredNotConstant() || !variable.isStorageLoadStore())
            // Do not examine volatiles, non-constants or versioned variables
            continue;
         List<StatementLValue> assignments = getGraph().getAssignments(variable.getRef());
         if(assignments.size() == 1) {
            StatementLValue statementLValue = assignments.get(0);
            if(!(statementLValue instanceof StatementAssignment))
               // Only look at assignments
               continue;
            StatementAssignment assignment = (StatementAssignment) statementLValue;
            LValue lValue = assignment.getlValue();
            if(lValue instanceof VariableRef) {
               VariableRef varRef = (VariableRef) lValue;
               ConstantValue constant = getConstant(assignment.getrValue2());
               if(assignment.getrValue1() == null && assignment.getOperator() == null && constant != null) {
                  constants.put(varRef, new ConstantVariableValue(varRef, constant, assignment));
               }
            }
         }
      }


      return constants;
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
    * @param procedureRef tHe variable to examine
    * @return true if the address-of operator is used on the variable
    */
   public static boolean isAddressOfUsed(ProcedureRef procedureRef, Program program) {
      final boolean[] found = {false};
      // Examine all program values in expressions
      ProgramValueIterator.execute(program, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof ProcedureRef && value.equals(procedureRef)) {
            found[0] = true;
         }
      });
      if(found[0]) {
         return true;
      }

      // Examine all statements
      for(ControlFlowBlock block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator()) && procedureRef.equals(assignment.getrValue2())) {
                  return true;
               }
            }
         }
      }

      return false;
   }


}
