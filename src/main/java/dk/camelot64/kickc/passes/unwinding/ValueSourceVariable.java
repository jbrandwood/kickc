package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StructVariableMemberUnwinding;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ListIterator;

/** Value Source for a variable */
public class ValueSourceVariable extends ValueSourceBase {

   /** The variable. */
   private final Variable variable;

   public ValueSourceVariable(Variable variable) {
      this.variable = variable;
   }

   @Override
   public SymbolType getSymbolType() {
      return variable.getType();
   }

   @Override
   public ArraySpec getArraySpec() {
      return variable.getArraySpec();
   }

   @Override
   protected boolean isStructClassic() {
      return variable.isStructClassic();
   }

   @Override
   public RValue getSimpleValue(ProgramScope programScope) {
      // Historically this returned a pointer - why?
      //return new ConstantSymbolPointer(variable.getRef());
      return variable.getRef();
   }

   @Override
   public LValue getBulkLValue(ProgramScope scope) {
      if(getArraySpec() != null) {
         return new PointerDereferenceSimple(variable.getRef());
      } else {
         ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
         return new PointerDereferenceSimple(pointer);
      }
   }

   @Override
   public RValue getBulkRValue(ProgramScope scope) {
      ConstantSymbolPointer pointer = new ConstantSymbolPointer(variable.getRef());
      LValue pointerDeref = new PointerDereferenceSimple(pointer);
      return new MemcpyValue(pointerDeref, getByteSize(scope), getSymbolType());
   }

   @Override
   public ValueSource getMemberUnwinding(String memberName, Program program, ProgramScope programScope, Statement currentStmt, ControlFlowBlock currentBlock, ListIterator<Statement> stmtIt) {
      if(variable.isStructClassic()) {
         StructDefinition structDefinition = ((SymbolTypeStruct) getSymbolType()).getStructDefinition(programScope);
         SymbolType memberType = structDefinition.getMember(memberName).getType();
         ArraySpec memberArraySpec = structDefinition.getMember(memberName).getArraySpec();
         ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
         ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
         if(memberArraySpec != null) {
            // Pointer to member element type (elmtype*)&struct
            SymbolType elementType = ((SymbolTypePointer) memberType).getElementType();
            SymbolTypePointer pointerToElementType = new SymbolTypePointer(elementType);
            ConstantCastValue structTypedPointer = new ConstantCastValue(pointerToElementType, structPointer);
            // Calculate member address  (elmtype*)&struct + OFFSET_MEMBER
            ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
            // Unwind to (elmtype*)&struct + OFFSET_MEMBER
            return new ValueSourceConstant(pointerToElementType, null, memberArrayPointer);
         } else {
            // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
            // Pointer to member type
            ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(memberType), structPointer);
            // Calculate member address  (type*)&struct + OFFSET_MEMBER
            ConstantBinary memberPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
            // Unwind to *((type*)&struct + OFFSET_MEMBER)
            PointerDereferenceSimple memberDeref = new PointerDereferenceSimple(memberPointer);
            return new ValueSourcePointerDereferenceSimple(memberDeref, memberType, memberArraySpec);
         }
      } else if(variable.isStructUnwind()) {
         StructVariableMemberUnwinding structVariableMemberUnwinding = program.getStructVariableMemberUnwinding();
         final StructVariableMemberUnwinding.VariableUnwinding variableUnwinding = structVariableMemberUnwinding.getVariableUnwinding(variable.getRef());
         final SymbolVariableRef memberUnwound = variableUnwinding.getMemberUnwound(memberName);
         final Variable memberVariable = programScope.getVar(memberUnwound);
         return new ValueSourceVariable(memberVariable);
      } else {
         throw new InternalError("Not implemented!");
      }
   }

}