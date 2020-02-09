package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPrepare;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantString;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.Value;

import java.util.List;

/**
 * All inline strings in the code are extracted into constants.
 */
public class Pass1ExtractInlineStrings extends Pass1Base {

   public Pass1ExtractInlineStrings(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         String nameHint = null;
         if(currentStmt instanceof StatementCall) {
            StatementCall call = (StatementCall) currentStmt;
            List<RValue> parameters = call.getParameters();
            for(int i = 0; i < parameters.size(); i++) {
               RValue parameter = parameters.get(i);
               if(parameter.equals(programValue.get())) {
                  // The programValue value is the parameter - use the parameter name as name hint
                  Procedure procedure = Pass1ExtractInlineStrings.this.getProgram().getScope().getProcedure(call.getProcedure());
                  nameHint = procedure.getParameterNames().get(i);
                  break;
               }
            }
         } else if(currentStmt instanceof StatementCallPrepare) {
            StatementCallPrepare call = (StatementCallPrepare) currentStmt;
            List<RValue> parameters = call.getParameters();
            for(int i = 0; i < parameters.size(); i++) {
               RValue parameter = parameters.get(i);
               if(parameter.equals(programValue.get())) {
                  // The programValue value is the parameter - use the parameter name as name hint
                  Procedure procedure = Pass1ExtractInlineStrings.this.getProgram().getScope().getProcedure(call.getProcedure());
                  nameHint = procedure.getParameterNames().get(i);
                  break;
               }
            }
         }
         Scope blockScope = Pass1ExtractInlineStrings.this.getProgram().getScope().getScope(currentBlock.getScope());
         Value value = programValue.get();
         if(value instanceof ConstantString) {
            Variable strConst = Pass1ExtractInlineStrings.this.createStringConstantVar(blockScope, (ConstantString) programValue.get(), nameHint);
            programValue.set(strConst.getRef());
         }
      });
      return false;
   }

   private Variable createStringConstantVar(Scope blockScope, ConstantString constantString, String nameHint) {
      String name;
      if(nameHint == null) {
         name = blockScope.allocateIntermediateVariableName();
      } else {
         int nameHintIdx = 1;
         name = nameHint;
         while(blockScope.getSymbol(name) != null) {
            name = nameHint + nameHintIdx++;
         }
      }
      final long stringLength = constantString.getStringLength();
      final ConstantInteger arraySize = new ConstantInteger(stringLength, stringLength<256?SymbolType.BYTE : SymbolType.WORD);
      Variable strConst = Variable.createConstant(name, new SymbolTypePointer(SymbolType.BYTE), blockScope, new ArraySpec(arraySize), constantString, blockScope.getSegmentData());
      blockScope.add(strConst);
      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("Creating constant string variable for inline " + strConst.toString(getProgram()) + " \"" + constantString.getValue() + "\"");
      }
      return strConst;
   }

}
