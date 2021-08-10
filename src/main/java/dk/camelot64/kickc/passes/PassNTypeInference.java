package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.AssignmentRValue;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.VariableRef;

/**
 * Pass through the generated statements inferring types of unresolved variables.
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
                  updateInferedTypeLValue(getProgram(), (StatementLValue) statement);
               } else if(statement instanceof StatementPhiBlock) {
                  for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                     updateInferedTypePhiVariable(getProgram(), phiVariable);
                  }
               }
            } catch(CompileError e) {
               throw new CompileError(e.getMessage(), statement.getSource());
            }
         }
      }
      return false;
   }

   static void updateInferedTypeLValue(Program program, StatementLValue statementLValue) {
      if(statementLValue instanceof StatementAssignment) {
         updateInferedTypeAssignmentLValue(program, (StatementAssignment) statementLValue);
      } else if(statementLValue instanceof StatementCall) {
         updateInferedTypeCallLValue(program, (StatementCall) statementLValue);
      } else if(statementLValue instanceof StatementCallFinalize) {
         updateInferedTypeCallFinalizeLValue(program, (StatementCallFinalize) statementLValue);
      } else if(statementLValue instanceof StatementCallPointer) {
         updateInferedTypeCallPointerLValue(program, (StatementCallPointer) statementLValue);
      } else {
         throw new RuntimeException("LValue statement not implemented " + statementLValue);
      }
   }


   private static void updateInferedTypeCallLValue(Program program, StatementCall call) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())|| SymbolType.UNUMBER.equals(symbol.getType())|| SymbolType.SNUMBER.equals(symbol.getType())) {
            Procedure procedure = programScope.getProcedure(call.getProcedure());
            SymbolType type = procedure.getReturnType();
            setInferedType(program, call, symbol, type);
         }
      }
   }

   private static void updateInferedTypeCallFinalizeLValue(Program program, StatementCallFinalize call) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())|| SymbolType.UNUMBER.equals(symbol.getType())|| SymbolType.SNUMBER.equals(symbol.getType())) {
            Procedure procedure = programScope.getProcedure(call.getProcedure());
            SymbolType type = procedure.getReturnType();
            setInferedType(program, call, symbol, type);
         }
      }
   }

   private static void updateInferedTypeCallPointerLValue(Program program, StatementCallPointer call) {
      ProgramScope programScope = program.getScope();
      LValue lValue = call.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())|| SymbolType.UNUMBER.equals(symbol.getType())|| SymbolType.SNUMBER.equals(symbol.getType())) {
            SymbolType procedureType = SymbolTypeInference.inferType(programScope, call.getProcedure());
            if(procedureType instanceof SymbolTypePointer)
               // Handle call to pointer to function
               procedureType = ((SymbolTypePointer) procedureType).getElementType();
            if(procedureType instanceof SymbolTypeProcedure) {
               SymbolType returnType = ((SymbolTypeProcedure) procedureType).getReturnType();
               setInferedType(program, call, symbol, returnType);
            }
         }
      }
   }

   private static void updateInferedTypePhiVariable(Program program, StatementPhiBlock.PhiVariable phiVariable) {
      ProgramScope programScope = program.getScope();
      Variable symbol = programScope.getVariable(phiVariable.getVariable());
      if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())|| SymbolType.UNUMBER.equals(symbol.getType())|| SymbolType.SNUMBER.equals(symbol.getType())) {
         SymbolType type = null;
         for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
            RValue rValue = phiRValue.getrValue();
            SymbolType valueType = SymbolTypeInference.inferType(programScope, rValue);
            if(type == null) {
               type = valueType;
            } else if(!type.equals(valueType))
               if(type.equals(SymbolType.VAR) && valueType!=null) {
                  type = valueType;
               } else if(valueType instanceof SymbolTypeInteger && type instanceof SymbolTypeInteger) {
                  type = SymbolTypeConversion.convertedMathType((SymbolTypeInteger) valueType, (SymbolTypeInteger) type);
               } else {
                  throw new CompileError("Phi value has type mismatch " + rValue.toString() + " not matching type " + type.toCDecl());
               }
         }
         if(!SymbolType.VAR.equals(symbol.getType()) && !type.equals(symbol.getType())) {
            program.getLog().append("Inferred type updated to " + type + " for " + symbol.toString(program));
         }
         symbol.setType(type);
      }
   }

   private static void updateInferedTypeAssignmentLValue(Program program, StatementAssignment assignment) {
      ProgramScope programScope = program.getScope();
      LValue lValue = assignment.getlValue();
      if(lValue instanceof VariableRef) {
         Variable symbol = programScope.getVariable((VariableRef) lValue);
         if(SymbolType.VAR.equals(symbol.getType()) || SymbolType.NUMBER.equals(symbol.getType())|| SymbolType.UNUMBER.equals(symbol.getType()) || SymbolType.SNUMBER.equals(symbol.getType())) {
            SymbolType type = SymbolTypeInference.inferType(programScope, new AssignmentRValue(assignment));
            setInferedType(program, assignment, symbol, type);
         }
      }
   }

   private static void setInferedType(Program program, Statement statement, Variable symbol, SymbolType type) {
      if(!SymbolType.VAR.equals(symbol.getType()) && !type.equals(symbol.getType())) {
         program.getLog().append("Inferred type updated to " + type + " in " + statement.toString(program, false));
      }
      symbol.setType(type);
      // Update struct unwind/classic
      if(type instanceof SymbolTypeStruct) {
         final VariableBuilderConfig variableBuilderConfig = program.getTargetPlatform().getVariableBuilderConfig();
         symbol.setStructUnwind(VariableBuilder.isStructUnwind(type, symbol.getKind(), variableBuilderConfig));
      }
   }


}
