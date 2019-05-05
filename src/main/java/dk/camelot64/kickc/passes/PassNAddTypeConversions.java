package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.LValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ScopeRef;

import java.util.List;
import java.util.ListIterator;

/**
 * Add casts in all assignments where types are not equal, but the rValue type can be converted to the lValue type.
 */
public class PassNAddTypeConversions extends Pass2SsaOptimization {

   public PassNAddTypeConversions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         List<Statement> statements = block.getStatements();
         ListIterator<Statement> stmtIt = statements.listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               doConversionAssignment((StatementAssignment) statement, stmtIt, block);
            }
            // TODO: Implement conversion for calls
         }
      }
      return false;
   }

   /**
    * Examines an assignment to determine if a cast of the rValue is needed (the lvalue type and the rvalue type is not equal)
    * and possible (the types are conversion compatible).
    * <p>
    * If a conversion is needed it is added by adding a new tmp-var with a cast and modifying the statement.
    *
    * @param assignment The assignment to examine
    * @param stmtIt Iterator allowing the method to add a tmp-var-assignment.
    */
   private void doConversionAssignment(StatementAssignment assignment, ListIterator<Statement> stmtIt, ControlFlowBlock block) {
      LValue lValue = assignment.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      SymbolType rValueType = SymbolTypeInference.inferTypeRValue(getScope(), assignment);
      if(lValueType.equals(rValueType)) {
         return;
      }
      if(SymbolType.NUMBER.equals(rValueType)) {
         // If the rValue is number type - find the potential types based on the literal value
         List<SymbolTypeIntegerFixed> potentialTypes = SymbolTypeNumberInference.inferTypesRValue(getScope(), assignment);
         if(potentialTypes.size()==0) {
            // number type cannot be calculated currently - save for later
            return;
         }
         for(SymbolTypeIntegerFixed potentialType : potentialTypes) {
            if(lValueType.equals(potentialType) || canConvert(lValueType, potentialType)) {
               addConversionCast(assignment, stmtIt, block, lValueType, rValueType);
               return;
            }
         }
      } else {
         // No direct type match - attempt conversion
         if(canConvert(lValueType, rValueType)) {
            addConversionCast(assignment, stmtIt, block, lValueType, rValueType);
            return;
         }
      }

      // Conversion not possible - report a type error!
      String msg = "ERROR! Type mismatch (" + lValueType.getTypeName() + ") cannot be assigned from (" + rValueType.getTypeName() + "). " +
            "In " + assignment.toString(getProgram(), false);
      getProgram().getLog().append(msg);
      throw new CompileError(msg, assignment.getSource());
   }

   /**
    * Add a conversion cast to the rvalue of an assignment
    *
    * @param assignment The assignment to add the cast to
    * @param lValueType The type of the lValue
    * @param rValueType The type of the rValue
    */
   private void addConversionCast(StatementAssignment assignment, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock, SymbolType lValueType, SymbolType rValueType) {
      // Promotion possible - add tmp-var and a cast
      if(assignment.getOperator() == null) {
         // No operator - add cast directly!
         RValue rValue = assignment.getrValue2();
         if((rValue instanceof ConstantInteger) && SymbolType.NUMBER.equals(((ConstantInteger) rValue).getType()) && SymbolType.isInteger(lValueType)) {
            ((ConstantInteger) rValue).setType(lValueType);
         } else {
            assignment.setOperator(Operators.getCastUnary(lValueType));
         }
         getLog().append("Converting " + rValueType + " to " + lValueType + " in " + assignment);
      } else {
         ScopeRef currentScope = currentBlock.getScope();
         Scope blockScope = getScope().getScope(currentScope);
         VariableIntermediate tmpVar = blockScope.addVariableIntermediate();
         tmpVar.setType(rValueType);
         StatementAssignment newAssignment = new StatementAssignment(assignment.getlValue(), Operators.getCastUnary(lValueType), tmpVar.getRef(), assignment.getSource(), Comment.NO_COMMENTS);
         getLog().append("Converting " + rValueType + " to " + lValueType + " in " + assignment + " adding "+tmpVar);
         assignment.setlValue(tmpVar.getRef());
         stmtIt.add(newAssignment);
      }
   }

   /**
    * Determines if it is possible to convert one type to another
    * as described in C99 6.3.1.8 http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf#page=70
    *
    * @param lValueType The type of the lValue
    * @param rValueType The type of the rValue (that will be cast)
    * @return True if a cast is possible without any loss
    */
   private boolean canConvert(SymbolType lValueType, SymbolType rValueType) {
      if(lValueType instanceof SymbolTypePointer && SymbolType.isWord(rValueType)) {
         return true;
      }
      if(lValueType instanceof SymbolTypeInteger && rValueType instanceof SymbolTypeInteger) {
         SymbolType convertedMathType = SymbolType.convertedMathType((SymbolTypeInteger) lValueType, (SymbolTypeInteger) rValueType);
         if(lValueType.equals(convertedMathType)) {
            return true;
         }
      }
      // No type promotion found
      return false;
   }


}
