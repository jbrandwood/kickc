package dk.camelot64.kickc.passes.unwinding;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.ListIterator;

public class ValueSourceFactory {

   /**
    * Get a value source for copying a value
    *
    * @param value The value being copied
    * @param currentStmt The current statement
    * @param stmtIt The statement iterator
    * @param currentBlock The current block
    * @return The value source for copying. null if no value source can be created.
    */
   public static ValueSource getValueSource(Value value, Program program, ProgramScope programScope, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock) {
      if(value == null)
         return null;
      final SymbolType valueType = SymbolTypeInference.inferType(programScope, (RValue) value);
      if(valueType instanceof SymbolTypeStruct && value instanceof CastValue && ((CastValue) value).getValue() instanceof ValueList) {
         ValueList valueList = (ValueList) ((CastValue) value).getValue();
         final StructDefinition structDefinition = ((SymbolTypeStruct) valueType).getStructDefinition(programScope);
         int expectSize;
         if(structDefinition.isUnion()) {
            expectSize = 1;
         }  else {
            expectSize = structDefinition.getAllVars(false).size();
         }
         if(expectSize != valueList.getList().size()) {
            throw new CompileError("Struct/Union initialization list has wrong size. Need  " + expectSize + " got " + valueList.getList().size(), currentStmt);
         }
         return new ValueSourceStructValueList(valueList, structDefinition);
      }
      if(value instanceof CastValue && ((CastValue) value).getToType() instanceof SymbolTypeInteger) {
         final CastValue castValue = (CastValue) value;
         final RValue subValue = castValue.getValue();
         final ValueSource subValueSource = getValueSource(subValue, program, programScope, currentStmt, stmtIt, currentBlock);
         return new ValueSourceCastValue(castValue.getToType(), subValueSource);
      }
      if(value instanceof VariableRef) {
         Variable variable = programScope.getVariable((VariableRef) value);
         return new ValueSourceVariable(variable);
      }
      if(value instanceof StructZero) {
         //final ConstantValue zeroValue = Initializers.createZeroValue(new Initializers.ValueTypeSpec(valueType, null), currentStmt.getSource());
         //return new ValueSourceConstant(valueType, null, zeroValue);
         return new ValueSourceZero(((StructZero) value).getTypeStruct(), null);
      }
      if(value instanceof ConstantValue)
         return new ValueSourceConstant(((ConstantValue) value).getType(programScope), (ConstantValue) value);
      if(value instanceof PointerDereferenceSimple)
         return new ValueSourcePointerDereferenceSimple((PointerDereferenceSimple) value, valueType, null);
      if(value instanceof PointerDereferenceIndexed)
         return new ValueSourcePointerDereferenceIndexed((PointerDereferenceIndexed) value, valueType, null);
      if(value instanceof StructMemberRef) {
         final RValue structValue = ((StructMemberRef) value).getStruct();
         final ValueSource structValueSource = getValueSource(structValue, program, programScope, currentStmt, stmtIt, currentBlock);
         return structValueSource.getMemberUnwinding(((StructMemberRef) value).getMemberName(), program, programScope, currentStmt, stmtIt, currentBlock);
      }
      if(valueType instanceof SymbolTypeStruct && value instanceof ParamValue) {
         final ValueSource subValueSource = getValueSource(((ParamValue) value).getParameter(), program, programScope, currentStmt, stmtIt, currentBlock);
         return new ValueSourceParamValue(subValueSource);
      }
      return null;
   }

}
