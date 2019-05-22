package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.OperatorBinary;
import dk.camelot64.kickc.model.operators.OperatorUnary;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class PassNTypeInference extends Pass2SsaOptimization {

   public PassNTypeInference(Program program) {
      super(program);
   }


   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            try {
               if(statement instanceof StatementLValue) {
                  inferLValue(getProgram(), (StatementLValue) statement);
               } else if(statement instanceof StatementPhiBlock) {
                  for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                     inferPhiVariable(getProgram(), phiVariable);
                  }
               }
            } catch(CompileError e) {
               throw new CompileError(e.getMessage(), statement.getSource());
            }
         }
      }
      return false;
   }

   public static void inferLValue(Program program, StatementLValue statementLValue) {
      if(statementLValue instanceof StatementAssignment) {
         inferAssignmentLValue(program, (StatementAssignment) statementLValue);
      } else if(statementLValue instanceof StatementCall) {
         inferCallLValue(program, (StatementCall) statementLValue);
      } else if(statementLValue instanceof StatementCallPointer) {
         inferCallPointerLValue(program, (StatementCallPointer) statementLValue);
      } else {
         throw new RuntimeException("LValue statement not implemented " + statementLValue);
      }
   }


   private static void inferCallLValue(Program program, StatementCall call) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())) {
            Procedure procedure = programScope.getProcedure(call.getProcedure());
            SymbolType type = procedure.getReturnType();
            setInferedType(program, call, symbol, type);
         }
      }
   }

   private static void inferCallPointerLValue(Program program, StatementCallPointer call) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())) {
            SymbolType procedureType = SymbolTypeInference.inferType(programScope, call.getProcedure());
            if(procedureType instanceof SymbolTypeProcedure) {
               SymbolType returnType = ((SymbolTypeProcedure) procedureType).getReturnType();
               setInferedType(program, call, symbol, returnType);
            }
         }
      }
   }

   private static void inferPhiVariable(Program program, StatementPhiBlock.PhiVariable phiVariable) {
      ProgramScope programScope = program.getScope();
      Variable symbol = programScope.getVariable(phiVariable.getVariable());
      if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())) {
         SymbolType type = null;
         for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
            RValue rValue = phiRValue.getrValue();
            SymbolType valueType = SymbolTypeInference.inferType(programScope, rValue);
            if(type == null) {
               type = valueType;
            } else if(!type.equals(valueType))
               if(valueType instanceof SymbolTypeInteger && type instanceof SymbolTypeInteger) {
                  type = SymbolTypeConversion.convertedMathType((SymbolTypeInteger) valueType, (SymbolTypeInteger) type);
               } else {
                  throw new CompileError("Phi value has type mismatch " + phiRValue.toString() + " not matching type " + type.getTypeName());
               }
         }
         if(!SymbolType.VAR.equals(symbol.getType()) && !type.equals(symbol.getType())) {
            program.getLog().append("Inferred type updated to " + type + " for " + symbol.toString(program));
         }
         symbol.setTypeInferred(type);
      }
   }

   private static void inferAssignmentLValue(Program program, StatementAssignment assignment) {
      ProgramScope programScope = program.getScope();
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())) {
            // Unresolved symbol - perform inference
            Operator operator = assignment.getOperator();
            if(assignment.getrValue1() == null && operator == null) {
               // Copy operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = SymbolTypeInference.inferType(programScope, rValue);
               setInferedType(program, assignment, symbol, type);
            } else if(assignment.getrValue1() == null && operator instanceof OperatorUnary) {
               // Unary operation
               RValue rValue = assignment.getrValue2();
               SymbolType type = SymbolTypeInference.inferType(programScope, (OperatorUnary) operator, rValue);
               setInferedType(program, assignment, symbol, type);
            } else if(operator instanceof OperatorBinary) {
               // Binary operation
               SymbolType type = SymbolTypeInference.inferType(
                     programScope, assignment.getrValue1(),
                     (OperatorBinary) assignment.getOperator(),
                     assignment.getrValue2());
               setInferedType(program, assignment, symbol, type);
            } else {
               throw new CompileError("Cannot infer type of " + assignment);
            }
            // If the type is an array or a string the symbol is constant
            if(symbol.getType() instanceof SymbolTypeArray) {
               symbol.setDeclaredConstant(true);
            } else if(SymbolType.STRING.equals(symbol.getType())) {
               symbol.setDeclaredConstant(true);
            }
         }
      }
   }

   private static void setInferedType(Program program, Statement statement, Variable symbol, SymbolType type) {
      if(!SymbolType.VAR.equals(symbol.getType()) && !type.equals(symbol.getType())) {
         program.getLog().append("Inferred type updated to " + type + " in " + statement.toString(program, false));
      }
      symbol.setTypeInferred(type);
   }


}
