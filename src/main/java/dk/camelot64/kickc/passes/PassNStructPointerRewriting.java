package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.util.Locale;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Rewrite access to member of dereferenced struct (*ptr_struct).x to reference the member directly *((*typeof_x)(ptr_struct+OFFSET_STRUCT_AAA_X))
 */
public class PassNStructPointerRewriting extends Pass2SsaOptimization {

   public PassNStructPointerRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof StructMemberRef) {
            StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
            RValue struct = structMemberRef.getStruct();
            if(struct instanceof PointerDereferenceSimple) {
               RValue structPointer = ((PointerDereferenceSimple) struct).getPointer();
               // We have a match for (*ptr_struct).x
               SymbolType structType = SymbolTypeInference.inferType(getScope(), struct);
               if(!(structType instanceof SymbolTypeStruct)) {
                  throw new CompileError("Accessing member of a non-struct ", currentStmt.getSource());
               }
               StructDefinition structDefinition = ((SymbolTypeStruct) structType).getStructDefinition(getScope());
               ConstantRef memberOffsetConstant = getMemberOffsetConstant(getScope(), structDefinition, structMemberRef.getMemberName());
               SymbolType memberType = SymbolTypeInference.inferType(getScope(), structMemberRef);
               Variable memberVar = structDefinition.getMember(structMemberRef.getMemberName());
               getLog().append("Rewriting struct pointer member access " + programValue.get().toString(getProgram()));
               if(memberVar.isArray() && memberVar.getArraySpec().getArraySize()!=null) {
                  // Cast struct pointer to the type of the member
                  CastValue structTypedPointer = new CastValue(memberType, structPointer);
                  // Create temporary variable to hold pointer to member ($1)
                  Scope scope = getScope().getScope(currentBlock.getScope());
                  Variable memberAddress1 = scope.addVariableIntermediate();
                  memberAddress1.setType(memberType);
                  // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
                  stmtIt.previous();
                  stmtIt.add(new StatementAssignment((LValue) memberAddress1.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
                  stmtIt.next();
                  // Replace (*ptr_struct).x with *($1)
                  programValue.set(memberAddress1.getRef());
               }  else {
                  // Cast struct pointer to the type of the member
                  CastValue structTypedPointer = new CastValue(new SymbolTypePointer(memberType), structPointer);
                  // Create temporary variable to hold pointer to member ($1)
                  Scope scope = getScope().getScope(currentBlock.getScope());
                  Variable memberAddress = scope.addVariableIntermediate();
                  memberAddress.setType(new SymbolTypePointer(memberType));
                  // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
                  stmtIt.previous();
                  stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
                  stmtIt.next();
                  // Replace (*ptr_struct).x with *($1)
                  programValue.set(new PointerDereferenceSimple(memberAddress.getRef()));
               }
               modified.set(true);
            } else if(struct instanceof PointerDereferenceIndexed) {
               RValue structPointer = ((PointerDereferenceIndexed) struct).getPointer();
               // We have a match for ptr_struct[idx].x
               SymbolType structType = SymbolTypeInference.inferType(getScope(), struct);
               if(!(structType instanceof SymbolTypeStruct)) {
                  throw new CompileError("Accessing member of a non-struct ", currentStmt.getSource());
               }
               StructDefinition structDefinition = ((SymbolTypeStruct) structType).getStructDefinition(getScope());
               ConstantRef memberOffsetConstant = getMemberOffsetConstant(getScope(), structDefinition, structMemberRef.getMemberName());
               SymbolType memberType = SymbolTypeInference.inferType(getScope(), structMemberRef);
               Variable memberVar = structDefinition.getMember(structMemberRef.getMemberName());
               getLog().append("Rewriting struct pointer member access " + programValue.get().toString(getProgram()));
               if(memberVar.isArray() && memberVar.getArraySpec().getArraySize()!=null) {
                  // Cast struct pointer to the type of the member
                  CastValue structTypedPointer = new CastValue(memberType, structPointer);
                  // Create temporary variable to hold pointer to member ($1)
                  Scope scope = getScope().getScope(currentBlock.getScope());
                  Variable memberAddress1 = scope.addVariableIntermediate();
                  memberAddress1.setType(memberType);
                  Variable memberAddress2 = scope.addVariableIntermediate();
                  memberAddress2.setType(memberType);
                  // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
                  stmtIt.previous();
                  stmtIt.add(new StatementAssignment((LValue) memberAddress1.getRef(), structTypedPointer, Operators.PLUS, ((PointerDereferenceIndexed) struct).getIndex(), currentStmt.getSource(), currentStmt.getComments()));
                  stmtIt.add(new StatementAssignment((LValue) memberAddress2.getRef(), memberAddress1.getRef(), Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
                  stmtIt.next();
                  // Replace ptr_struct[idx].x with ($1)[idx]
                  programValue.set(memberAddress2.getRef());
                  //throw new InternalError("Fixed size arrays not supported inside structs used through pointers/arrays", currentStmt);
               } else {
                  // Cast struct pointer to the type of the member
                  CastValue structTypedPointer = new CastValue(new SymbolTypePointer(memberType), structPointer);
                  // Create temporary variable to hold pointer to member ($1)
                  Scope scope = getScope().getScope(currentBlock.getScope());
                  Variable memberAddress = scope.addVariableIntermediate();
                  memberAddress.setType(new SymbolTypePointer(memberType));
                  // Add statement $1 = ptr_struct + OFFSET_STRUCT_NAME_MEMBER
                  stmtIt.previous();
                  stmtIt.add(new StatementAssignment((LValue) memberAddress.getRef(), structTypedPointer, Operators.PLUS, memberOffsetConstant, currentStmt.getSource(), currentStmt.getComments()));
                  stmtIt.next();
                  // Replace ptr_struct[idx].x with ($1)[idx]
                  programValue.set(new PointerDereferenceIndexed(memberAddress.getRef(), ((PointerDereferenceIndexed) struct).getIndex()));
               }
               modified.set(true);
            }
         }
      });
      return modified.get();
   }

   /**
    * Get the constant variable containing the (byte) index of a specific member
    *
    * @param programScope The program scope (used for finding/adding the constant).
    * @param structDefinition The struct
    * @param memberName The name of the struct member
    * @return The constant variable
    */
   public static ConstantRef getMemberOffsetConstant(ProgramScope programScope, StructDefinition structDefinition, String memberName) {
      String typeConstName = getMemberOffsetConstantName(structDefinition, memberName);
      Variable memberOffsetConstant = programScope.getConstant(typeConstName);
      if(memberOffsetConstant == null) {
         // Constant not found - create it
         Variable memberDef = structDefinition.getMember(memberName);
         long memberByteOffset = structDefinition.getMemberByteOffset(memberDef, programScope);
         memberOffsetConstant = Variable.createConstant(typeConstName, SymbolType.BYTE, programScope, null, new ConstantInteger(memberByteOffset & 0xff, SymbolType.BYTE), Scope.SEGMENT_DATA_DEFAULT);
         programScope.add(memberOffsetConstant);
      }
      return memberOffsetConstant.getConstantRef();
   }

   /**
    * Get the name of the constant variable containing the (byte) index of a specific member in a struct
    *
    * @param structDefinition The struct
    * @param memberName The name of the struct member
    * @return The name of the constant
    */
   private static String getMemberOffsetConstantName(StructDefinition structDefinition, String memberName) {
      return "OFFSET_" + structDefinition.getType().getTypeName().toUpperCase(Locale.ENGLISH).replace(" ", "_") + "_" + memberName.toUpperCase();
   }


}
