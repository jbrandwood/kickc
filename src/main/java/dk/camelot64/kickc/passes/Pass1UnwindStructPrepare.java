package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Initializers;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.List;

/**
 * Prepare structs for unwinding.
 * - Constantify all assignment RValues that are structs
 * - Add casts to struct parameter values in calls
 */
public class Pass1UnwindStructPrepare extends Pass2SsaOptimization {

   public Pass1UnwindStructPrepare(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getOperator()==null) {
                  SymbolType lValueType = SymbolTypeInference.inferType(getProgram().getScope(), assignment.getlValue());
                  RValue rValue = assignment.getrValue2();
                  if(!(rValue instanceof ConstantValue) && lValueType instanceof SymbolTypeStruct) {
                     // TODO: Constantify all R-Values?
                     Initializers.ValueTypeSpec lValueTypeSpec = new Initializers.ValueTypeSpec(lValueType);
                     RValue rValueConstantified = Initializers.constantify(rValue, lValueTypeSpec, getProgram(), assignment.getSource());
                     if(!rValue.equals(rValueConstantified)) {
                        assignment.setrValue2(rValueConstantified);
                        getLog().append("Constantified RValue "+assignment.toString(getProgram(), false));
                     }
                  }

               }
            }
            if(statement instanceof StatementCall) {
               final StatementCall call = (StatementCall) statement;
               final Procedure procedure = getProgramScope().getProcedure(call.getProcedure());
               final List<Variable> paramDefs = procedure.getParameters();
               final List<RValue> paramVals = call.getParameters();
               for(int i=0;i<paramDefs.size();i++) {
                  final Variable paramDef = paramDefs.get(i);
                  final RValue paramVal = paramVals.get(i);
                  if(paramDef.getType() instanceof SymbolTypeStruct && paramVal instanceof ValueList) {
                     // Add a cast to the parameter value list
                     paramVals.set(i, new CastValue(paramDef.getType(), paramVal));
                     getLog().append("Added struct type cast to parameter value list "+call.toString(getProgram(), false));
                  }
               }
            }
         }
      }
      return false;
   }


}
