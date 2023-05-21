package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementCallPrepare;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

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
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
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
         Value value = programValue.get();
         if(value instanceof ConstantString && currentStmt!=null) {
            // String in statement expression
            Scope blockScope = Pass1ExtractInlineStrings.this.getProgram().getScope().getScope(currentBlock.getScope());
            Variable strConst = Pass1ExtractInlineStrings.this.createStringConstantVar(blockScope, (ConstantString) programValue.get(), nameHint);
            programValue.set(strConst.getRef());
         } else if(value instanceof ConstantString && programValue instanceof ProgramValue.ProgramValueConstantStructMember) {
            // Struct member initialization
            final ProgramValue.ProgramValueConstantStructMember constantStructMember = (ProgramValue.ProgramValueConstantStructMember) programValue;
            final SymbolVariableRef memberRef = constantStructMember.getMemberRef();
            final Variable memberDef = getProgramScope().getVar(memberRef);
            if(memberDef.getType() instanceof SymbolTypePointer) {
               if(((SymbolTypePointer) memberDef.getType()).getArraySpec()==null) {
                  // Member is not an array - create a string.
                  nameHint = memberDef.getFullName().replace("::","_").toLowerCase();
                  Variable strConst = Pass1ExtractInlineStrings.this.createStringConstantVar(getProgramScope(), (ConstantString) programValue.get(), nameHint);
                  programValue.set(strConst.getRef());
               }
            }
      } else if(value instanceof ConstantString && programValue instanceof ProgramValue.ProgramValueConstantArrayElement) {
            // Array element initialization
            final ProgramValue.ProgramValueConstantArrayElement constantArrayElement = (ProgramValue.ProgramValueConstantArrayElement) programValue;
            final SymbolType elementType = constantArrayElement.getArrayList().getElementType();
            if(elementType instanceof SymbolTypePointer) {
               if(((SymbolTypePointer) elementType).getArraySpec()==null) {
                  // Element is not an array - create a string.
                  Variable strConst = Pass1ExtractInlineStrings.this.createStringConstantVar(getProgramScope(), (ConstantString) programValue.get(), null);
                  programValue.set(strConst.getRef());
               }
            }
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
         while(blockScope.getLocalSymbol(name) != null) {
            name = nameHint + nameHintIdx++;
         }
      }
      final long stringLength = constantString.getStringLength();
      final ConstantInteger arraySize = new ConstantInteger(stringLength, stringLength<256?SymbolType.BYTE : SymbolType.WORD);
      Variable strConst = Variable.createConstant(name, new SymbolTypePointer(SymbolType.BYTE, new ArraySpec(arraySize), false, false), blockScope, constantString, blockScope.getSegmentData());
      blockScope.add(strConst);
      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("Creating constant string variable for inline " + strConst.toString(getProgram()) + " \"" + constantString.getValue() + "\"");
      }
      return strConst;
   }

}
