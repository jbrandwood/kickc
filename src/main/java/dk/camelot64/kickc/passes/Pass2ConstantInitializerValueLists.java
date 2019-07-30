package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/**
 * Compiler Pass identifying typed (through a cast) initializer value lists with constant values and converting them into struct/array/number {@link ConstantValue}s
 */
public class Pass2ConstantInitializerValueLists extends Pass2SsaOptimization {

   public Pass2ConstantInitializerValueLists(Program program) {
      super(program);
   }

   /**
    * Look for value lists with casts that have all-constant values. Convert to the proper {@link ConstantValue}s
    *
    * @return true optimization was performed. false if no optimization was possible.
    */
   @Override
   public boolean step() {
      final boolean[] modified = {false};
      ProgramValueIterator.execute(getGraph(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof CastValue) {
            CastValue castValue = (CastValue) programValue.get();
            if(castValue.getValue() instanceof ValueList) {
               // Found value list with cast - look through all elements
               ConstantValue constantValue = getConstantValueFromList(castValue.getToType(), (ValueList) castValue.getValue(), currentStmt);
               if(constantValue!=null) {
                  programValue.set(constantValue);
                  getLog().append("Identified constant from value list ("+castValue.getToType()+") "+constantValue.toString(getProgram()));
                  modified[0] = true;
               }
            }
         }
      });
      return modified[0];
   }

   /**
    * Examine a value list to determine if all elements are constants.
    * If they are - convert the value list to a constant value of the declared type
    *
    * @param declaredType The type of the lvalue
    * @param valueList The list of values
    * @return The constant value if all list elements are constant. null if elements are not constant
    */
   private ConstantValue getConstantValueFromList(SymbolType declaredType, ValueList valueList, Statement currentStmt) {
      // Examine whether all list elements are constant
      List<RValue> values = valueList.getList();
      List<ConstantValue> constantValues = new ArrayList<>();
      for(RValue elmValue : values) {
         if(elmValue instanceof ConstantValue) {
            ConstantValue constantValue = (ConstantValue) elmValue;
            constantValues.add(constantValue);
         } else {
            // A non-constant was found - exit
            return null;
         }
      }
      // All elements are constant - convert to constant of declared type
      if(declaredType instanceof SymbolTypeArray) {
         // Check that type of constant values match the array element type
         SymbolType declaredElementType = ((SymbolTypeArray) declaredType).getElementType();
         for(ConstantValue constantValue : constantValues) {
            SymbolType elmType = constantValue.getType(getScope());
            if(!elmType.equals(declaredElementType)) {
               throw new CompileError("Initializer element "+constantValue.toString(getProgram())+" does not match array type "+declaredType.getTypeName(), currentStmt);
            }
         }
         // Return the constant array
         return new ConstantArrayList(constantValues, declaredElementType);
      } else if(declaredType instanceof SymbolTypeStruct) {
         // Check that type of constant values match the struct member types
         SymbolTypeStruct declaredStructType = (SymbolTypeStruct) declaredType;
         StructDefinition structDefinition = declaredStructType.getStructDefinition(getScope());
         Collection<Variable> memberDefs = structDefinition.getAllVariables(false);
         if(memberDefs.size()!=constantValues.size()) {
            throw new CompileError(
                  "Struct initializer has wrong size ("+valueList.getList().size()+"), " +
                        "which does not match the number of members in "+declaredStructType.getTypeName()+" (\"+size+\" members).\n" +
                        " Struct initializer: "+valueList.toString(getProgram()),
                  currentStmt);
         }
         Iterator<Variable> memberDefIt = memberDefs.iterator();
         LinkedHashMap<VariableRef, ConstantValue> memberValues = new LinkedHashMap<>();
         for(int i = 0; i < constantValues.size(); i++) {
            Variable memberDef = memberDefIt.next();
            SymbolType declaredElementType = memberDef.getType();
            ConstantValue memberValue = constantValues.get(i);
            SymbolType elmType = memberValue.getType(getScope());
            if(!elmType.equals(declaredElementType)) {
               throw new CompileError("Initializer element "+ memberValue.toString(getProgram())+" does not match struct member type "+memberDef.toString(getProgram()), currentStmt);
            }
            memberValues.put(memberDef.getRef(), memberValue);
         }
         return new ConstantStructValue(declaredStructType, memberValues);
      }  else {
         throw new InternalError("Not supported "+declaredType);
      }
   }

}
