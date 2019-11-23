package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** Utility methods for finding constant struct/array values from {@link dk.camelot64.kickc.model.values.ValueList}. */
public class ConstantValueLists {

   /**
    * Add cast to a value inside a value list initializer based on the declared type of the symbol.
    *
    * @param declaredType The declared type of the value
    * @param isArray true if the declared variable is an array
    * @param programValue The value wrapped in a program value
    * @param source The current statement
    * @return true if anything was modified
    */
   public static boolean addValueCasts(SymbolType declaredType, boolean isArray, ProgramValue programValue, Program program, StatementSource source) {
      boolean exprModified = false;
      Value value = programValue.get();
      if(value instanceof ValueList) {
         ValueList valueList = (ValueList) value;
         if(declaredType instanceof SymbolTypePointer && isArray) {
            SymbolTypePointer declaredArrayType = (SymbolTypePointer) declaredType;
            // Recursively cast all sub-elements
            SymbolType declaredElmType = declaredArrayType.getElementType();
            int size = valueList.getList().size();
            // TODO: Check declared array size vs. actual size
            for(int i = 0; i < size; i++) {
               exprModified |= addValueCasts(declaredElmType, false, new ProgramValue.ProgramValueListElement(valueList, i), program, source);
            }
            // Add a cast to the value list itself
            programValue.set(new CastValue(declaredType, valueList));
         } else if(declaredType instanceof SymbolTypeStruct) {
            SymbolTypeStruct declaredStructType = (SymbolTypeStruct) declaredType;
            // Recursively cast all sub-elements
            StructDefinition structDefinition = declaredStructType.getStructDefinition(program.getScope());
            Collection<Variable> memberDefinitions = structDefinition.getAllVars(false);
            int size = memberDefinitions.size();
            if(size != valueList.getList().size()) {
               throw new CompileError(
                     "Struct initializer has wrong size (" + valueList.getList().size() + "), " +
                           "which does not match the number of members in " + declaredStructType.getTypeName() + " (" + size + " members).\n" +
                           " Struct initializer: " + valueList.toString(program),
                     source);
            }
            Iterator<Variable> memberDefIt = memberDefinitions.iterator();
            for(int i = 0; i < size; i++) {
               Variable memberDef = memberDefIt.next();
               exprModified |= addValueCasts(memberDef.getType(), memberDef.isArray(), new ProgramValue.ProgramValueListElement(valueList, i), program, source);
            }
            // Add a cast to the value list itself
            programValue.set(new CastValue(declaredType, valueList));
         } else {
            // TODO: Handle word/dword initializers
            throw new InternalError("Type not handled! " + declaredType);
         }
      } else {
         SymbolType valueType = SymbolTypeInference.inferType(program.getScope(), (RValue) value);
         if(SymbolType.NUMBER.equals(valueType) || SymbolType.VAR.equals(valueType)) {
            // Check if the value fits.
            if(!SymbolTypeConversion.assignmentTypeMatch(declaredType, valueType)) {
               throw new CompileError("Declared type " + declaredType + " does not match element type " + valueType, source);
            }
            // TODO: Test if the value matches the declared type!
            // Add a cast to the value
            if(value instanceof ConstantValue) {
               programValue.set(new ConstantCastValue(declaredType, (ConstantValue) value));
            } else {
               programValue.set(new CastValue(declaredType, (RValue) value));
            }
            exprModified = true;
         }
      }
      return exprModified;
   }

   /**
    * Convert a value list (with casts) to a constant value of the declared type - if all sub-values are constant. Otherwise returns null.
    *
    * @param declaredType The type of the lvalue
    * @param valueList The list of values
    * @return The constant value if all list elements are constant. null if elements are not constant
    */
   public static ConstantValue getConstantValue(SymbolType declaredType, ValueList valueList, Program program, StatementSource source) {
      // Examine whether all list elements are constant
      List<RValue> values = valueList.getList();
      List<ConstantValue> constantValues = new ArrayList<>();
      for(RValue elmValue : values) {
         if(elmValue instanceof ConstantValue) {
            ConstantValue constantValue = (ConstantValue) elmValue;
            constantValues.add(constantValue);
         } else if(elmValue instanceof CastValue) {
            // Recursion may be needed
            CastValue castValue = (CastValue) elmValue;
            if(castValue.getValue() instanceof ValueList) {
               ConstantValue constantValue = getConstantValue(castValue.getToType(), (ValueList) castValue.getValue(), program, source);
               if(constantValue != null) {
                  constantValues.add(constantValue);
               } else {
                  // A non-constant was found - exit
                  return null;
               }
            } else {
               // A non-constant was found - exit
               return null;
            }
         } else {
            // A non-constant was found - exit
            return null;
         }
      }
      // All elements are constant - convert to constant of declared type
      if(declaredType instanceof SymbolTypePointer) {
         // Check that type of constant values match the array element type
         SymbolType declaredElementType = ((SymbolTypePointer) declaredType).getElementType();
         for(ConstantValue constantValue : constantValues) {
            SymbolType elmType = constantValue.getType(program.getScope());
            if(!elmType.equals(declaredElementType)) {
               throw new CompileError("Initializer element " + constantValue.toString(program) + " does not match array type " + declaredType.getTypeName(), source);
            }
         }
         // Return the constant array
         return new ConstantArrayList(constantValues, declaredElementType);
      } else if(declaredType instanceof SymbolTypeStruct) {
         // Check that type of constant values match the struct member types
         SymbolTypeStruct declaredStructType = (SymbolTypeStruct) declaredType;
         StructDefinition structDefinition = declaredStructType.getStructDefinition(program.getScope());
         Collection<Variable> memberDefs = structDefinition.getAllVars(false);
         if(memberDefs.size() != constantValues.size()) {
            throw new CompileError(
                  "Struct initializer has wrong size (" + valueList.getList().size() + "), " +
                        "which does not match the number of members in " + declaredStructType.getTypeName() + " (\"+size+\" members).\n" +
                        " Struct initializer: " + valueList.toString(program),
                  source);
         }
         Iterator<Variable> memberDefIt = memberDefs.iterator();
         LinkedHashMap<SymbolVariableRef, ConstantValue> memberValues = new LinkedHashMap<>();
         for(int i = 0; i < constantValues.size(); i++) {
            Variable memberDef = memberDefIt.next();
            SymbolType declaredElementType = memberDef.getType();
            ConstantValue memberValue = constantValues.get(i);
            SymbolType elmType = memberValue.getType(program.getScope());
            if(!SymbolTypeConversion.assignmentTypeMatch(declaredElementType, elmType)) {
               throw new CompileError("Initializer element " + memberValue.toString(program) + " does not match struct member type " + memberDef.toString(program), source);
            }
            memberValues.put(memberDef.getRef(), memberValue);
         }
         return new ConstantStructValue(declaredStructType, memberValues);
      } else {
         throw new InternalError("Not supported " + declaredType);
      }
   }
}
