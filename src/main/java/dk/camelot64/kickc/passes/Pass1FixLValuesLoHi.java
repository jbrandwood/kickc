package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.VariableBuilder;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.VarAssignments;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

/**
 * Replaces all LValue intermediate lo/hi-assignments with a separate assignment to the modified variable.
 * <br>Example: <code>&lt;plotter = x &amp; 8 </code>
 * <br>Becomes: <code> $1 =x &amp; 8 ,  plotter = plotter lo= $1 </code>
 */
public class Pass1FixLValuesLoHi extends Pass1Base {

   public Pass1FixLValuesLoHi(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      List<VariableRef> intermediates = new ArrayList<>();

      ProgramScope programScope = getProgram().getScope();
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         List<Statement> statements = block.getStatements();
         ListIterator<Statement> statementsIt = statements.listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementLValue && ((StatementLValue) statement).getlValue() instanceof LvalueIntermediate) {
               StatementLValue statementLValue = (StatementLValue) statement;
               LvalueIntermediate intermediate = (LvalueIntermediate) statementLValue.getlValue();
               final List<VarAssignments.VarAssignment> varAssignments = VarAssignments.get(intermediate.getVariable(), getGraph(), programScope);
               if(varAssignments.size() == 1) {
                  final VarAssignments.VarAssignment varAssignment = varAssignments.get(0);
                  if(varAssignment.type.equals(VarAssignments.VarAssignment.Type.STATEMENT_LVALUE) && varAssignment.statementLValue instanceof StatementAssignment) {
                     StatementAssignment intermediateAssignment = (StatementAssignment) varAssignment.statementLValue;
                     if(Operators.LOWBYTE.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue <x = ...
                        fixLoHiLValue(programScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_LOWBYTE);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.HIBYTE.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue >x = ...
                        fixLoHiLValue(programScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_HIBYTE);
                        intermediates.add(intermediate.getVariable());
                     }
                  }
               }
            }
         }
      }

      // Remove intermediates from the code
      Pass2SsaOptimization.removeAssignments(getGraph(), intermediates);
      Pass2SsaOptimization.deleteSymbols(programScope, intermediates);

      return false;
   }

   private void fixLoHiLValue(
         ProgramScope programScope,
         ListIterator<Statement> statementsIt,
         StatementLValue statementLValue,
         LvalueIntermediate intermediate,
         StatementAssignment intermediateAssignment,
         Operator loHiOperator) {
      VariableRef loHiVar = (VariableRef) intermediateAssignment.getrValue2();
      Variable intermediateVar = programScope.getVariable(intermediate.getVariable());
      Scope currentScope = intermediateVar.getScope();
      // Let assignment put value into a tmp Var
      SymbolType type = SymbolTypeInference.inferType(programScope, new AssignmentRValue(intermediateAssignment));
      Variable tmpVar = VariableBuilder.createIntermediate(currentScope, type, getProgram());
      SymbolVariableRef tmpVarRef = tmpVar.getRef();
      statementLValue.setlValue((LValue) tmpVarRef);
      // Insert an extra "set low" assignment statement
      Statement setLoHiAssignment = new StatementAssignment(loHiVar, loHiVar, loHiOperator, tmpVarRef, true, statementLValue.getSource(), new ArrayList<>());
      statementsIt.add(setLoHiAssignment);
      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("Fixing lo/hi-lvalue with new tmpVar " + tmpVarRef + " " + statementLValue.toString());
      }
   }

}
