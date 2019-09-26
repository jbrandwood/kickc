package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

import java.util.HashMap;
import java.util.Map;

/** Find memory variables and turn them into pointers */
public class Pass1PointifyMemoryVariables extends Pass1Base {

   public Pass1PointifyMemoryVariables(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      Map<VariableRef, ConstantRef> memoryVarPointers = new HashMap<>();
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.isDeclaredAsMemory()) {
            Scope scope = variable.getScope();
            String pointerName = variable.getLocalName() + "_ptr";
            if(scope.getSymbol(pointerName) == null) {
               ConstantVar constantPointer = new ConstantVar(pointerName, scope, new SymbolTypePointer(variable.getType()), new ConstantSymbolPointer(variable.getRef()), variable.getDataSegment());
               scope.add(constantPointer);
               memoryVarPointers.put(variable.getRef(), constantPointer.getRef());
               getLog().append("Adding memory variable constant pointer " + constantPointer.toString(getProgram()));
            }
         }
      }

      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(memoryVarPointers.containsKey(value)) {
            programValue.set(new PointerDereferenceSimple(memoryVarPointers.get(value)));
            getLog().append("Updating memory variable reference " + programValue.get().toString(getProgram()));
         }
      });
      return memoryVarPointers.size() > 0;
   }

}
