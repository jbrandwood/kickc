package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;

import java.util.*;

/**
 * Capable of iterating the different structures of a Program (graph, block, statement, symboltable, symbol).
 * Creates appropriate ProgramValues and passes them to a ProgramValueHandler.
 * Iteration might be guided (eg. filtering some types of the structure to iterate at call-time or guided by a return value from the ProgramValueHandler)
 */
public class ProgramValueIterator {

   /**
    * Execute a handler on all values in the entire program (both in the control flow graph and the symbol table.)
    *
    * @param program The program
    * @param handler The handler to execute
    */
   public static void execute(Program program, ProgramValueHandler handler) {
      execute(program.getScope(), handler);
      execute(program.getGraph(), handler);
   }

   /**
    * Execute a handler on all values in the program scope
    *
    * @param programScope The program scope
    * @param handler The handler to execute
    */
   public static void execute(ProgramScope programScope, ProgramValueHandler handler) {
      for(Variable variable : programScope.getAllVars(true)) {
         execute(variable, handler);
      }
   }

   /**
    * Execute a programValueHandler on all values in a variable symbol (variable or constant).
    *
    * @param variable The symbol variable
    * @param programValueHandler The programValueHandler to execute
    */
   public static void execute(Variable variable, ProgramValueHandler programValueHandler) {
      if(variable.isConstant()) {
         execute(new ProgramValue.ProgramValueConstantVar(variable), programValueHandler, null, null, null);
      }
      if(variable.isArray()) {
         execute(new ProgramValue.ProgramValueArraySize(variable), programValueHandler, null, null, null);
      }
   }

   /**
    * Execute a handler on all values in the program control flow graph
    *
    * @param graph The program control flow graph
    * @param handler The handler to execute
    */
   public static void execute(ControlFlowGraph graph, ProgramValueHandler handler) {
      for(ControlFlowBlock block : graph.getAllBlocks()) {
         execute(block, handler);
      }
   }

   /**
    * Execute a handler on all values in a block of the control flow graph
    *
    * @param block The control flow graph block
    * @param handler The handler to execute
    */
   public static void execute(ControlFlowBlock block, ProgramValueHandler handler) {
      ListIterator<Statement> statementsIt = block.getStatements().listIterator();
      while(statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         execute(statement, handler, statementsIt, block);
      }
      execute(new ProgramValue.BlockLabel(block), handler, null, null, block);
      execute(new ProgramValue.BlockDefaultSuccessor(block), handler, null, null, block);
      execute(new ProgramValue.BlockConditionalSuccessor(block), handler, null, null, block);
      execute(new ProgramValue.BlockCallSuccessor(block), handler, null, null, block);
   }

   /**
    * Execute a handler on all values in a statement
    *
    * @param statement The statement
    * @param handler The handler to execute
    */
   public static void execute(Statement statement, ProgramValueHandler handler, ListIterator<Statement> statementsIt, ControlFlowBlock block) {
      if(statement instanceof StatementAssignment) {
         // The sequence RValue1, RValue2, LValue is important - as it is essential for {@link dk.camelot64.kickc.passes.Pass1GenerateSingleStaticAssignmentForm} to create the correct SSA
         execute(new ProgramValue.RValue1((StatementAssignment) statement), handler, statement, statementsIt, block);
         execute(new ProgramValue.RValue2((StatementAssignment) statement), handler, statement, statementsIt, block);
         execute(new ProgramValue.ProgramValueLValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementCall) {
         StatementCall call = (StatementCall) statement;
         if(call.getParameters() != null) {
            int size = call.getParameters().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.CallParameter(call, i), handler, statement, statementsIt, block);
            }
         }
         execute(new ProgramValue.ProgramValueLValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementCallPrepare) {
         StatementCallPrepare call = (StatementCallPrepare) statement;
         if(call.getParameters() != null) {
            int size = call.getParameters().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.CallPrepareParameter(call, i), handler, statement, statementsIt, block);
            }
         }
      } else if(statement instanceof StatementCallFinalize) {
         execute(new ProgramValue.ProgramValueLValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementCallPointer) {
         StatementCallPointer call = (StatementCallPointer) statement;
         execute(new ProgramValue.CallPointerProcedure((StatementCallPointer) statement), handler, statement, statementsIt, block);
         if(call.getParameters() != null) {
            int size = call.getParameters().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.CallPointerParameter(call, i), handler, statement, statementsIt, block);
            }
         }
         execute(new ProgramValue.ProgramValueLValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementConditionalJump) {
         execute(new ProgramValue.CondRValue1((StatementConditionalJump) statement), handler, statement, statementsIt, block);
         execute(new ProgramValue.CondRValue2((StatementConditionalJump) statement), handler, statement, statementsIt, block);
         execute(new ProgramValue.CondLabel((StatementConditionalJump) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementReturn) {
         execute(new ProgramValue.Return((StatementReturn) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementPhiBlock) {
         for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
            int size = phiVariable.getValues().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.PhiValuePredecessor(phiVariable, i), handler, statement, statementsIt, block);
               execute(new ProgramValue.PhiValue(phiVariable, i), handler, statement, statementsIt, block);
            }
            execute(new ProgramValue.PhiVariable(phiVariable), handler, statement, statementsIt, block);
         }
      } else if(statement instanceof StatementKickAsm) {
         StatementKickAsm statementKickAsm = (StatementKickAsm) statement;
         RValue location = statementKickAsm.getLocation();
         if(location!=null) {
            execute(new ProgramValue.ProgramValueKickAsmLocation(statementKickAsm), handler, statement, statementsIt, block);
         }
         RValue bytes = statementKickAsm.getLocation();
         if(bytes!=null) {
            execute(new ProgramValue.ProgramValueKickAsmBytes(statementKickAsm), handler, statement, statementsIt, block);
         }
         RValue cycles = statementKickAsm.getLocation();
         if(cycles!=null) {
            execute(new ProgramValue.ProgramValueKickAsmCycles(statementKickAsm), handler, statement, statementsIt, block);
         }
         List<SymbolRef> uses = statementKickAsm.getUses();
         for(int i = 0; i < uses.size(); i++) {
            execute(new ProgramValue.KickAsmUses(statementKickAsm, i), handler, statement, statementsIt, block);
         }
      } else if(statement instanceof StatementAsm) {
         StatementAsm statementAsm = (StatementAsm) statement;
         Map<String, SymbolRef> referenced = statementAsm.getReferenced();
         for(String label : referenced.keySet()) {
            execute(new ProgramValue.ProgramValueAsmReferenced(statementAsm, label), handler, statement, statementsIt, block);
         }
      }
   }

   /**
    * Execute the a handler on a value and all sub-values of the value.
    *
    * @param programValue The programValue value
    * @param handler The value handler
    */
   public static void execute(ProgramValue programValue, ProgramValueHandler handler, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
      handler.execute(programValue, currentStmt, stmtIt, currentBlock);
      for(ProgramValue subValue : getSubValues(programValue.get())) {
         execute(subValue, handler, currentStmt, stmtIt, currentBlock);
      }
   }

   /**
    * Get the sub values for an RValue.
    *
    * @param value The RValue
    * @return The sub-values of the RValue (only one level down, recursion is needed to get all contained sub-values)
    */
   private static Collection<ProgramValue> getSubValues(Value value) {
      ArrayList<ProgramValue> subValues = new ArrayList<>();
      if(value instanceof PointerDereferenceIndexed) {
         subValues.add(new ProgramValue.ProgramValuePointer((PointerDereference) value));
         subValues.add(new ProgramValue.ProgramValuePointerIndex((PointerDereferenceIndexed) value));
      } else if(value instanceof PointerDereferenceSimple) {
         subValues.add(new ProgramValue.ProgramValuePointer((PointerDereference) value));
      } else if(value instanceof StructMemberRef) {
         subValues.add(new ProgramValue.ProgramValueStruct((StructMemberRef) value));
      } else if(value instanceof StructUnwoundPlaceholder) {
         int size = ((StructUnwoundPlaceholder) value).getUnwoundMembers().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ProgramValue.ProgramValueStructUnwoundPlaceholderMember((StructUnwoundPlaceholder) value, i));
         }
      } else if(value instanceof ValueList) {
         ValueList valueList = (ValueList) value;
         int size = valueList.getList().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ProgramValue.ProgramValueListElement(valueList, i));
         }
      } else if(value instanceof ConstantArrayList) {
         ConstantArrayList constantArrayList = (ConstantArrayList) value;
         int size = constantArrayList.getElements().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ProgramValue.ProgramValueConstantArrayElement(constantArrayList, i));
         }
      } else if(value instanceof ConstantStructValue) {
         ConstantStructValue constantStructValue = (ConstantStructValue) value;
         for(SymbolVariableRef memberRef : constantStructValue.getMembers()) {
            subValues.add(new ProgramValue.ProgramValueConstantStructMember(constantStructValue, memberRef));
         }
      } else if(value instanceof CastValue) {
         subValues.add(new ProgramValue.ProgramValueCastValue((CastValue) value));
      } else if(value instanceof ConstantCastValue) {
         subValues.add(new ProgramValue.ProgramValueConstantCastValue((ConstantCastValue) value));
      } else if(value instanceof ConstantSymbolPointer) {
         subValues.add(new ProgramValue.ProgramValueConstantSymbolPointerTo((ConstantSymbolPointer) value));
      } else if(value instanceof RangeValue) {
         subValues.add(new ProgramValue.ProgramValueRangeFirst((RangeValue) value));
         subValues.add(new ProgramValue.ProgramValueRangeLast((RangeValue) value));
      } else if(value instanceof ConstantBinary) {
         subValues.add(new ProgramValue.ProgramValueConstantBinaryLeft((ConstantBinary) value));
         subValues.add(new ProgramValue.ProgramValueConstantBinaryRight((ConstantBinary) value));
      } else if(value instanceof ConstantUnary) {
         subValues.add(new ProgramValue.ProgramValueConstantUnaryValue((ConstantUnary) value));
      } else if(value instanceof ConstantArrayFilled) {
         subValues.add(new ProgramValue.ProgramValueConstantArrayFilledSize((ConstantArrayFilled) value));
      } else if(value instanceof ConstantArrayKickAsm) {
         ConstantArrayKickAsm constantArrayKickAsm = (ConstantArrayKickAsm) value;
         List<SymbolRef> uses = constantArrayKickAsm.getUses();
         for(int i = 0; i < uses.size(); i++) {
            subValues.add(new ProgramValue.ProgramValueConstantArrayKickAsmUses(constantArrayKickAsm, i));
         }
      } else if(value instanceof LvalueIntermediate) {
         subValues.add(new ProgramValue.ProgramValueLValueIntermediateVariable((LvalueIntermediate) value));
      } else if(value instanceof ParamValue) {
         subValues.add(new ProgramValue.ProgramValueParamValue((ParamValue) value));
      } else if(value instanceof StackIdxValue) {
         subValues.add(new ProgramValue.ProgramValueStackIdxValue((StackIdxValue) value));
      } else if(value == null ||
            value instanceof SymbolVariableRef ||
            value instanceof Variable ||
            value instanceof ProcedureRef ||
            value instanceof ConstantLiteral ||
            value instanceof StructZero ||
            value instanceof Label ||
            value instanceof LabelRef
            ) {
         // No sub values
      } else {
         throw new RuntimeException("Unhandled value type " + value.getClass());
      }
      return subValues;
   }

}
