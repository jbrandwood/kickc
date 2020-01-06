package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
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
      if(getProgram().getStructUnwinding() == null) {
         getProgram().setStructUnwinding(new StructUnwinding());
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
                  StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                  if(structMemberRef.getStruct() instanceof VariableRef) {
                     StructMemberUnwinding memberVariables = getStructMemberUnwinding(structMemberRef.getStruct(), currentStmt, stmtIt, currentBlock);
                     if(memberVariables != null && memberVariables != POSTPONE_UNWINDING) {
                        RValueUnwinding memberUnwinding = memberVariables.getMemberUnwinding(structMemberRef.getMemberName());
                        RValue structMemberVariable = memberUnwinding.getUnwinding(getScope());
                        getLog().append("Replacing struct member reference " + structMemberRef.toString(getProgram()) + " with member unwinding reference " + structMemberVariable.toString(getProgram()));
                        programValue.set(structMemberVariable);
                        modified.set(true);
                     }
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
      StructMemberUnwinding lValueUnwinding = getStructMemberUnwinding(call.getlValue(), call, stmtIt, currentBlock);
      if(lValueUnwinding != null && lValueUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueUnwinding.getMemberNames()) {
            RValueUnwinding memberUnwinding = lValueUnwinding.getMemberUnwinding(memberName);
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
         StructMemberUnwinding parameterUnwinding = getStructMemberUnwinding(parameter, call, stmtIt, currentBlock);
         if(parameterUnwinding != null && parameterUnwinding != POSTPONE_UNWINDING) {
            // Passing a struct variable - convert it to member variables
            for(String memberName : parameterUnwinding.getMemberNames()) {
               RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName);
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
      StructMemberUnwinding returnVarUnwinding = getStructMemberUnwinding(statementReturn.getValue(), statementReturn, stmtIt, currentBlock);
      if(returnVarUnwinding != null && returnVarUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : returnVarUnwinding.getMemberNames()) {
            RValueUnwinding memberUnwinding = returnVarUnwinding.getMemberUnwinding(memberName);
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
               StructUnwinding structUnwinding = getProgram().getStructUnwinding();
               StructUnwinding.VariableUnwinding parameterUnwinding = structUnwinding.getVariableUnwinding(parameter.getRef());
               for(String memberName : parameterUnwinding.getMemberNames()) {
                  RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName);
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

         // Check for bulk assignable values
         if(isBulkAssignable(lValue) && isBulkAssignable(rValue)) {
            RValueUnwinding lValueUnwinding = getValueUnwinding(lValue, assignment, stmtIt, currentBlock);
            RValueUnwinding rValueUnwinding = getValueUnwinding(rValue, assignment, stmtIt, currentBlock);
            unwindAssignment(lValueUnwinding, rValueUnwinding, null, stmtIt, initialAssignment, source);
         }

         // Check for struct unwinding
         StructMemberUnwinding lValueUnwinding = getStructMemberUnwinding(lValue, assignment, stmtIt, currentBlock);
         if(lValueUnwinding == null)
            return false;
         if(lValueUnwinding == POSTPONE_UNWINDING)
            return true;
         if(rValue instanceof StructUnwoundPlaceholder)
            return false;
         SymbolType rValueType = SymbolTypeInference.inferType(getScope(), rValue);
         if(rValueType.equals(lValueStructType)) {
            StructMemberUnwinding rValueUnwinding = getStructMemberUnwinding(rValue, assignment, stmtIt, currentBlock);
            if(rValueUnwinding == null) {
               throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
            }
            if(rValueUnwinding == POSTPONE_UNWINDING)
               return true;
            List<RValue> lValueUnwoundPlaceholder = new ArrayList<>();
            for(String memberName : lValueUnwinding.getMemberNames()) {
               RValueUnwinding lValueMemberUnwinding = lValueUnwinding.getMemberUnwinding(memberName);
               RValueUnwinding rValueMemberUnwinding = rValueUnwinding.getMemberUnwinding(memberName);
               unwindAssignment(lValueMemberUnwinding, rValueMemberUnwinding, lValueUnwoundPlaceholder, stmtIt, initialAssignment, source);
            }
            StructUnwoundPlaceholder unwoundPlaceholder = new StructUnwoundPlaceholder(lValueStructType, lValueUnwoundPlaceholder);
            if(lValue instanceof VariableRef) {
               assignment.setrValue2(unwoundPlaceholder);
            } else {
               stmtIt.remove();
            }
            return true;
         }
         throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
      }
      return false;
   }

   /**
    * Unwind assignment from an RValue to an LValue
    *
    * @param lValueUnwinding The unwinding of the LValue
    * @param rValueUnwinding The unwinding of the RValue
    * @param lValueUnwoundList will receive the actual unwinding used for the lValue (if non-null)
    * @param stmtIt Statement iterator used for adding unwound assignment statements (before the current statement)
    * @param initialAssignment Is this the initial assignment
    * @param source The statement source
    */
   private void unwindAssignment(RValueUnwinding lValueUnwinding, RValueUnwinding rValueUnwinding, List<RValue> lValueUnwoundList, ListIterator<Statement> stmtIt, boolean initialAssignment, StatementSource source) {
      if(lValueUnwinding.isBulkCopyable() && rValueUnwinding.isBulkCopyable()) {
         // Use bulk unwinding for a struct member that is an array
         stmtIt.previous();
         //RValue lValueMemberVarPointer = lValueUnwinding.getBulkLValue(getScope());
         //LValue lValueMemberVarRef = new PointerDereferenceSimple(lValueMemberVarPointer);
         //if(rValueUnwinding.getArraySpec()==null || !lValueUnwinding.getArraySpec().equals(rValueUnwinding.getArraySpec()))
         //   throw new RuntimeException("ArraySpec mismatch!");
         LValue lValueMemberVarRef = lValueUnwinding.getBulkLValue(getScope());
         RValue rValueBulkUnwinding = rValueUnwinding.getBulkRValue(getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueMemberVarRef);
         Statement copyStmt = new StatementAssignment(lValueMemberVarRef, rValueBulkUnwinding, initialAssignment, source, Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
      } else {
         // Unwinding a non-array struct member
         stmtIt.previous();
         LValue lValueMemberVarRef = (LValue) lValueUnwinding.getUnwinding(getScope());
         RValue rValueMemberVarRef = rValueUnwinding.getUnwinding(getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueMemberVarRef);
         Statement copyStmt = new StatementAssignment(lValueMemberVarRef, rValueMemberVarRef, initialAssignment, source, Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         getLog().append("Adding struct value member variable copy " + copyStmt.toString(getProgram(), false));
      }
   }

   /**
    * Determine whether a value can be used in a bulk assignment
    *
    * @param value The value
    * @return true if the value is bulk assignable
    */
   private boolean isBulkAssignable(RValue value) {
      /*
      if(value instanceof SymbolVariableRef) {
         Variable var = getScope().getVar((SymbolVariableRef) value);
         if(var.isStructClassic())
            // A load/store struct value
            return true;
      }
      if(value instanceof StructZero)
         // A zero-filled struct value
         return true;
      if(value instanceof ConstantStructValue)
         // A constant struct value
         return true;
      // TODO: Add support for arrays
      // Not bulk assignable
      
       */
      return false;
   }

   /**
    * Get unwinding for a value
    *
    * @param value The value
    * @return Unwinding for the value
    */
   private RValueUnwinding getValueUnwinding(RValue value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(value != null) {
         SymbolType valueType = SymbolTypeInference.inferType(getScope(), value);
         if(valueType instanceof SymbolTypeStruct) {
            if(value instanceof VariableRef) {
               Variable variable = getScope().getVariable((VariableRef) value);
               if(variable.isStructClassic()) {
                  return new StructVariableValueUnwinding(variable);
               }
            }
            if(value instanceof StructZero) {
               return new ZeroValueUnwinding(valueType, null);
            }
            if(value instanceof ConstantStructValue) {
               return new ConstantValueUnwinding(valueType, null, (ConstantStructValue) value);
            }
         }
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
   private StructMemberUnwinding getStructMemberUnwinding(RValue value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
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
               return new StructMemberUnwindingValueList(valueList, structDefinition);
            }
            if(value instanceof CastValue)
               value = ((CastValue) value).getValue();

            if(value instanceof VariableRef) {
               Variable variable = getScope().getVariable((VariableRef) value);
               if(variable.isStructUnwind()) {
                  StructUnwinding structUnwinding = getProgram().getStructUnwinding();
                  return structUnwinding.getVariableUnwinding((VariableRef) value);
               } else if(variable.isStructClassic()) {
                  return new StructVariableMemberUnwinding(variable, structDefinition, currentBlock, stmtIt, currentStmt);
               }
            } else if(value instanceof StructMemberRef && ((StructMemberRef) value).getStruct() instanceof VariableRef) {
               return POSTPONE_UNWINDING;
            } else if(value instanceof PointerDereferenceSimple) {
               return new StructMemberUnwindingPointerDerefSimple((PointerDereferenceSimple) value, structDefinition, stmtIt, currentBlock, currentStmt);
            } else if(value instanceof PointerDereferenceIndexed) {
               return new StructMemberUnwindingPointerDerefIndexed((PointerDereferenceIndexed) value, structDefinition, stmtIt, currentBlock, currentStmt);
            } else if(value instanceof ConstantStructValue) {
               return new StructMemberUnwindingConstantValue((ConstantStructValue) value, structDefinition);
            } else if(value instanceof StructZero) {
               return new StructMemberUnwindingZero((StructZero) value, structDefinition);
            } else {
               throw new InternalError("Struct unwinding not implemented for " + value.toString(getProgram()));
            }
         }
      }
      return null;
   }

   /** Singleton signaling that unwinding should be postponed. */
   private static final StructMemberUnwinding POSTPONE_UNWINDING = new StructMemberUnwinding() {

      @Override
      public List<String> getMemberNames() {
         return null;
      }

      @Override
      public RValueUnwinding getMemberUnwinding(String memberName) {
         return null;
      }
   };


}
