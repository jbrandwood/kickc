package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

/** Unwinding for a struct value with C-classic memory layout. */
public class StructVariableMemberUnwinding implements StructMemberUnwinding {
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
   public RValueUnwinding getMemberUnwinding(String memberName) {
      final SymbolType symbolType = structDefinition.getMember(memberName).getType();
      final ArraySpec arraySpec = structDefinition.getMember(memberName).getArraySpec();

      if(arraySpec==null) {
         // Simple member value - unwind to value of member *((type*)&struct + OFFSET_MEMBER)
         return new RValueUnwinding() {
            @Override
            public SymbolType getSymbolType() {
               return symbolType;
            }

            @Override
            public ArraySpec getArraySpec() {
               return arraySpec;
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
               ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
               // Pointer to member type
               ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(getSymbolType()), structPointer);
               // Calculate member address  (type*)&struct + OFFSET_MEMBER
               ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
               // Unwind to *((type*)&struct + OFFSET_MEMBER)
               return new PointerDereferenceSimple(memberArrayPointer);
            }

            @Override
            public boolean isBulkCopyable() {
               return false;
            }

            @Override
            public LValue getBulkLValue(ProgramScope scope) {
               return null;
            }

            @Override
            public RValue getBulkRValue(ProgramScope scope) {
               return null;
            }
         };
      }  else {
         // Array struct member - unwind to pointer to first element (elmtype*)&struct + OFFSET_MEMBER
         return new RValueUnwinding() {
            @Override
            public SymbolType getSymbolType() {
               return symbolType;
            }

            @Override
            public ArraySpec getArraySpec() {
               return arraySpec;
            }

            @Override
            public RValue getUnwinding(ProgramScope programScope) {
               ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, structDefinition, memberName);
               ConstantSymbolPointer structPointer = new ConstantSymbolPointer(variable.getRef());
               // Pointer to member element type (elmtype*)&struct
               SymbolTypePointer memberType = (SymbolTypePointer) getSymbolType();
               ConstantCastValue structTypedPointer = new ConstantCastValue(new SymbolTypePointer(memberType.getElementType()), structPointer);
               // Calculate member address  (elmtype*)&struct + OFFSET_MEMBER
               ConstantBinary memberArrayPointer = new ConstantBinary(structTypedPointer, Operators.PLUS, memberOffsetConstant);
               // Unwind to (elmtype*)&struct + OFFSET_MEMBER
               return memberArrayPointer;
            }

            @Override
            public boolean isBulkCopyable() {
               return true;
            }

            @Override
            public LValue getBulkLValue(ProgramScope scope) {
               RValue memberArrayPointer = getUnwinding(scope);
               return new PointerDereferenceSimple(memberArrayPointer);

            }

            @Override
            public RValue getBulkRValue(ProgramScope scope) {
               RValue memberArrayPointer = getUnwinding(scope);
               return new MemcpyValue(new PointerDereferenceSimple(memberArrayPointer), getArraySpec().getArraySize());
            }
         };

      }


   }

}
