package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorCastPtr;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeIntegerFixed;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

/** Identify any variable that is clearly constant (because it only has a single assignment). */
public class Pass1EarlyConstantIdentification extends Pass1Base {

   public Pass1EarlyConstantIdentification(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      HashMap<SymbolRef, RValue> aliases = new HashMap<>();
      List<Statement> removeStmt = new ArrayList<>();
      for(Variable variable : getProgram().getScope().getAllVariables(true)) {
         SymbolVariableRef variableRef = variable.getRef();
         if(!variable.isDeclaredConst() && !variable.isVolatile() && !variableRef.isIntermediate()) {
            if(variable.getScope() instanceof StructDefinition)
               // Skip structs
               continue;
            if(!isParameter(variableRef)) {
               Collection<StatementLValue> assignments = getAssignments(variable);
               if(assignments.size() == 1) {
                  StatementLValue assignment = assignments.iterator().next();
                  if(assignment instanceof StatementAssignment) {
                     StatementAssignment assign = (StatementAssignment) assignment;
                     if(assign.getrValue1() == null && assign.getOperator() == null && assign.getrValue2() instanceof ConstantValue) {
                        getLog().append("Identified constant variable " + variable.toString(getProgram()));
                        ConstantValue constantValue = (ConstantValue) assign.getrValue2();
                        convertToConst(variable, constantValue, assign, aliases);
                        removeStmt.add(assign);
                     } else if(assign.getrValue1() == null && assign.getOperator() instanceof OperatorCastPtr && assign.getrValue2() instanceof ConstantValue) {
                        getLog().append("Identified constant variable " + variable.toString(getProgram()));
                        ConstantValue constantValue = new ConstantCastValue(((OperatorCastPtr) assign.getOperator()).getToType(), (ConstantValue) assign.getrValue2());
                        convertToConst(variable, constantValue, assign, aliases);
                        removeStmt.add(assign);
                     }
                  }
               }
            }
         }
      }
      // Remove the statements
      for(ControlFlowBlock allBlock : getGraph().getAllBlocks()) {
         allBlock.getStatements().removeIf(removeStmt::contains);
      }
      // Replace all variable refs with constant refs
      ProgramValueIterator.execute(getProgram(), new AliasReplacer(aliases));
      return false;
   }

   /**
    * Converts variable to constant
    *
    * @param variable The variable
    * @param constantValue The constant value
    * @param aliases Aliases where the map from var to const is added
    */
   private void convertToConst(Variable variable, ConstantValue constantValue, Statement assignment, HashMap<SymbolRef, RValue> aliases) {
      // Perform type checking
      SymbolType valueType = SymbolTypeInference.inferType(getScope(), constantValue);
      SymbolType variableType = variable.getType();

      if(!SymbolTypeConversion.assignmentTypeMatch(variableType, valueType) || SymbolType.NUMBER.equals(valueType)) {
         boolean typeOk = false;
         ConstantLiteral constantLiteral = null;
         try {
            constantLiteral = constantValue.calculateLiteral(getScope());
         } catch(ConstantNotLiteral e) {
            // ignore
         }
         String literalStr = (constantLiteral == null) ? "null" : constantLiteral.toString(getProgram());
         if(SymbolType.NUMBER.equals(valueType)) {
            if(variableType instanceof SymbolTypeIntegerFixed && constantLiteral instanceof ConstantInteger) {
               SymbolTypeIntegerFixed variableTypeInt = (SymbolTypeIntegerFixed) variableType;
               ConstantInteger valueInt = (ConstantInteger) constantLiteral;
               if(variableTypeInt.contains(valueInt.getInteger())) {
                  if(constantValue instanceof ConstantInteger) {
                     ((ConstantInteger) constantValue).setType(variableType);
                  }  else {
                     constantValue = new ConstantCastValue(variableType, constantValue);
                  }
                  typeOk = true;
               }
            }
         }
         if(!typeOk) {
            throw new CompileError(
                  "Constant variable has a non-matching type \n variable: " + variable.toString(getProgram()) +
                        "\n value: (" + valueType.toString() + ") " + literalStr +
                        "\n value definition: " + constantValue.toString(getProgram())
            );
         }
      }

      // Convert to constant
      SymbolVariableRef variableRef = variable.getRef();
      Scope scope = variable.getScope();
      scope.remove(variable);
      Variable constVar = new Variable(variable.getName(), scope, variable.getType(), variable.getDataSegment(), constantValue);
      constVar.setDeclaredAlignment(variable.getDeclaredAlignment());
      constVar.setDeclaredAsRegister(variable.isDeclaredAsRegister());
      constVar.setDeclaredNotRegister(variable.isDeclaredAsNotRegister());
      constVar.setDeclaredConst(variable.isDeclaredConst());
      constVar.setDeclaredRegister(variable.getDeclaredRegister());
      constVar.setDeclaredVolatile(variable.isDeclaredVolatile());
      constVar.setDeclaredExport(variable.isDeclaredExport());
      constVar.setInferredVolatile(variable.isInferredVolatile());
      constVar.setInferredType(variable.isInferredType());
      constVar.setComments(variable.getComments());
      constVar.getComments().addAll(assignment.getComments());
      SymbolVariableRef constRef = constVar.getRef();
      aliases.put(variableRef, constRef);
      scope.add(constVar);
   }

   /**
    * Examines whether a variable is a procedure parameter
    *
    * @param variableRef The variable
    * @return true if the variable is a procedure parameter
    */
   public boolean isParameter(SymbolVariableRef variableRef) {
      Variable var = getScope().getVariable(variableRef);
      Scope varScope = var.getScope();
      if(varScope instanceof Procedure) {
         List<Variable> parameters = ((Procedure) varScope).getParameters();
         if(parameters.contains(var))
            return true;

      }
      return false;
   }

   /**
    * Find all assignments of a variable.
    *
    * @param variable The variable
    * @return all assignments
    */
   private Collection<StatementLValue> getAssignments(Variable variable) {
      Collection<StatementLValue> assignments = new ArrayList<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               if(variable.getRef().equals(assignment.getlValue())) {
                  assignments.add(assignment);
               }
            }
         }
      }
      return assignments;
   }
}
