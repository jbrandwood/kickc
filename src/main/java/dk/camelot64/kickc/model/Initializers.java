package dk.camelot64.kickc.model;

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
    * @param typeSpec The type of the variable
    * @param statementSource The source line
    * @return The new statement
    */
   public static ConstantValue createZeroValue(ValueTypeSpec typeSpec, StatementSource statementSource) {
      if(typeSpec.getType() instanceof SymbolTypeIntegerFixed) {
         // Add an zero value initializer
         return new ConstantInteger(0L, typeSpec.getType());
      } else if(typeSpec.getType().equals(SymbolType.BOOLEAN)) {
         return new ConstantBool(false);
      } else if(typeSpec.getType() instanceof SymbolTypeStruct) {
         // Add an zero-struct initializer
         SymbolTypeStruct typeStruct = (SymbolTypeStruct) typeSpec.getType();
         return new StructZero(typeStruct);
      } else if(typeSpec.getType() instanceof SymbolTypePointer) {
         SymbolTypePointer typePointer = (SymbolTypePointer) typeSpec.getType();
         if(typePointer.getArraySpec() == null) {
            // Add an zero value initializer
            return new ConstantPointer(0L, typePointer.getElementType());
         } else {
            // Add an zero-filled array initializer
            if(typePointer.getArraySpec().getArraySize() == null) {
               throw new CompileError("Array has no declared size.", statementSource);
            }
            return new ConstantArrayFilled(typePointer.getElementType(), typePointer.getArraySpec().getArraySize());
         }
      } else {
         throw new CompileError("Default initializer not implemented for type " + typeSpec.getType().getTypeName(), statementSource);
      }
   }

   /** Specifies type properties for a value. Holds normal type and array specification. */
   public static class ValueTypeSpec {

      SymbolType type;

      public ValueTypeSpec(SymbolType type) {
         this.type = type;
      }

      public SymbolType getType() {
         return type;
      }

   }


   /**
    * Convert as much as possible of the passed value to a constant. Will convert the entire value if possible. If not all sub-values are converted as possible.
    *
    * @param initValue The value to convert
    * @param typeSpec The specified type of the value (including any array properties)
    * @param program The program
    * @param source The statement source (for error messages)
    * @return The constantified value. A {@link ConstantValue} is possible
    */
   public static RValue constantify(RValue initValue, ValueTypeSpec typeSpec, Program program, StatementSource source) {
      // Remove any const/volatile qualifiers
      typeSpec = new ValueTypeSpec(typeSpec.getType().getQualified(false, false));

      if(initValue == null) {
         // Add an zero-value
         initValue = createZeroValue(typeSpec, source);
      } else if(initValue instanceof ForwardVariableRef) {
         // Do not constantify
      } else if(initValue instanceof CastValue) {
         final CastValue castValue = (CastValue) initValue;
         if(castValue.getValue() instanceof ValueList && castValue.getToType() instanceof SymbolTypeStruct) {
            final SymbolType toType = castValue.getToType();
            final RValue constantSub = constantify(castValue.getValue(), new ValueTypeSpec(toType), program, source);
            if(constantSub instanceof ConstantValue) {
               return new ConstantCastValue(toType, (ConstantValue) constantSub);
            }
         }
      } else if(initValue instanceof ValueList) {
         ValueList initList = (ValueList) initValue;
         if(typeSpec.getType() instanceof SymbolTypePointer && ((SymbolTypePointer)typeSpec.getType()).getArraySpec() != null) {
            // Type is an array
            initValue = constantifyArray(initList, (SymbolTypePointer) typeSpec.getType(), program, source);
         } else if(typeSpec.getType() instanceof SymbolTypeStruct) {
            // Type is a struct
            initValue = constantifyStruct(initList, (SymbolTypeStruct) typeSpec.getType(), program, source);
         } else {
            throw new CompileError("Value list cannot initialize type " + typeSpec.getType(), source);
         }
      } else if(SymbolType.isInteger(typeSpec.getType())) {
         if(initValue instanceof ConstantInteger) {
            Long integer = ((ConstantInteger) initValue).getInteger();
            if(typeSpec.getType() instanceof SymbolTypeIntegerFixed) {
               SymbolTypeIntegerFixed typeIntegerFixed = (SymbolTypeIntegerFixed) typeSpec.getType();
               if(!typeIntegerFixed.contains(integer)) {
                  throw new CompileError( "Constant init-value has a non-matching type \n type: " + typeSpec.getType().toString() +"\n value: " + initValue.toString(), source);
               }
            }
            initValue = new ConstantInteger(integer, typeSpec.getType());
         } else if(initValue instanceof ConstantValue) {
            SymbolType initValueType = ((ConstantValue) initValue).getType(program.getScope());
            if(!initValueType.equals(typeSpec.getType()))
               initValue = new ConstantCastValue(typeSpec.getType(), (ConstantValue) initValue);
         } else {
            SymbolType inferredType = SymbolTypeInference.inferType(program.getScope(), initValue);
            if(!inferredType.equals(typeSpec.getType()) && !inferredType.equals(SymbolType.VAR)) {
               if(SymbolTypeConversion.assignmentTypeMatch(typeSpec.getType(), inferredType))
                  initValue = new CastValue(typeSpec.getType(), initValue);
               else
                  throw new CompileError("Type mismatch (" + typeSpec.getType().getTypeName() + ") cannot be assigned from (" + inferredType.getTypeName() + ").", source);
            }
         }
      }
      return initValue;
   }

   /**
    * Convert as much as possible of a struct to constants.
    *
    * @param valueList The value list
    * @param structType The struct type
    * @param program The program
    * @param source The source line
    * @return The constantified value
    */
   private static RValue constantifyStruct(ValueList valueList, SymbolTypeStruct structType, Program program, StatementSource source) {
      // Recursively cast all sub-elements
      StructDefinition structDefinition = structType.getStructDefinition(program.getScope());
      Collection<Variable> memberDefinitions = structDefinition.getAllVars(false);
      int size = memberDefinitions.size();
      if(size != valueList.getList().size()) {
         throw new CompileError(
               "Struct initializer has wrong size (" + valueList.getList().size() + "), " +
                     "which does not match the number of members in " + structType.getTypeName() + " (" + size + " members).\n" +
                     " Struct initializer: " + valueList.toString(program),
               source);
      }

      boolean allConst = true;
      // Constantified values in a list
      List<RValue> constantifiedList = new ArrayList<>();
      // Map filled if all member values become constant
      LinkedHashMap<SymbolVariableRef, ConstantValue> constMemberMap = new LinkedHashMap<>();
      Iterator<Variable> memberDefIt = memberDefinitions.iterator();
      Iterator<RValue> valueIt = valueList.getList().iterator();
      for(int i = 0; i < size; i++) {
         Variable memberDef = memberDefIt.next();
         RValue memberValue = valueIt.next();
         RValue constantifiedMemberValue = constantify(memberValue, new ValueTypeSpec(memberDef.getType()), program, source);
         constantifiedList.add(constantifiedMemberValue);
         if(constantifiedMemberValue instanceof ConstantValue)
            constMemberMap.put(memberDef.getRef(), (ConstantValue) constantifiedMemberValue);
         else
            allConst = false;
      }
      if(allConst) {
         // Constant struct
         return new ConstantStructValue(structType, constMemberMap);
      } else {
         // Constantified list with a cast
         return new CastValue(structType, new ValueList(constantifiedList));
      }
   }

   /**
    * Convert as much of an array to constant as possible. Also zero-pads the value-list to the declared array length (if possible).
    *
    * @param valueList The list of values
    * @param arrayType The pointer type of the array
    * @param program The program
    * @param source The source line
    * @return The constantified value
    */
   private static RValue constantifyArray(ValueList valueList, SymbolTypePointer arrayType, Program program, StatementSource source) {
      ArraySpec arraySpec = arrayType.getArraySpec();
      SymbolType elementType = arrayType.getElementType();
      // TODO: Handle array of array
      ValueTypeSpec elementTypeSpec = new ValueTypeSpec(elementType);
      boolean allConst = true;
      List<RValue> constantifiedList = new ArrayList<>();
      for(RValue elementValue : valueList.getList()) {
         RValue constantifiedElement = constantify(elementValue, elementTypeSpec, program, source);
         constantifiedList.add(constantifiedElement);
         if(!(constantifiedElement instanceof ConstantValue))
            allConst = false;
      }
      if(allConst) {
         // Convert to ConstantArrayList (throwing away the array size)
         ArrayList<ConstantValue> constElementList = new ArrayList<>();
         for(RValue rValue : constantifiedList) {
            constElementList.add((ConstantValue) rValue);
         }
         return new ConstantArrayList(constElementList, elementType, arraySpec.getArraySize());
      } else {
         // Convert to a ValueList with a cast to the pointer-type (throwing away the array size)
         return new CastValue(arrayType, new ValueList(constantifiedList));
      }
   }

}
