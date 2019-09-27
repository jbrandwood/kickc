package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.ConstantNotLiteral;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ConstantLiteral;
import dk.camelot64.kickc.model.values.ConstantValue;
import dk.camelot64.kickc.model.values.RValue;

import java.util.ListIterator;

/** Pass that replaces multiplications / division with factors of 2 with shifts */
public class Pass2MultiplyToShiftRewriting extends Pass2SsaOptimization {

   public Pass2MultiplyToShiftRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean optimized = false;
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.MULTIPLY.equals(assignment.getOperator()) || Operators.DIVIDE.equals(assignment.getOperator())) {
                  if(assignment.getrValue1() instanceof ConstantValue) continue;
                  ConstantLiteral constantLiteral = getConstantLiteral2(assignment);
                  if(constantLiteral instanceof ConstantInteger) {
                     Long constantInt = ((ConstantInteger) constantLiteral).getInteger();
                     double power2 = Math.log(constantInt) / Math.log(2);
                     if(power2 == 0.0) {
                        // Found multiplication/division with 1 (ONE)
                        getLog().append("Rewriting multiplication to remove identity multiply/divide " + statement.toString(getProgram(), false));
                        assignment.setOperator(null);
                        assignment.setrValue2(assignment.getrValue1());
                        assignment.setrValue1(null);
                        optimized = true;
                     } else if(power2>0.0 && Math.round(power2)==power2 ) {
                        // Found a whole power of 2
                        if(Operators.MULTIPLY.equals(assignment.getOperator())) {
                           getLog().append("Rewriting multiplication to use shift "+statement.toString(getProgram(), false));
                           assignment.setOperator(Operators.SHIFT_LEFT);
                           assignment.setrValue2(new ConstantInteger((long)power2, SymbolType.BYTE));
                           optimized = true;
                        }  else if(Operators.DIVIDE.equals(assignment.getOperator())) {
                           getLog().append("Rewriting division to use shift "+statement.toString(getProgram(), false));
                           assignment.setOperator(Operators.SHIFT_RIGHT);
                           assignment.setrValue2(new ConstantInteger((long)power2, SymbolType.BYTE));
                           optimized = true;
                        }
                     } else if(Operators.MULTIPLY.equals(assignment.getOperator())) {
                        // Multiplication by constant
                        getLog().append("Rewriting multiplication to use shift and addition"+statement.toString(getProgram(), false));
                        stmtIt.previous();
                        Scope scope = getScope().getScope(block.getScope());
                        SymbolType resultType = SymbolTypeInference.inferType(getScope(), assignment.getrValue1());
                        long pow2 = (long) power2;
                        long remains = constantInt - (1L<<pow2);
                        RValue building = assignment.getrValue1();
                        long shiftCount = 0;
                        while(pow2>=0) {
                           long powVal = 1L <<pow2;
                           if(remains>=powVal) {
                              // First add shifts
                              Variable varShift = scope.addVariableIntermediate();
                              varShift.setType(resultType);
                              stmtIt.add(new StatementAssignment(varShift.getRef(), building, Operators.SHIFT_LEFT, new ConstantInteger(shiftCount, SymbolType.BYTE), assignment.getSource(), Comment.NO_COMMENTS));
                              shiftCount = 0;
                              // Then add rvalue1
                              Variable varAdd = scope.addVariableIntermediate();
                              varAdd.setType(resultType);
                              stmtIt.add(new StatementAssignment(varAdd.getRef(), varShift.getRef(), Operators.PLUS, assignment.getrValue1(), assignment.getSource(), Comment.NO_COMMENTS));
                              building = varAdd.getRef();
                              remains -= powVal;
                           }
                           // Add a shift
                           if(pow2>0) {
                              shiftCount++;
                           }
                           pow2--;
                        }
                        // add remaining shifts
                        if(shiftCount>0) {
                           Variable varShift = scope.addVariableIntermediate();
                           varShift.setType(resultType);
                           stmtIt.add(new StatementAssignment(varShift.getRef(), building, Operators.SHIFT_LEFT, new ConstantInteger(shiftCount, SymbolType.BYTE), assignment.getSource(), Comment.NO_COMMENTS));
                           building = varShift.getRef();
                        }
                        stmtIt.next();
                        // Replace old multiplication
                        assignment.setOperator(null);
                        assignment.setrValue1(null);
                        assignment.setrValue2(building);
                     }
                  }
               }
            }
         }
      }
      return optimized;
   }

   /**
    * Get the constant literal value for RValue2 - or null if not possible
    *
    * @param assignment The Assignment
    * @return The constant literal value for RValue2 (or null)
    */
   private ConstantLiteral getConstantLiteral2(StatementAssignment assignment) {
      if(assignment.getrValue2() instanceof ConstantValue) {
         ConstantValue constantValue = (ConstantValue) assignment.getrValue2();
         try {
            return constantValue.calculateLiteral(getScope());
         } catch(ConstantNotLiteral e) {
            return null;
         }
      } else {
         return null;
      }
   }


}
