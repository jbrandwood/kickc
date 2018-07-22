package dk.camelot64.kickc.model.iterator;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.ConstantVar;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.ListIterator;

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
      for(SymbolVariable symbolVariable : programScope.getAllSymbolVariables(true)) {
         execute(symbolVariable, handler);
      }
   }

   /**
    * Execute a programValueHandler on all values in a variable symbol (variable or constant).
    *
    * @param symbolVariable The symbol variable
    * @param programValueHandler The programValueHandler to execute
    */
   private static void execute(SymbolVariable symbolVariable, ProgramValueHandler programValueHandler) {
      if(symbolVariable.getType() instanceof SymbolTypeArray) {
         execute(new ProgramValue.TypeArraySize((SymbolTypeArray) symbolVariable.getType()), programValueHandler, null, null, null);
      }
      if(symbolVariable instanceof ConstantVar) {
         execute(new ProgramValue.ConstantVariableValue((ConstantVar) symbolVariable), programValueHandler, null, null, null);
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
         execute(new ProgramValue.LValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementCall) {
         StatementCall call = (StatementCall) statement;
         if(call.getParameters() != null) {
            int size = call.getParameters().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.CallParameter(call, i), handler, statement, statementsIt, block);
            }
         }
         execute(new ProgramValue.LValue((StatementLValue) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementConditionalJump) {
         execute(new ProgramValue.CondRValue1((StatementConditionalJump) statement), handler, statement, statementsIt, block);
         execute(new ProgramValue.CondRValue2((StatementConditionalJump) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementReturn) {
         execute(new ProgramValue.Return((StatementReturn) statement), handler, statement, statementsIt, block);
      } else if(statement instanceof StatementPhiBlock) {
         for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
            int size = phiVariable.getValues().size();
            for(int i = 0; i < size; i++) {
               execute(new ProgramValue.PhiValue(phiVariable, i), handler, statement, statementsIt, block);
            }
            execute(new ProgramValue.PhiVariable(phiVariable), handler, statement, statementsIt, block);
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
   private static Collection<ProgramValue> getSubValues(RValue value) {
      ArrayList<ProgramValue> subValues = new ArrayList<>();
      if(value instanceof PointerDereferenceIndexed) {
         subValues.add(new ProgramValue.Pointer((PointerDereference) value));
         subValues.add(new ProgramValue.PointerIndex((PointerDereferenceIndexed) value));
      } else if(value instanceof PointerDereferenceSimple) {
         subValues.add(new ProgramValue.Pointer((PointerDereference) value));
      } else if(value instanceof ValueList) {
         ValueList valueList = (ValueList) value;
         int size = valueList.getList().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ProgramValue.ListElement(valueList, i));
         }
      } else if(value instanceof ConstantArrayList) {
         ConstantArrayList constantArrayList = (ConstantArrayList) value;
         int size = constantArrayList.getElements().size();
         for(int i = 0; i < size; i++) {
            subValues.add(new ProgramValue.ConstantArrayElement(constantArrayList, i));
         }
      } else if(value instanceof CastValue) {
         subValues.add(new ProgramValue.CastValue((CastValue) value));
      } else if(value instanceof ConstantCastValue) {
         subValues.add(new ProgramValue.ConstantCastValue((ConstantCastValue) value));
      } else if(value instanceof ConstantVarPointer) {
         subValues.add(new ProgramValue.VarPointer((ConstantVarPointer) value));
      } else if(value instanceof RangeValue) {
         subValues.add(new ProgramValue.RangeFirst((RangeValue) value));
         subValues.add(new ProgramValue.RangeLast((RangeValue) value));
      } else if(value instanceof ConstantBinary) {
         subValues.add(new ProgramValue.ConstantBinaryLeft((ConstantBinary) value));
         subValues.add(new ProgramValue.ConstantBinaryRight((ConstantBinary) value));
      } else if(value instanceof ConstantUnary) {
         subValues.add(new ProgramValue.ConstantUnaryValue((ConstantUnary) value));
      } else if(value instanceof ArrayFilled) {
         subValues.add(new ProgramValue.ArrayFilledSize((ArrayFilled) value));
      } else if(value instanceof ConstantArrayFilled) {
         subValues.add(new ProgramValue.ConstantArrayFilledSize((ConstantArrayFilled) value));
      } else if(value == null ||
            value instanceof VariableRef ||
            value instanceof ConstantLiteral ||
            value instanceof ConstantRef ||
            value instanceof LvalueIntermediate
            ) {
         // No sub values
      } else {
         throw new RuntimeException("Unhandled value type " + value.getClass());
      }
      return subValues;
   }

}
