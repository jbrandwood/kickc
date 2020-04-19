package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.unwinding.ValueSource;
import dk.camelot64.kickc.passes.unwinding.ValueSourceFactory;

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
                  StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
                  final ValueSource structValueSource = ValueSourceFactory.getValueSource(structMemberRef.getStruct(), getProgram(), getScope(), currentStmt, stmtIt, currentBlock);
                  if(structValueSource != null) {
                     final ValueSource memberUnwinding = structValueSource.getMemberUnwinding(structMemberRef.getMemberName(), getProgram(), getScope(), currentStmt, stmtIt, currentBlock);
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
      final ValueSource valueSource = ValueSourceFactory.getValueSource(call.getlValue(), getProgram(), getScope(), call, stmtIt, currentBlock);
      RValue unwoundLValue = unwindValue(valueSource, call, stmtIt, currentBlock);
      if(unwoundLValue != null && !call.getlValue().equals(unwoundLValue)) {
         call.setlValue((LValue) unwoundLValue);
         getLog().append("Converted procedure call LValue to member unwinding " + call.toString(getProgram(), false));
         lvalUnwound = true;
      }

      // Unwind any struct value parameters
      ArrayList<RValue> unwoundParameters = new ArrayList<>();
      boolean anyParameterUnwound = false;
      for(RValue parameter : call.getParameters()) {
         boolean unwound = false;
         final ValueSource parameterSource = ValueSourceFactory.getValueSource(parameter, getProgram(), getScope(), call, stmtIt, currentBlock);
         if(parameterSource != null && parameterSource.isUnwindable()) {
            // Passing a struct variable - convert it to member variables
            for(String memberName : parameterSource.getMemberNames(getScope())) {
               ValueSource memberUnwinding = parameterSource.getMemberUnwinding(memberName, getProgram(), getScope(), call, stmtIt, currentBlock);
               unwoundParameters.add(memberUnwinding.getSimpleValue(getScope()));
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
         getLog().append("Converted call struct value parameter to member unwinding " + call.toString(getProgram(), false));
      }
      return (anyParameterUnwound || lvalUnwound);
   }

   /**
    * Unwind an LVa.lue to a ValueList if it is unwindable.
    * @param value The value to unwind
    * @param statement The current statement
    * @param stmtIt Statement iterator
    * @param currentBlock current block
    * @return The unwound ValueList. null if the value is not unwindable.
    */
   private RValue unwindValue(ValueSource lValueSource, Statement statement, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      if(lValueSource==null) {
         return null;
      } else if(lValueSource.isSimple()) {
         return lValueSource.getSimpleValue(getScope());
      } else if(lValueSource.isUnwindable()) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueSource.getMemberNames(getScope())) {
            ValueSource memberUnwinding = lValueSource.getMemberUnwinding(memberName, getProgram(), getScope(), statement, stmtIt, currentBlock);
            unwoundMembers.add(unwindValue(memberUnwinding, statement, stmtIt, currentBlock));
         }
         return new ValueList(unwoundMembers);
      } else {
         return null;
      }
   }

   /**
    * Unwind any return value that is a struct value into the member values
    *
    * @param statementReturn The return to unwind
    */

   private boolean unwindReturn(StatementReturn statementReturn, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      boolean unwound = false;
      final ValueSource valueSource = ValueSourceFactory.getValueSource(statementReturn.getValue(), getProgram(), getScope(), statementReturn, stmtIt, currentBlock);
      RValue unwoundValue = unwindValue(valueSource, statementReturn, stmtIt, currentBlock);
      if(unwoundValue != null && !statementReturn.getValue().equals(unwoundValue)) {
         statementReturn.setValue(unwoundValue);
         getLog().append("Converted procedure struct return value to member unwinding " + statementReturn.toString(getProgram(), false));
         unwound = true;
      }
      return unwound;
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
                  final SymbolVariableRef memberUnwinding = parameterUnwinding.getMemberUnwound(memberName);
                  unwoundParameterNames.add(memberUnwinding.getLocalName());
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

         ValueSource lValueSource = ValueSourceFactory.getValueSource(lValue, getProgram(), getScope(), assignment, stmtIt, currentBlock);
         ValueSource rValueSource = ValueSourceFactory.getValueSource(rValue, getProgram(), getScope(), assignment, stmtIt, currentBlock);
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
            ValueSource lValueSubSource = lValueSource.getMemberUnwinding(memberName, getProgram(), getScope(), currentStmt, stmtIt, currentBlock);
            ValueSource rValueSubSource = rValueSource.getMemberUnwinding(memberName, getProgram(), getScope(), currentStmt, stmtIt, currentBlock);
            boolean success = copyValues(lValueSubSource, rValueSubSource, lValueUnwoundList, initialAssignment, currentStmt, currentBlock, stmtIt);
            if(!success)
               throw new InternalError("Error during value unwinding copy! ", currentStmt);
         }
         return true;
      }
      return false;
   }

}
