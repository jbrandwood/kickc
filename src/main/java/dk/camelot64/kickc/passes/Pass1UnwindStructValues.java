package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.unwinding.ValueSource;
import dk.camelot64.kickc.passes.unwinding.ValueSourceFactory;
import dk.camelot64.kickc.passes.unwinding.ValueSourceParamValue;

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
      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               modified |= unwindAssignment((StatementAssignment) statement, stmtIt, block, getProgram());
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
                  final ValueSource structValueSource = ValueSourceFactory.getValueSource(structMemberRef.getStruct(), getProgram(), getProgramScope(), currentStmt, stmtIt, currentBlock);
                  if(structValueSource != null) {
                     final ValueSource memberUnwinding = structValueSource.getMemberUnwinding(structMemberRef.getMemberName(), getProgram(), getProgramScope(), currentStmt, stmtIt, currentBlock);
                     RValue memberSimpleValue = memberUnwinding.getSimpleValue(getProgramScope());
                     if(getLog().isVerboseStructUnwind())
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
   private boolean unwindCall(StatementCall call, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      final Procedure procedure = getProgramScope().getProcedure(call.getProcedure());

      // Unwind struct value return value

      boolean lvalUnwound = false;
      Variable procReturnVar = procedure.getLocalVariable("return");
      // TODO: Return-variable has been unwound - detect that instead - use getProgram().getStructVariableMemberUnwinding().getUnwindingMaster() like for parameters
      if(procReturnVar != null && procReturnVar.isStructUnwind()) {
         if(call.getlValue() != null && !(call.getlValue() instanceof ValueList)) {
            // Return value already unwound - move on
            final ValueSource valueSource = ValueSourceFactory.getValueSource(call.getlValue(), getProgram(), getProgramScope(), call, stmtIt, currentBlock);
            RValue unwoundLValue = unwindValue(valueSource, call, stmtIt, currentBlock);
            if(call.getlValue().equals(unwoundLValue))
               throw new CompileError("Call return value already unwound", call);
            if(unwoundLValue == null)
               throw new CompileError("Cannot unwind call return value", call);
            call.setlValue((LValue) unwoundLValue);
            if(getLog().isVerboseStructUnwind())
               getLog().append("Converted procedure call LValue to member unwinding " + call.toString(getProgram(), false));
            lvalUnwound = true;
         }
      }

      // Unwind any struct value parameters
      ArrayList<RValue> unwoundParameters = new ArrayList<>();
      boolean anyParameterUnwound = false;
      final List<Variable> procParameters = procedure.getParameters();
      final List<RValue> callParameters = call.getParameters();
      if(callParameters != null && callParameters.size() > 0) {
         for(int idx_call = 0, idx_proc = 0; idx_call < callParameters.size(); idx_call++) {
            final RValue callParameter = callParameters.get(idx_call);
            final Variable procParameter = procParameters.get(idx_proc);
            boolean unwound = false;
            final SymbolVariableRef unwindingMaster = getProgram().getStructVariableMemberUnwinding().getUnwindingMaster(procParameter.getRef());
            if(unwindingMaster != null) {
               // The procedure parameter is unwound
               final ValueSource parameterSource = ValueSourceFactory.getValueSource(callParameter, getProgram(), getProgramScope(), call, stmtIt, currentBlock);
               if(parameterSource != null && parameterSource.isUnwindable())
                  // Passing an unwinding struct value
                  for(String memberName : parameterSource.getMemberNames(getProgramScope())) {
                     ValueSource memberUnwinding = parameterSource.getMemberUnwinding(memberName, getProgram(), getProgramScope(), call, stmtIt, currentBlock);
                     unwoundParameters.add(memberUnwinding.getSimpleValue(getProgramScope()));
                     unwound = true;
                     anyParameterUnwound = true;
                     idx_proc++;
                  }
               else
                  idx_proc++;
            } else {
               idx_proc++;
            }
            if(!unwound) {
               unwoundParameters.add(callParameter);
            }
         }
      }

      if(anyParameterUnwound) {
         call.setParameters(unwoundParameters);
         if(getLog().isVerboseStructUnwind())
            getLog().append("Converted call struct value parameter to member unwinding " + call.toString(getProgram(), false));
      }
      return (anyParameterUnwound || lvalUnwound);
   }

   /**
    * Unwind an LValue to a ValueList if it is unwindable.
    *
    * @param value The value to unwind
    * @param statement The current statement
    * @param stmtIt Statement iterator
    * @param currentBlock current block
    * @return The unwound ValueList. null if the value is not unwindable.
    */
   private RValue unwindValue(ValueSource lValueSource, Statement statement, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      if(lValueSource == null) {
         return null;
      } else if(lValueSource.isSimple()) {
         return lValueSource.getSimpleValue(getProgramScope());
      } else if(lValueSource.isUnwindable()) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueSource.getMemberNames(getProgramScope())) {
            ValueSource memberUnwinding = lValueSource.getMemberUnwinding(memberName, getProgram(), getProgramScope(), statement, stmtIt, currentBlock);
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

   private boolean unwindReturn(StatementReturn statementReturn, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      final RValue returnValue = statementReturn.getValue();
      if(returnValue == null)
         return false;
      if(returnValue instanceof SymbolVariableRef)
         if(getProgramScope().getVar((SymbolVariableRef) returnValue).isStructClassic())
            return false;
      boolean unwound = false;
      final ValueSource valueSource = ValueSourceFactory.getValueSource(returnValue, getProgram(), getProgramScope(), statementReturn, stmtIt, currentBlock);
      RValue unwoundValue = unwindValue(valueSource, statementReturn, stmtIt, currentBlock);
      if(unwoundValue != null && !returnValue.equals(unwoundValue)) {
         statementReturn.setValue(unwoundValue);
         if(getLog().isVerboseStructUnwind())
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
      for(Procedure procedure : getProgramScope().getAllProcedures(true)) {
         ArrayList<String> unwoundParameterNames = new ArrayList<>();
         boolean procedureUnwound = false;
         for(Variable parameter : procedure.getParameters()) {
            if(parameter.isStructUnwind()) {
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
            if(getLog().isVerboseStructUnwind())
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
   public static boolean unwindAssignment(StatementAssignment assignment, ListIterator<Statement> stmtIt, Graph.Block currentBlock, Program program) {
      LValue lValue = assignment.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(program.getScope(), lValue);

      if(lValueType instanceof SymbolTypeStruct && assignment.getOperator() == null) {

         // Assignment to a struct
         SymbolTypeStruct lValueStructType = (SymbolTypeStruct) lValueType;
         RValue rValue = assignment.getrValue2();
         boolean initialAssignment = assignment.isInitialAssignment();
         StatementSource source = assignment.getSource();

         // Check if this is already a bulk assignment - or an unwound placeholder
         if(rValue instanceof MemcpyValue || rValue instanceof MemsetValue || rValue instanceof StructUnwoundPlaceholder)
            return false;

         ValueSource lValueSource = ValueSourceFactory.getValueSource(lValue, program, program.getScope(), assignment, stmtIt, currentBlock);
         ValueSource rValueSource = ValueSourceFactory.getValueSource(rValue, program, program.getScope(), assignment, stmtIt, currentBlock);
         List<RValue> lValueUnwoundList = new ArrayList<>();
         if(copyValues(lValueSource, rValueSource, lValueUnwoundList, initialAssignment, assignment, currentBlock, stmtIt, program)) {
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

   public static boolean copyValues(ValueSource lValueSource, ValueSource rValueSource, List<RValue> lValueUnwoundList, boolean initialAssignment, Statement currentStmt, Graph.Block currentBlock, ListIterator<Statement> stmtIt, Program program) {
      if(lValueSource == null || rValueSource == null)
         return false;
      if(rValueSource instanceof ValueSourceParamValue && lValueSource.equals(((ValueSourceParamValue) rValueSource).getValueSource()))
         return false;
      if(lValueSource.equals(rValueSource))
         return true;
      if(lValueSource.isSimple() && rValueSource.isSimple()) {
         stmtIt.previous();
         LValue lValueRef = (LValue) lValueSource.getSimpleValue(program.getScope());
         RValue rValueRef = rValueSource.getSimpleValue(program.getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueRef);
         Statement copyStmt = new StatementAssignment(lValueRef, rValueRef, initialAssignment, currentStmt.getSource(), Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         if(program.getLog().isVerboseStructUnwind())
            program.getLog().append("Adding value simple copy " + copyStmt.toString(program, false));
         return true;
      } else if(lValueSource.isBulkCopyable() && rValueSource.isBulkCopyable()) {

         /* TODO: Attempt to mix struct mode classic with unwinding
         if(lValueSource instanceof ValueSourceVariable && rValueSource instanceof ValueSourceVariable)
            if(((ValueSourceVariable) lValueSource).getVariable().isStructClassic() && ((ValueSourceVariable) rValueSource).getVariable().isStructClassic())
               return false;
          */

         // Use bulk unwinding for a struct member that is an array
         stmtIt.previous();
         if(lValueSource.getArraySpec() != null)
            if(rValueSource.getArraySpec() == null || !lValueSource.getArraySpec().equals(rValueSource.getArraySpec()))
               throw new RuntimeException("ArraySpec mismatch!");
         LValue lValueMemberVarRef = lValueSource.getBulkLValue(program.getScope());
         RValue rValueBulkUnwinding = rValueSource.getBulkRValue(program.getScope());
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueMemberVarRef);
         Statement copyStmt = new StatementAssignment(lValueMemberVarRef, rValueBulkUnwinding, initialAssignment, currentStmt.getSource(), Comment.NO_COMMENTS);
         stmtIt.add(copyStmt);
         stmtIt.next();
         if(program.getLog().isVerboseStructUnwind())
            program.getLog().append("Adding value bulk copy " + copyStmt.toString(program, false));
         return true;
      } else if(lValueSource.isUnwindable() && rValueSource.isUnwindable()) {
         if(program.getLog().isVerboseStructUnwind())
            program.getLog().append("Unwinding value copy " + currentStmt.toString(program, false));

         //Special handling of unions
         if(lValueSource.getSymbolType() instanceof SymbolTypeStruct) {
            SymbolTypeStruct structType = (SymbolTypeStruct) lValueSource.getSymbolType();
            if(structType.isUnion()) {
               // Find the largest member to unwind to
               final StructDefinition unionDefinition = structType.getStructDefinition(program.getScope());
               int unionBytes = structType.getSizeBytes();
               for(String memberName : lValueSource.getMemberNames(program.getScope())) {
                  final Variable unionMember = unionDefinition.getMember(memberName);
                  final int memberBytes = unionMember.getType().getSizeBytes();
                  if(memberBytes==unionBytes) {
                     // Found a union member with the total number of bytes - unwind to this member
                     ValueSource lValueSubSource = lValueSource.getMemberUnwinding(memberName, program, program.getScope(), currentStmt, stmtIt, currentBlock);
                     ValueSource rValueSubSource = rValueSource.getMemberUnwinding(memberName, program, program.getScope(), currentStmt, stmtIt, currentBlock);
                     boolean success = copyValues(lValueSubSource, rValueSubSource, lValueUnwoundList, initialAssignment, currentStmt, currentBlock, stmtIt, program);
                     if(!success)
                        throw new InternalError("Error during value unwinding copy! ", currentStmt);
                     return true;
                  }
               }
            }
         }

         // Normal unwinding of non-unions
         for(String memberName : lValueSource.getMemberNames(program.getScope())) {
            ValueSource lValueSubSource = lValueSource.getMemberUnwinding(memberName, program, program.getScope(), currentStmt, stmtIt, currentBlock);
            ValueSource rValueSubSource = rValueSource.getMemberUnwinding(memberName, program, program.getScope(), currentStmt, stmtIt, currentBlock);
            boolean success = copyValues(lValueSubSource, rValueSubSource, lValueUnwoundList, initialAssignment, currentStmt, currentBlock, stmtIt, program);
            if(!success)
               throw new InternalError("Error during value unwinding copy! ", currentStmt);
         }
         return true;
      }
      return false;
   }

}
