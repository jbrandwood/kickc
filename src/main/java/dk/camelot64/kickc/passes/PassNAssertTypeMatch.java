package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeConversion;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.*;

/**
 * Asserts that types match in all assignments and calculations
 */
public class PassNAssertTypeMatch extends Pass2SsaAssertion {

   public PassNAssertTypeMatch(Program program) {
      super(program);
   }

   @Override
   public void check() throws AssertionFailed {
      for(var statement : getGraph().getAllStatements()) {
         if(statement instanceof final StatementAssignment assignment) {
            checkAssignment(assignment);
         }
         // TODO: Implement checking for calls / ...
      }
      for(Variable var : getScope().getAllVars(true)) {
         if(var.getInitValue()!=null) {
            checkVarInit(var);
         }
      }

   }

   private void checkVarInit(Variable variable) {

      SymbolType lValueType = variable.getType();
      final ConstantValue rValue = variable.getInitValue();

      // Test NULL pointer assignment
      if(lValueType instanceof SymbolTypePointer) {
         if(rValue instanceof ConstantInteger && ((ConstantInteger) rValue).getInteger().equals(0L))
            // A null-pointer assignment is OK!
            return;
      }


      SymbolType rValueType = rValue.getType(getScope());
      if(SymbolTypeConversion.assignmentTypeMatch(lValueType, rValueType)) return;
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.toCDecl() + ") cannot be assigned from (" + rValueType.toCDecl() + "). In initialization of " + variable.toString(getProgram()));
      throw new CompileError("Type mismatch (" + lValueType.toCDecl() + ") cannot be assigned from (" + rValueType.toCDecl() + "). In initialization of " + variable.toString(getProgram()));
   }

   private void checkAssignment(StatementAssignment statement) {
      LValue lValue = statement.getlValue();
      SymbolType lValueType = SymbolTypeInference.inferType(getScope(), lValue);
      // Test NULL pointer assignment
      if(lValueType instanceof SymbolTypePointer) {
         final RValue rValue = statement.getrValue2();
         if(rValue instanceof ConstantInteger && ((ConstantInteger) rValue).getInteger().equals(0L))
            // A null-pointer assignment is OK!
            return;
      }

      SymbolType rValueType = SymbolTypeInference.inferType(getScope(), new AssignmentRValue(statement));
      if(SymbolTypeConversion.assignmentTypeMatch(lValueType, rValueType)) return;
      // Types do not match
      getLog().append("ERROR! Type mismatch (" + lValueType.toCDecl() + ") cannot be assigned from (" + rValueType.toCDecl() + "). In " + statement.toString(getProgram(), false));
      throw new CompileError("Type mismatch (" + lValueType.toCDecl() + ") cannot be assigned from (" + rValueType.toCDecl() + "). In " + statement.toString(getProgram(), false), statement.getSource());
   }

}
