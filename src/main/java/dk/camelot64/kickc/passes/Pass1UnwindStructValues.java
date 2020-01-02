package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.OperatorSizeOf;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
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
                     StructUnwinding.StructMemberUnwinding memberVariables = getStructMemberUnwinding(structMemberRef.getStruct(), currentStmt, stmtIt, currentBlock);
                     if(memberVariables != null && memberVariables != POSTPONE_UNWINDING) {
                        //RValue structMemberVariable = memberVariables.getMemberUnwinding(structMemberRef.getMemberName(), getScope());
                        StructUnwinding.RValueUnwinding memberUnwinding = memberVariables.getMemberUnwinding(structMemberRef.getMemberName());
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
      StructUnwinding.StructMemberUnwinding lValueUnwinding = getStructMemberUnwinding(call.getlValue(), call, stmtIt, currentBlock);
      if(lValueUnwinding != null && lValueUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : lValueUnwinding.getMemberNames()) {
            StructUnwinding.RValueUnwinding memberUnwinding = lValueUnwinding.getMemberUnwinding(memberName);
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
         StructUnwinding.StructMemberUnwinding parameterUnwinding = getStructMemberUnwinding(parameter, call, stmtIt, currentBlock);
         if(parameterUnwinding != null && parameterUnwinding != POSTPONE_UNWINDING) {
            // Passing a struct variable - convert it to member variables
            for(String memberName : parameterUnwinding.getMemberNames()) {
               StructUnwinding.RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName);
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
      StructUnwinding.StructMemberUnwinding returnVarUnwinding = getStructMemberUnwinding(statementReturn.getValue(), statementReturn, stmtIt, currentBlock);
      if(returnVarUnwinding != null && returnVarUnwinding != POSTPONE_UNWINDING) {
         ArrayList<RValue> unwoundMembers = new ArrayList<>();
         for(String memberName : returnVarUnwinding.getMemberNames()) {
            StructUnwinding.RValueUnwinding memberUnwinding = returnVarUnwinding.getMemberUnwinding(memberName);
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
                  StructUnwinding.RValueUnwinding memberUnwinding = parameterUnwinding.getMemberUnwinding(memberName);
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
      if(assignment.getOperator() == null && lValueType instanceof SymbolTypeStruct) {
         SymbolTypeStruct lValueStructType = (SymbolTypeStruct) lValueType;
         RValue rValue = assignment.getrValue2();
         boolean initialAssignment = assignment.isInitialAssignment();
         StatementSource source = assignment.getSource();

         // Check for constant struct value assignment
         if(rValue instanceof ConstantValue && 1 == 0) {
            // TODO: Only handle __ma structs here!
            if(rValue instanceof StructZero) {
               // Zero-fill the struct value
               stmtIt.previous();
               ConstantValue structSize = OperatorSizeOf.getSizeOfConstantVar(getScope(), lValueStructType);
               MemsetValue rValueMemset = new MemsetValue(structSize);
               Statement copyStmt = new StatementAssignment(lValue, rValueMemset, initialAssignment, source, Comment.NO_COMMENTS);
               stmtIt.add(copyStmt);
               getLog().append("Adding struct variable zero-fill " + copyStmt.toString(getProgram(), false));
               stmtIt.next();
            } else if(rValue instanceof ConstantStructValue) {
               // Create global constant - and memcpy the value into the variable
               // Create a constant variable holding the array
               String constName = getScope().allocateIntermediateVariableName();
               Variable constVar = Variable.createConstant(constName, lValueType, getScope(), null, (ConstantValue) rValue, Scope.SEGMENT_DATA_DEFAULT);
               getScope().add(constVar);
               stmtIt.previous();
               ConstantValue structSize = OperatorSizeOf.getSizeOfConstantVar(getScope(), lValueStructType);
               MemcpyValue rValueMemcpy = new MemcpyValue(new PointerDereferenceSimple(constVar.getRef()), structSize);
               Statement copyStmt = new StatementAssignment(lValue, rValueMemcpy, initialAssignment, source, Comment.NO_COMMENTS);
               stmtIt.add(copyStmt);
               getLog().append("Adding struct variable copy " + copyStmt.toString(getProgram(), false));
               stmtIt.next();
            } else {
               throw new InternalError("Unknown constant struct value " + rValue);
            }
            return true;
         }

         // Check for struct unwinding
         StructUnwinding.StructMemberUnwinding lValueUnwinding = getStructMemberUnwinding(lValue, assignment, stmtIt, currentBlock);
         if(lValueUnwinding == null)
            return false;
         if(lValueUnwinding == POSTPONE_UNWINDING)
            return true;

         if(rValue instanceof StructUnwoundPlaceholder)
            return false;
         SymbolType rValueType = SymbolTypeInference.inferType(getScope(), rValue);
         if(rValueType.equals(lValueStructType)) {
            StructUnwinding.StructMemberUnwinding rValueUnwinding = getStructMemberUnwinding(rValue, assignment, stmtIt, currentBlock);
            if(rValueUnwinding == null) {
               throw new CompileError("Incompatible struct assignment " + assignment.toString(getProgram(), false), assignment);
            }
            if(rValueUnwinding == POSTPONE_UNWINDING)
               return true;
            List<RValue> lValueUnwoundPlaceholder = new ArrayList<>();
            for(String memberName : lValueUnwinding.getMemberNames()) {
               StructUnwinding.RValueUnwinding lValueMemberUnwinding = lValueUnwinding.getMemberUnwinding(memberName);
               StructUnwinding.RValueUnwinding rValueMemberUnwinding = rValueUnwinding.getMemberUnwinding(memberName);
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
   private void unwindAssignment(StructUnwinding.RValueUnwinding lValueUnwinding, StructUnwinding.RValueUnwinding rValueUnwinding, List<RValue> lValueUnwoundList, ListIterator<Statement> stmtIt, boolean initialAssignment, StatementSource source) {
      if(lValueUnwinding.getArraySpec() != null) {
         // Unwinding an array struct member
         stmtIt.previous();
         RValue lValueMemberVarPointer = lValueUnwinding.getUnwinding(getScope());
         LValue lValueMemberVarRef = new PointerDereferenceSimple(lValueMemberVarPointer);
         ConstantValue arraySize = lValueUnwinding.getArraySpec().getArraySize();
         RValue rValueArrayUnwinding = rValueUnwinding.getArrayUnwinding(getScope(), arraySize);
         if(lValueUnwoundList != null)
            lValueUnwoundList.add(lValueMemberVarPointer);
         Statement copyStmt = new StatementAssignment(lValueMemberVarRef, rValueArrayUnwinding, initialAssignment, source, Comment.NO_COMMENTS);
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
    * Examine a value - and if it represents a struct get the unwinding information for the struct members
    *
    * @param value The struct value
    * @param currentStmt Program Context information. Current statement.
    * @param stmtIt Program Context information. Statement list iterator.
    * @param currentBlock Program Context information. Current block
    * @return null if the value is not a struct. Unwinding for the passed value if it is a struct. {@link #POSTPONE_UNWINDING} if the struct is not ready for unwinding yet.
    */
   private StructUnwinding.StructMemberUnwinding getStructMemberUnwinding(RValue value, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
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
   private static final StructUnwinding.StructMemberUnwinding POSTPONE_UNWINDING = new StructUnwinding.StructMemberUnwinding() {

      @Override
      public List<String> getMemberNames() {
         return null;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return null;
      }
   };

   /** Unwinding for a simple pointer deref to a struct. */
   private static class StructMemberUnwindingPointerDerefSimple implements StructUnwinding.StructMemberUnwinding {

      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final PointerDereferenceSimple pointerDeref;
      private final Statement currentStmt;

      StructMemberUnwindingPointerDerefSimple(PointerDereferenceSimple pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
         this.pointerDeref = pointerDeref;
         this.currentStmt = currentStmt;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
               Variable member = structDefinition.getMember(memberName);
               Scope scope = programScope.getScope(currentBlock.getScope());
               Variable memberAddress = scope.addVariableIntermediate();
               memberAddress.setType(new SymbolTypePointer(member.getType()));
               CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
               // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
               stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
               // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER)
               return new PointerDereferenceSimple(memberAddress.getRef());
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               throw new RuntimeException("TODO: Implement!");
            }
         };
      }

   }

   /** Unwinding for a indexed pointer deref to a struct. */
   private static class StructMemberUnwindingPointerDerefIndexed implements StructUnwinding.StructMemberUnwinding {
      private final PointerDereferenceIndexed pointerDeref;
      private final StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final Statement currentStmt;

      StructMemberUnwindingPointerDerefIndexed(PointerDereferenceIndexed pointerDeref, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
         this.pointerDeref = pointerDeref;
         this.currentStmt = currentStmt;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
               Variable member = structDefinition.getMember(memberName);
               Scope scope = programScope.getScope(currentBlock.getScope());
               Variable memberAddress = scope.addVariableIntermediate();
               memberAddress.setType(new SymbolTypePointer(member.getType()));
               CastValue structTypedPointer = new CastValue(new SymbolTypePointer(member.getType()), pointerDeref.getPointer());
               // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
               stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
               // Unwind to *(ptr_struct+OFFSET_STRUCT_NAME_MEMBER[idx]
               return new PointerDereferenceIndexed(memberAddress.getRef(), pointerDeref.getIndex());
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               throw new RuntimeException("TODO: Implement!");
            }
         };
      }

   }

   /** Unwinding for constant struct value. */
   private static class StructMemberUnwindingConstantValue implements StructUnwinding.StructMemberUnwinding {
      private final ConstantStructValue constantStructValue;
      private final StructDefinition structDefinition;

      StructMemberUnwindingConstantValue(ConstantStructValue constantStructValue, StructDefinition structDefinition) {
         this.constantStructValue = constantStructValue;
         this.structDefinition = structDefinition;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               Variable member = structDefinition.getMember(memberName);
               return constantStructValue.getValue(member.getRef());
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               // Create a constant variable holding the array
               String constName = scope.allocateIntermediateVariableName();
               Variable member = structDefinition.getMember(memberName);
               SymbolType memberType = member.getType();
               ConstantValue constValue = constantStructValue.getValue(member.getRef());
               Variable constVar = Variable.createConstant(constName, memberType, scope, new ArraySpec(arraySize), constValue, Scope.SEGMENT_DATA_DEFAULT);
               scope.add(constVar);
               return new MemcpyValue(new PointerDereferenceSimple(constVar.getRef()), arraySize);
            }
         };
      }

   }

   /** Unwinding for a struct value with C-classic memory layout. */
   private static class StructVariableMemberUnwinding implements StructUnwinding.StructMemberUnwinding {
      private Variable variable;
      private StructDefinition structDefinition;
      private final ControlFlowBlock currentBlock;
      private final ListIterator<Statement> stmtIt;
      private final Statement currentStmt;

      public StructVariableMemberUnwinding(Variable variable, StructDefinition structDefinition, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt, Statement currentStmt) {
         this.variable = variable;
         this.structDefinition = structDefinition;
         this.currentBlock = currentBlock;
         this.stmtIt = stmtIt;
         this.currentStmt = currentStmt;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVars(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
               Variable member = structDefinition.getMember(memberName);
               ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
               ConstantCastValue structTypedPointer;
               if(member.isArray()) {
                  // Pointer to array element type
                  SymbolTypePointer arrayType = (SymbolTypePointer) member.getType();
                  structTypedPointer = new ConstantCastValue(new SymbolTypePointer(arrayType.getElementType()), structPointer);
                  // Calculate member address  (elementtype*)&struct + OFFSET_STRUCT_NAME_MEMBER
                  ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
                  // Unwind to *(&struct + OFFSET_STRUCT_NAME_MEMBER)
                  return memberArrayPointer;
               } else {
                  // Pointer to member element type
                  structTypedPointer = new ConstantCastValue(new SymbolTypePointer(member.getType()), structPointer);
                  // Calculate member address  (elementtype*)&struct + OFFSET_STRUCT_NAME_MEMBER
                  ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
                  // Unwind to *(&struct + OFFSET_STRUCT_NAME_MEMBER)
                  return new PointerDereferenceSimple(memberArrayPointer);
               }
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               RValue rValueMemberVarPointer = getUnwinding(scope);
               LValue rValueMemberVarRef = new PointerDereferenceSimple(rValueMemberVarPointer);
               return new MemcpyValue(rValueMemberVarRef, arraySize);
            }

         };
      }

   }

   /** Unwinding for StructZero */
   private static class StructMemberUnwindingZero implements StructUnwinding.StructMemberUnwinding {
      private StructZero structZero;
      private StructDefinition structDefinition;

      public StructMemberUnwindingZero(StructZero structZero, StructDefinition structDefinition) {
         this.structZero = structZero;
         this.structDefinition = structDefinition;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               return ZeroConstantValues.zeroValue(getType(), programScope);
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               return new MemsetValue(arraySize);
            }
         };
      }

   }

   /** Unwinding for ValueList. */
   private static class StructMemberUnwindingValueList implements StructUnwinding.StructMemberUnwinding {

      StructDefinition structDefinition;
      ValueList valueList;

      public StructMemberUnwindingValueList(ValueList valueList, StructDefinition structDefinition) {
         this.valueList = valueList;
         this.structDefinition = structDefinition;
      }

      @Override
      public List<String> getMemberNames() {
         Collection<Variable> structMemberVars = structDefinition.getAllVariables(false);
         ArrayList<String> memberNames = new ArrayList<>();
         for(Variable structMemberVar : structMemberVars) {
            memberNames.add(structMemberVar.getLocalName());
         }
         return memberNames;
      }

      @Override
      public StructUnwinding.RValueUnwinding getMemberUnwinding(String memberName) {
         return new StructUnwinding.RValueUnwinding() {
            @Override
            public SymbolType getType() {
               return structDefinition.getMember(memberName).getType();
            }

            @Override
            public ArraySpec getArraySpec() {
               return structDefinition.getMember(memberName).getArraySpec();
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               int memberIndex = getMemberNames().indexOf(memberName);
               return valueList.getList().get(memberIndex);
            }

            @Override
            public RValue getArrayUnwinding(ProgramScope scope, ConstantValue arraySize) {
               throw new RuntimeException("TODO: Implement!");
            }
         };
      }

   }
}
