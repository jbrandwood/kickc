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
               final Scope currentScope = programScope.getScope(block.getScope());
               if(varAssignments.size() == 1) {
                  final VarAssignments.VarAssignment varAssignment = varAssignments.get(0);
                  if(varAssignment.type.equals(VarAssignments.VarAssignment.Type.STATEMENT_LVALUE) && varAssignment.statementLValue instanceof StatementAssignment) {
                     StatementAssignment intermediateAssignment = (StatementAssignment) varAssignment.statementLValue;
                     if(Operators.BYTE0.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue byte0(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_BYTE0);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.BYTE1.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue byte1(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_BYTE1);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.BYTE2.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue byte2(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_BYTE2);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.BYTE3.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue byte3(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_BYTE3);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.WORD0.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue word0(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_WORD0);
                        intermediates.add(intermediate.getVariable());
                     } else if(Operators.WORD1.equals(intermediateAssignment.getOperator()) && intermediateAssignment.getrValue1() == null) {
                        // Found assignment to an intermediate low byte lValue word1(x) = ...
                        fixLoHiLValue(programScope, currentScope, statementsIt, statementLValue, intermediate, intermediateAssignment, Operators.SET_WORD1);
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
         Scope currentScope,
         ListIterator<Statement> statementsIt,
         StatementLValue statementLValue,
         LvalueIntermediate intermediate,
         StatementAssignment intermediateAssignment,
         Operator loHiOperator) {
      final RValue intermediateValue = intermediateAssignment.getrValue2();
      // Let assignment put value into a tmp Var
      SymbolType type = SymbolTypeInference.inferType(programScope, new AssignmentRValue(intermediateAssignment));
      Variable tmpVar = VariableBuilder.createIntermediate(currentScope, type, getProgram());
      SymbolVariableRef tmpVarRef = tmpVar.getRef();
      statementLValue.setlValue((LValue) tmpVarRef);
      // Insert an extra "set low" assignment statement
      // TODO: Copy intermediateValue
      final LValue lValue = Pass0GenerateStatementSequence.copyLValue((LValue) intermediateValue);
      Statement setLoHiAssignment = new StatementAssignment(lValue, intermediateValue, loHiOperator, tmpVarRef, true, statementLValue.getSource(), new ArrayList<>());
      statementsIt.add(setLoHiAssignment);
      if(getLog().isVerbosePass1CreateSsa()) {
         getLog().append("Fixing lo/hi-lvalue with new tmpVar " + tmpVarRef + " " + statementLValue.toString());
      }
   }

}
