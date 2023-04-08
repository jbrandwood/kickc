package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorCastPtr;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.AliasReplacer;
import dk.camelot64.kickc.passes.utils.VarAssignments;

import java.util.ArrayList;
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
         if(!variable.isKindConstant() && !variable.isVolatile() && !variableRef.isIntermediate() ) {
            if(variable.getScope() instanceof StructDefinition)
               // Skip structs
               continue;
            if(variable.getRegister()!=null && variable.getRegister().isMem())
               // Skip variables allocated into memory
               continue;
            if(!isParameter(variableRef)) {
               final List<VarAssignments.VarAssignment> varAssignments = VarAssignments.get(variableRef, getGraph(), getProgramScope());
               if(varAssignments.size() == 1) {
                  final VarAssignments.VarAssignment varAssignment = varAssignments.get(0);
                  if(varAssignment.type.equals(VarAssignments.VarAssignment.Type.STATEMENT_LVALUE)) {
                     final StatementLValue assignment = varAssignment.statementLValue;
                     if(assignment instanceof StatementAssignment) {
                        StatementAssignment assign = (StatementAssignment) assignment;
                        if(assign.getrValue1() == null && assign.getOperator() == null && assign.getrValue2() instanceof ConstantValue) {
                           if(getLog().isVerboseParse())
                              getLog().append("Identified constant variable " + variable.toString(getProgram()));
                           ConstantValue constantValue = (ConstantValue) assign.getrValue2();
                           convertToConst(variable, constantValue, assignment.getComments(), aliases);
                           removeStmt.add(assign);
                        } else if(assign.getrValue1() == null && assign.getOperator() instanceof OperatorCastPtr && assign.getrValue2() instanceof ConstantValue) {
                           if(getLog().isVerboseParse())
                              getLog().append("Identified constant variable " + variable.toString(getProgram()));
                           ConstantValue constantValue = new ConstantCastValue(((OperatorCastPtr) assign.getOperator()).getToType(), (ConstantValue) assign.getrValue2());
                           convertToConst(variable, constantValue, assignment.getComments(), aliases);
                           removeStmt.add(assign);
                        }
                     }
                  } else if(varAssignment.type.equals(VarAssignments.VarAssignment.Type.INIT_VALUE)) {
                     if(!(variable.getType() instanceof SymbolTypeStruct)) {
                        // Only assignment is the initValue
                        if(getLog().isVerboseParse())
                           getLog().append("Identified constant variable " + variable.toString(getProgram()));
                        ConstantValue constantValue = variable.getInitValue();
                        convertToConst(variable, constantValue, variable.getComments(), aliases);
                     }
                  }
               }
            }
         }
      }
      // Remove the statements
      for(var allBlock : getGraph().getAllBlocks()) {
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
   private void convertToConst(Variable variable, ConstantValue constantValue, List<Comment> comments, HashMap<SymbolRef, RValue> aliases) {
      constantValue = prepareConstantValue(variable, constantValue);
      // Convert variable to constant
      SymbolVariableRef variableRef = variable.getRef();
      Scope scope = variable.getScope();
      scope.remove(variable);
      Variable constVar = Variable.createConstant(variable, constantValue);
      constVar.getComments().addAll(comments);
      SymbolVariableRef constRef = constVar.getRef();
      aliases.put(variableRef, constRef);
      scope.add(constVar);
   }

   /**
    * Type check and potentially add cast to the constant value
    *
    * @param variable
    * @param constantValue
    * @return
    */
   private ConstantValue prepareConstantValue(Variable variable, ConstantValue constantValue) {
      // Perform type checking
      SymbolType valueType = SymbolTypeInference.inferType(getProgramScope(), constantValue);
      SymbolType variableType = variable.getType();

      if(!SymbolTypeConversion.assignmentTypeMatch(variableType, valueType) || SymbolType.NUMBER.equals(valueType)) {
         ConstantLiteral constantLiteral = null;
         try {
            constantLiteral = constantValue.calculateLiteral(getProgramScope());
         } catch(ConstantNotLiteral e) {
            // ignore
         }
         boolean typeOk = false;
         if(SymbolType.NUMBER.equals(valueType)) {
            if(variableType instanceof SymbolTypeIntegerFixed && constantLiteral instanceof ConstantInteger) {
               SymbolTypeIntegerFixed variableTypeInt = (SymbolTypeIntegerFixed) variableType;
               ConstantInteger valueInt = (ConstantInteger) constantLiteral;
               if(variableTypeInt.contains(valueInt.getInteger())) {
                  if(constantValue instanceof ConstantInteger) {
                     ((ConstantInteger) constantValue).setType(variableType);
                  } else {
                     constantValue = new ConstantCastValue(variableType, constantValue);
                  }
                  typeOk = true;
               }
            }
         }
         if(!typeOk) {
            String literalStr = (constantLiteral == null) ? "null" : constantLiteral.toString(getProgram());
            throw new CompileError(
                  "Constant variable has a non-matching type \n variable: " + variable.toString(getProgram()) +
                        "\n value: (" + valueType.toString() + ") " + literalStr +
                        "\n value definition: " + constantValue.toString(getProgram())
            );
         }
      }
      return constantValue;
   }

   /**
    * Examines whether a variable is a procedure parameter
    *
    * @param variableRef The variable
    * @return true if the variable is a procedure parameter
    */
   public boolean isParameter(SymbolVariableRef variableRef) {
      Variable var = getProgramScope().getVariable(variableRef);
      Scope varScope = var.getScope();
      if(varScope instanceof Procedure) {
         List<Variable> parameters = ((Procedure) varScope).getParameters();
         if(parameters.contains(var))
            return true;

      }
      return false;
   }

}
