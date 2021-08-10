package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.StructMemberRef;

/**
 * Asserts that all struct references point to members that exist
 */
public class PassNAssertStructMembers extends Pass2SsaOptimization {

   public PassNAssertStructMembers(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof StructMemberRef) {
            StructMemberRef structMemberRef = (StructMemberRef) programValue.get();
            SymbolType type = SymbolTypeInference.inferType(getScope(), structMemberRef.getStruct());
            if(type instanceof SymbolTypeStruct) {
               SymbolTypeStruct structType = (SymbolTypeStruct) type;
               StructDefinition structDefinition = structType.getStructDefinition(getScope());
               Variable member = structDefinition.getMember(structMemberRef.getMemberName());
               if(member==null) {
                  throw new CompileError("Unknown struct member "+structMemberRef.getMemberName()+" in struct "+ structType.toCDecl(), currentStmt);
               }
            } else {
               if(type instanceof SymbolTypePointer)
                  throw new CompileError("member '"+structMemberRef.getMemberName()+"' reference type '"+type.toCDecl()+"' is a pointer; did you mean to use '->'?", currentStmt);
               else
                  throw new CompileError("member '"+structMemberRef.getMemberName()+"' reference operator '.'/'->' applied to a non-struct", currentStmt);
            }
         }
      });
      return false;
   }


}
