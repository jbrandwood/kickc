package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/** Utility methods for initializing variables */
public class Initializers {

   /**
    * Create a statement that initializes a variable with the default (zero) value. The statement has to be added to the program by the caller.
    *
    * @param type The type of the variable
    * @param statementSource The source line
    * @return The new statement
    */
   public static RValue createZeroValue(SymbolType type, StatementSource statementSource) {
      if(type instanceof SymbolTypeIntegerFixed) {
         // Add an zero value initializer
         return new ConstantInteger(0L, type);
      } else if(type instanceof SymbolTypePointer) {
         // Add an zero value initializer
         SymbolTypePointer typePointer = (SymbolTypePointer) type;
         return new ConstantPointer(0L, typePointer.getElementType());
      } else if(type instanceof SymbolTypeStruct) {
         // Add an zero-struct initializer
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) type;
         return new StructZero(typeStruct);
      } else {
         throw new CompileError("Default initializer not implemented for type " + type.getTypeName(), statementSource);
      }
   }

   /**
    * Get a value for initializing a variable from an expression.
    * If possible the value is converted to a ConstantValue.
    *
    * @param initValue The parsed init expression value (may be null)
    * @param type The type of the constant variable (used for creating zero values)
    * @param statementSource The statement (used in exceptions.
    * @return The constant init-value. Null if the value cannot be turned into a constant init-value.
    */
   public static RValue getInitValue(RValue initValue, SymbolType type, ArraySpec arraySpec, Program program, StatementSource statementSource) {
      // TODO: Handle struct members
      // Create zero-initializers if null
      if(initValue == null) {
         if(arraySpec!=null) {
            // Add an zero-filled array initializer
            SymbolTypePointer typePointer = (SymbolTypePointer) type;
            if(arraySpec.getArraySize() == null) {
               throw new CompileError("Error! Array has no declared size. ", statementSource);
            }
            initValue = new ConstantArrayFilled(typePointer.getElementType(), arraySpec.getArraySize());
         } else {
            // Add an zero-value
            initValue = createZeroValue(type, statementSource);
         }
      }
      // Convert initializer value lists to constant if possible
      if((initValue instanceof ValueList)) {
         ProgramValue programValue = new ProgramValue.GenericValue(initValue);
         addValueCasts(type, arraySpec!=null, programValue, program, statementSource);
         if(programValue.get() instanceof CastValue) {
            CastValue castValue = (CastValue) programValue.get();
            if(castValue.getValue() instanceof ValueList) {
               // Found value list with cast - look through all elements
               ConstantValue constantValue = convertToConstant(castValue.getToType(), (ValueList) castValue.getValue(), program, statementSource);
               if(constantValue != null) {
                  // Converted value list to constant!!
                  initValue = constantValue;
               }
            }
         }
      }
      // Add pointer cast to integers
      if(type instanceof SymbolTypePointer && initValue instanceof ConstantValue && SymbolType.isInteger(((ConstantValue) initValue).getType(program.getScope()))) {
         initValue = new ConstantCastValue(type, (ConstantValue) initValue);
      }
      return initValue;
   }

   /**
    * Add casts to a value based on the declared type of the symbol. Recurses to all sub-values.
    *
    * @param declaredType The declared type of the value
    * @param isArray true if the declared variable is an array
    * @param programValue The value wrapped in a program value
    * @param source The current statement
    * @return true if anything was modified
    */
   static boolean addValueCasts(SymbolType declaredType, boolean isArray, ProgramValue programValue, Program program, StatementSource source) {
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
         } else if(declaredType.equals(SymbolType.WORD) && valueList.getList().size()==2){
            // An inline word { byte, byte}
            for(int i = 0; i < valueList.getList().size(); i++) {
               exprModified |= addValueCasts(SymbolType.BYTE, false, new ProgramValue.ProgramValueListElement(valueList, i), program, source);
            }
            // Add a cast to the value list itself
            programValue.set(new CastValue(declaredType, valueList));
         } else if(declaredType.equals(SymbolType.DWORD) && valueList.getList().size()==2){
            // An inline dword { byte, byte}
            for(int i = 0; i < valueList.getList().size(); i++) {
               exprModified |= addValueCasts(SymbolType.WORD, false, new ProgramValue.ProgramValueListElement(valueList, i), program, source);
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
   static ConstantValue convertToConstant(SymbolType declaredType, ValueList valueList, Program program, StatementSource source) {
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
               ConstantValue constantValue = convertToConstant(castValue.getToType(), (ValueList) castValue.getValue(), program, source);
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
      } else if(declaredType.equals(SymbolType.WORD) && constantValues.size()==2){
         // An inline word
         for(ConstantValue constantValue : constantValues)
            if(!SymbolTypeConversion.assignmentTypeMatch(SymbolType.BYTE, constantValue.getType(program.getScope())))
               throw new CompileError("Initializer element " + constantValue.toString(program) + " does not match needed type "+SymbolType.BYTE, source);
         return new ConstantBinary(new ConstantBinary(constantValues.get(0), Operators.MULTIPLY, new ConstantInteger(0x100L, SymbolType.WORD)), Operators.PLUS, constantValues.get(1));
      } else if(declaredType.equals(SymbolType.DWORD) && constantValues.size()==2){
         // An inline dword
         for(ConstantValue constantValue : constantValues)
            if(!SymbolTypeConversion.assignmentTypeMatch(SymbolType.WORD, constantValue.getType(program.getScope())))
               throw new CompileError("Initializer element " + constantValue.toString(program) + " does not match needed type "+SymbolType.WORD, source);
         return new ConstantBinary(new ConstantBinary(constantValues.get(0), Operators.MULTIPLY, new ConstantInteger(0x10000L, SymbolType.DWORD)), Operators.PLUS, constantValues.get(1));
      } else {
         throw new InternalError("Not supported " + declaredType);
      }
   }

}
