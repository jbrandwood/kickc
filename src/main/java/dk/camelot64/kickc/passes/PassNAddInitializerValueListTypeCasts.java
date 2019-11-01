package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;
import java.util.Iterator;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add casts to all expressions that are inside value list initializers <code><{ ... }/code> based on the type of the array/struct
 */
public class PassNAddInitializerValueListTypeCasts extends Pass2SsaOptimization {

   public PassNAddInitializerValueListTypeCasts(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (binaryExpression, currentStmt, stmtIt, currentBlock) -> {
         if(binaryExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) binaryExpression;
            if(binary.getRight() instanceof ValueList && binary.getOperator().equals(Operators.ASSIGNMENT)) {
               RValue left = binary.getLeft();
               SymbolType declaredType = SymbolTypeInference.inferType(getProgram().getScope(), left);
               boolean isModified = addValueCasts(declaredType, binary.getRightValue(), currentStmt);
               if(isModified) {
                  getLog().append("Added casts to value list in " + (currentStmt == null ? "" : currentStmt.toString(getProgram(), false)));
                  modified.set(true);
               }
            }
         }
      });
      return modified.get();
   }

   /**
    * Add cast to a value inside a value list initializer.
    *
    * @param declaredType The declared type of the value
    * @param programValue The value wrapped in a program value
    * @param currentStmt The current statement
    * @return true if anything was modified
    */
   private boolean addValueCasts(SymbolType declaredType, ProgramValue programValue, Statement currentStmt) {
      boolean exprModified = false;
      Value value = programValue.get();
      if(value instanceof ValueList) {
         ValueList valueList = (ValueList) value;
         if(declaredType instanceof SymbolTypeArray) {
            SymbolTypeArray declaredArrayType = (SymbolTypeArray) declaredType;
            // Recursively cast all sub-elements
            SymbolType declaredElmType = declaredArrayType.getElementType();
            int size = valueList.getList().size();
            // TODO: Check declared array size vs. actual size
            for(int i = 0; i < size; i++) {
               exprModified |= addValueCasts(declaredElmType, new ProgramValue.ProgramValueListElement(valueList, i), currentStmt);
            }
            // Add a cast to the value list itself
            programValue.set(new CastValue(declaredType, valueList));
         } else if(declaredType instanceof SymbolTypeStruct) {
            SymbolTypeStruct declaredStructType = (SymbolTypeStruct) declaredType;
            // Recursively cast all sub-elements
            StructDefinition structDefinition = declaredStructType.getStructDefinition(getScope());
            Collection<SymbolVariable> memberDefinitions = structDefinition.getAllVariables(false);
            int size = memberDefinitions.size();
            if(size!=valueList.getList().size()) {
               throw new CompileError(
                     "Struct initializer has wrong size ("+valueList.getList().size()+"), " +
                           "which does not match the number of members in "+declaredStructType.getTypeName()+" (\"+size+\" members).\n" +
                           " Struct initializer: "+valueList.toString(getProgram()),
                     currentStmt);
            }
            Iterator<SymbolVariable> memberDefIt = memberDefinitions.iterator();
            for(int i = 0; i < size; i++) {
               SymbolVariable memberDef = memberDefIt.next();
               exprModified |= addValueCasts(memberDef.getType(), new ProgramValue.ProgramValueListElement(valueList, i), currentStmt);
            }
            // Add a cast to the value list itself
            programValue.set(new CastValue(declaredType, valueList));
         } else {
            // TODO: Handle word/dword initializers
            throw new InternalError("Type not handled! "+declaredType);
         }
      } else {
         SymbolType valueType = SymbolTypeInference.inferType(getProgram().getScope(), (RValue) value);
         if(SymbolType.NUMBER.equals(valueType) || SymbolType.VAR.equals(valueType)) {
            // Check if the value fits.
            if(!SymbolTypeConversion.assignmentTypeMatch(declaredType, valueType)) {
               throw new CompileError("Declared type " + declaredType + " does not match element type " + valueType, currentStmt);
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

}
