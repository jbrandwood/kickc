package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.ConstantRef;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.PointerDereferenceIndexed;
import dk.camelot64.kickc.passes.PassNStructPointerRewriting;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

public class StructUnwindingMemberOfPointerDerefIndexed implements StructUnwinding {

   // The struct member reference a[i].b
   private final PointerDereferenceIndexed structRef;
   private final String memberRef;

   // The referenced struct (type of b)
   private final StructDefinition structDefinition;

   // For adding any needed statements
   private final ListIterator<Statement> stmtIt;
   private final ControlFlowBlock currentBlock;
   private final Statement currentStmt;

   public StructUnwindingMemberOfPointerDerefIndexed(PointerDereferenceIndexed structRef, String memberRef, StructDefinition structDefinition, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, Statement currentStmt) {
      this.structRef = structRef;
      this.memberRef = memberRef;
      this.structDefinition = structDefinition;
      this.stmtIt = stmtIt;
      this.currentBlock = currentBlock;
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
   public RValueUnwinding getMemberUnwinding(String memberName, ProgramScope programScope) {
      // a[i].b.c -> ((memberType*)a+OFFSET_B+OFFSET_C)[i]


      // Type of b
      SymbolType outerStructType = SymbolTypeInference.inferType(programScope, structRef);
      if(!(outerStructType instanceof SymbolTypeStruct))
         throw new CompileError("Error! Member is not a struct " + memberRef, currentStmt);
      StructDefinition outerStructDefinition = ((SymbolTypeStruct) outerStructType).getStructDefinition(programScope);
      ConstantRef outerMemberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, outerStructDefinition, memberRef);

      Variable member = this.structDefinition.getMember(memberName);
      SymbolType memberType = member.getType();

      Scope scope = programScope.getScope(currentBlock.getScope());
      Variable outerMemberAddress = scope.addVariableIntermediate();
      outerMemberAddress.setType(new SymbolTypePointer(memberType));
      CastValue structTypedPointer = new CastValue(new SymbolTypePointer(memberType), structRef.getPointer());
      // Add statement $1 = (elmType*)ptr_struct + OFFSET_B
      stmtIt.add(new StatementAssignment((LValue) outerMemberAddress.getRef(), structTypedPointer, Operators.PLUS, outerMemberOffsetConstant, true, currentStmt.getSource(), currentStmt.getComments()));
      // Unwind to ((elmType*)ptr_struct+OFFSET_B)[idx]
      PointerDereferenceIndexed outerMemberIndexing = new PointerDereferenceIndexed(outerMemberAddress.getRef(), structRef.getIndex());

      ConstantRef memberOffsetConstant = PassNStructPointerRewriting.getMemberOffsetConstant(programScope, this.structDefinition, memberName);
      ArraySpec memberArraySpec = member.getArraySpec();

      return new RValueUnwindingStructPointerDereferenceIndexedMember(outerMemberIndexing, memberType, memberArraySpec, memberOffsetConstant, currentBlock, stmtIt, currentStmt);
   }

}
