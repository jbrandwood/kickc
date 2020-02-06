package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.unwinding.*;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.concurrent.atomic.AtomicBoolean;

/** Convert all unwinding struct values into variables representing each member */
public class Pass1UnwindStructValues extends Pass1Base {

   public Pass1UnwindStructValues(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      if(getProgram().getStructVariableMemberUnwinding() == null) {
         getProgram().setStructVariableMemberUnwinding(new StructVariableMemberUnwinding());
      }
      boolean modified = false;
      // Unwind all procedure declaration parameters
      modified |= unwindStructParameters();
      // Unwind all usages of struct values
      modified |= unwindStructReferences();
      // Change all usages of members of struct values
      modified |= unwindStructMemberReferences();
      return modified;
   }

   /**
    * Unwinds all usages of struct value references (in statements such as assignments.)
    */
   private boolean unwindStructReferences() {
      boolean modified = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               modified |= unwindAssignment((StatementAssignment) statement, stmtIt, block);
            } else if(statement instanceof StatementCall) {
               modified |= unwindCall((StatementCall) statement, stmtIt, block);
            } else if(statement instanceof StatementReturn) {
               modified |= unwindReturn((StatementReturn) statement, stmtIt, block);
            }
         }
      }
      return modified;
   }

   /**
    * Change all usages of members inside statements to the unwound member variables
    */
   private boolean unwindStructMemberReferences() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(
            getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
               if(programValue.get() instanceof StructMemberRef) {
/*
                  StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                  if(structMemberRef.getStruct() instanceof VariableRef) {
                     StructUnwinding memberVariables = getStructMemberUnwinding(structMemberRef.getStruct(), currentStmt, stmtIt, currentBlock);
                     if(memberVariables != null && memberVariables != POSTPONE_UNWINDING) {
                        RValueUnwinding memberUnwinding = memberVariables.getMemberUnwinding(structMemberRef.getMemberName(), getScope());
                        RValue structMemberVariable = memberUnwinding.getUnwinding(getScope());
                        getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member unwinding reference " + structMemberVariable.toString(getProgram()));
                        programValue.set(structMemberVariable);
                     }

 */
                     StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                     final ValueSource structValueSource = getValueSource(getProgram(), getScope(), structMemberRef.getStruct(), currentStmt, stmtIt, currentBlock);
                     if(structValueSource != null) {
                        final ValueSource memberUnwinding = structValueSource.getMemberUnwinding(structMemberRef.getMemberName(), getProgram(), getScope(), currentStmt, currentBlock, stmtIt);
                        RValue memberSimpleValue = memberUnwinding.getSimpleValue(getScope());
                        getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member unwinding reference " + memberSimpleValue.toString(getProgram()));
                        programValue.set(memberSimpleValue);
                        modified.set(true);
                        

                  }
               }
            });
      return modified.get();
   }

   /**
    * Unwind any call parameter that is a struct value into the member values
    *
    * @param call The call to unwind
    */
   private boolean unwindCall(StatementCall call, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      // Unwind struct value return value
      boolean lvalUnwound = false;
      StructUnwinding lValueUnwinding = getStructMemberUnwinding(call.getlValue(), call, stmtIt, currentBlock);
      if(lValueUnwinding != null && lValueUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueUnwinding.getMemberNames()) {
            RValueUnwinding memberUnwinding = lValueUnwinding.getMemberUnwinding(memberName, getScope());
            unwoundMembers.add(memberUnwinding.getUnwinding(getScope()));
         }
         ValueList unwoundLValue = new ValueList(unwoundMembers);
         call.setlValue(unwoundLValue);
         getLog().append("Converted procedure call LValue to member unwinding " + call.toString(getProgram(), false));
         lvalUnwound = true;
      }

      // Unwind any struct value parameters
      ArrayList<RValue> unwoundParameters = new ArrayList<>();
      boolean anyParameterUnwound = false;
      for(RValue parameter : call.getParameters()) {
         boolean unwound = false;
         StructUnwinding parameterUnwinding = getStructMemberUnwinding(parameter, call, stmtIt, currentBlock);
         if(parameterUnwinding != null && parameterUnwinding != POSTPONE_UNWINDING) {
            // Passing a struct variable - convert it to member variables
            for(String memberName : parameterUnwinding.getMemberNames()) {
               RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName, getScope());
               unwoundParameters.add(memberUnwinding.getUnwinding(getScope()));
            }
            unwound = true;
            anyParameterUnwound = true;
         }
         if(!unwound) {
            unwoundParameters.add(parameter);
         }
      }

      if(anyParameterUnwound) {
         call.setParameters(unwoundParameters);
         getLog().append("Converted procedure struct value parameter to member unwinding in call " + call.toString(getProgram(), false));
      }
      return (anyParameterUnwound || lvalUnwound);
   }

   /**
    * Unwind any return value that is a struct value into the member values
    *
    * @param statementReturn The return to unwind
    */

   private boolean unwindReturn(StatementReturn statementReturn, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      boolean modified = false;
      // Unwind struct value return value
      StructUnwinding returnVarUnwinding = getStructMemberUnwinding(statementReturn.getValue(), statementReturn, stmtIt, currentBlock);
      if(returnVarUnwinding != null && returnVarUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : returnVarUnwinding.getMemberNames()) {
            RValueUnwinding memberUnwinding = returnVarUnwinding.getMemberUnwinding(memberName, getScope());
            unwoundMembers.add(memberUnwinding.getUnwinding(getScope()));
         }
         ValueList unwoundReturnValue = new ValueList(unwoundMembers);
         statementReturn.setValue(unwoundReturnValue);
         getLog().append("Converted procedure struct return value to member unwinding " + statementReturn.toString(getProgram(), false));
         modified = true;

      }
      return modified;
   }

   /**
    * Iterate through all procedures changing parameter lists by unwinding each struct value parameter to the unwound member variables
    */
   private boolean unwindStructParameters() {
      boolean modified = false;
      // Iterate through all procedures changing parameter lists by unwinding each struct value parameter
      for(Procedure procedure : getScope().getAllProcedures(true)) {
         ArrayList<String> unwoundParameterNames = new ArrayList<>();
         boolean procedureUnwound = false;
         for(Variable parameter : procedure.getParameters()) {
            if(parameter.getType() instanceof SymbolTypeStruct) {
               StructVariableMemberUnwinding structVariableMemberUnwinding = getProgram().getStructVariableMemberUnwinding();
               StructVariableMemberUnwinding.VariableUnwinding parameterUnwinding = structVariableMemberUnwinding.getVariableUnwinding(parameter.getRef());
               for(String memberName : parameterUnwinding.getMemberNames()) {
                  RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName, getScope());
                  SymbolVariableRef memberUnwindingRef = (SymbolVariableRef) memberUnwinding.getUnwinding(getScope());
                  unwoundParameterNames.add(memberUnwindingRef.getLocalName());
                  procedureUnwound = true;
               }
            } else {
               unwoundParameterNames.add(parameter.getLocalName());
            }
         }
         if(procedureUnwound) {
            procedure.setParameterNames(unwoundParameterNames);
            getLog().append("Converted procedure struct value parameter to member unwinding " + procedure.toString(getProgram()));
            modified = true;
         }
      }
      return modified;
   }

   /**
    * Unwind an assignment to a struct value variable into assignment of each member
    *
    * @param assignment The assignment statement
    * @param stmtIt The statement iterator used for adding/removing statements
    * @param currentBlock The current code block
    */
   private boolean unwindAssignment(StatementAssignment assignment, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      LValue lValue = assignment.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);

      if(lValueType instanceof SymbolTypeStruct && assignment.getOperator() == null) {

         // Assignment to a struct
         SymbolTypeStruct lValueStructType = (SymbolTypeStruct) lValueType;
         RValue rValue = assignment.getrValue2();
         boolean initialAssignment = assignment.isInitialAssignment();
         StatementSource source = assignment.getSource();

         // Check if this is already a bulk assignment - or an unwound placeholder
         if(rValue instanceof MemcpyValue || rValue instanceof MemsetValue || rValue instanceof StructUnwoundPlaceholder)
            return false;

         ValueSource lValueSource = getValueSource(getProgram(), getScope(), lValue, assignment, stmtIt, currentBlock);
         ValueSource rValueSource = getValueSource(getProgram(), getScope(), rValue, assignment, stmtIt, currentBlock);
         List<RValue> lValueUnwoundList = new ArrayList<>();
         if(copyValues(lValueSource, rValueSource, lValueUnwoundList, initialAssignment, assignment, currentBlock, stmtIt)) {
            if(lValue instanceof VariableRef) {
               StructUnwoundPlaceholder unwoundPlaceholder = new StructUnwoundPlaceholder(lValueStructType, lValueUnwoundList);
               assignment.setrValue2(unwoundPlaceholder);
            } else {
               stmtIt.remove();
            }
            return true;
         }
      }
      return false;
   }

   private boolean copyValues(ValueSource lValueSource, ValueSource rValueSource, List<RValue> lValueUnwoundList, boolean initialAssignment, Statement currentStmt, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt) {
      if(lValueSource == null || rValueSource == null)
         return false;
      if(lValueSource.isSimple() && rValueSource.isSimple()) {
         stmtIt.previous();
         LValue lValueRef = (LValue) lValueSource.getSimpleValue(getScope());
         RValue rValueRef = rValueSource.getSimpleValue(getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueRef);
         Statement copyStmt = new StatementAssignment(lValueRef, rValueRef, initialAssignment, currentStmt.getSource(), Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         getLog().append("Adding value simple copy " + copyStmt.toString(getProgram(), false));
         return true;
      } else if(lValueSource.isBulkCopyable() && rValueSource.isBulkCopyable()) {
         // Use bulk unwinding for a struct member that is an array
         stmtIt.previous();
         if(lValueSource.getArraySpec() != null)
            if(rValueSource.getArraySpec() == null || !lValueSource.getArraySpec().equals(rValueSource.getArraySpec()))
               throw new RuntimeException("ArraySpec mismatch!");
         LValue lValueMemberVarRef = lValueSource.getBulkLValue(getScope());
         RValue rValueBulkUnwinding = rValueSource.getBulkRValue(getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueMemberVarRef);
         Statement copyStmt = new StatementAssignment(lValueMemberVarRef, rValueBulkUnwinding, initialAssignment, currentStmt.getSource(), Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         getLog().append("Adding value bulk copy " + copyStmt.toString(getProgram(), false));
         return true;
      } else if(lValueSource.isUnwindable() && rValueSource.isUnwindable()) {
         getLog().append("Unwinding value copy " + currentStmt.toString(getProgram(), false));
         for(String memberName : lValueSource.getMemberNames(getScope())) {
            ValueSource lValueSubSource = lValueSource.getMemberUnwinding(memberName, getProgram(), getScope(), currentStmt, currentBlock, stmtIt);
            ValueSource rValueSubSource = rValueSource.getMemberUnwinding(memberName, getProgram(), getScope(), currentStmt, currentBlock, stmtIt);
            boolean success = copyValues(lValueSubSource, rValueSubSource, lValueUnwoundList, initialAssignment, currentStmt, currentBlock, stmtIt);
            if(!success)
               throw new InternalError("Error during value unwinding copy! ", currentStmt);
         }
         return true;
      }
      return false;
   }

   /**
    * Get a value source for copying a value
    *
    * @param value The value being copied
    * @param currentStmt The current statement
    * @param stmtIt The statement iterator
    * @param currentBlock The current block
    * @return The value source for copying. null if no value source can be created.
    */
   public static ValueSource getValueSource(Program program, ProgramScope programScope, Value value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      final SymbolType valueType = SymbolTypeInference.inferType(programScope, (RValue) value);
      if(valueType instanceof SymbolTypeStruct && value instanceof CastValue && ((CastValue) value).getValue() instanceof ValueList) {
         ValueList valueList = (ValueList) ((CastValue) value).getValue();
         final StructDefinition structDefinition = ((SymbolTypeStruct) valueType).getStructDefinition(programScope);
         int numMembers = structDefinition.getAllVars(false).size();
         if(numMembers != valueList.getList().size()) {
            throw new CompileError("Struct initialization list has wrong size. Need  " + numMembers + " got " + valueList.getList().size(), currentStmt);
         }
         return new ValueSourceStructValueList(valueList, structDefinition);
      }
      while(value instanceof CastValue)
         value = ((CastValue) value).getValue();
      if(value instanceof VariableRef) {
         Variable variable = programScope.getVariable((VariableRef) value);
         return new ValueSourceVariable(variable);
      }
      if(value instanceof StructZero)
         return new ValueSourceZero(((StructZero) value).getTypeStruct(), null);
      if(value instanceof ConstantValue)
         return new ValueSourceConstant(((ConstantValue) value).getType(programScope), null, (ConstantValue) value);
      if(value instanceof PointerDereferenceSimple)
         return new ValueSourcePointerDereferenceSimple((PointerDereferenceSimple) value, valueType, null);
      if(value instanceof PointerDereferenceIndexed)
         return new ValueSourcePointerDereferenceIndexed((PointerDereferenceIndexed) value, valueType, null);
      if(value instanceof StructMemberRef) {
         final RValue structValue = ((StructMemberRef) value).getStruct();
         final ValueSource structValueSource = getValueSource(program, programScope, structValue, currentStmt, stmtIt, currentBlock);
         return structValueSource.getMemberUnwinding(((StructMemberRef) value).getMemberName(), program, programScope, currentStmt, currentBlock, stmtIt);
      }
      return null;
   }

   /**
    * Examine a value - and if it represents a struct get the unwinding information for the struct members
    *
    * @param value The struct value
    * @param currentStmt Program Context information. Current statement.
    * @param stmtIt Program Context information. Statement list iterator.
    * @param currentBlock Program Context information. Current block
    * @return null if the value is not a struct. Unwinding for the passed value if it is a struct. {@link #POSTPONE_UNWINDING} if the struct is not ready for unwinding yet.
    */
   private StructUnwinding getStructMemberUnwinding(RValue value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(value != null) {
         SymbolType valueType = SymbolTypeInference.inferType(getScope(), value);
         if(valueType instanceof SymbolTypeStruct) {
            SymbolTypeStruct structType = (SymbolTypeStruct) valueType;
            StructDefinition structDefinition = structType.getStructDefinition(getScope());
            if(value instanceof CastValue && ((CastValue) value).getValue() instanceof ValueList) {
               ValueList valueList = (ValueList) ((CastValue) value).getValue();
               int numMembers = structDefinition.getAllVars(false).size();
               if(numMembers != valueList.getList().size()) {
                  throw new CompileError("Struct initialization list has wrong size. Need  " + numMembers + " got " + valueList.getList().size(), currentStmt);
               }
               return new StructUnwindingValueList(valueList, structDefinition);
            }
            if(value instanceof CastValue)
               value = ((CastValue) value).getValue();

            if(value instanceof VariableRef) {
               Variable variable = getScope().getVariable((VariableRef) value);
               if(variable.isStructUnwind()) {
                  StructVariableMemberUnwinding structVariableMemberUnwinding = getProgram().getStructVariableMemberUnwinding();
                  return structVariableMemberUnwinding.getVariableUnwinding((VariableRef) value);
               } else if(variable.isStructClassic()) {
                  return new StructUnwindingVariable(variable, structDefinition);
               }
            } else if(value instanceof StructMemberRef && ((StructMemberRef) value).getStruct() instanceof VariableRef) {
               getLog().append("Postponing unwinding for " + currentStmt.toString(getProgram(), false));
               return POSTPONE_UNWINDING;
            } else if(value instanceof PointerDereferenceSimple) {
               return new StructUnwindingPointerDerefSimple((PointerDereferenceSimple) value, structDefinition, stmtIt, currentBlock, currentStmt);
            } else if(value instanceof PointerDereferenceIndexed) {
               return new StructUnwindingPointerDerefIndexed((PointerDereferenceIndexed) value, structDefinition, stmtIt, currentBlock, currentStmt);
            } else if(value instanceof StructMemberRef && ((StructMemberRef) value).getStruct() instanceof PointerDereferenceIndexed) {
               final StructMemberRef structMemberRef = (StructMemberRef) value;
               return new StructUnwindingMemberOfPointerDerefIndexed((PointerDereferenceIndexed) structMemberRef.getStruct(), structMemberRef.getMemberName(), structDefinition, stmtIt, currentBlock, currentStmt);
            } else if(value instanceof ConstantStructValue) {
               return new StructUnwindingConstant((ConstantStructValue) value, structDefinition);
            } else if(value instanceof StructZero) {
               return new StructUnwindingZero((StructZero) value, structDefinition);
            } else {
               throw new InternalError("Struct unwinding not implemented for " + value.toString(getProgram()));
            }
         }
      }
      return null;
   }

   /** Singleton signaling that unwinding should be postponed. */
   private static final StructUnwinding POSTPONE_UNWINDING = new StructUnwinding() {

      @Override
      public List<String> getMemberNames() {
         return null;
      }

      @Override
      public RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope) {
         return null;
      }
   };


}
