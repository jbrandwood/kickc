package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.statements.StatementReturn;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.values.*;

import java.util.List;
import java.util.ListIterator;

/** Pass that modifies a control flow graph to inline any procedures declared as inline */
public class Pass1ProcedureInline extends Pass1Base {

   public Pass1ProcedureInline(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      List<ControlFlowBlock> allBlocks = getGraph().getAllBlocks();
      ListIterator<ControlFlowBlock> blocksIt = allBlocks.listIterator();
      while(blocksIt.hasNext()) {
         ControlFlowBlock block = blocksIt.next();
         List<Statement> blockStatements = block.getStatements();
         ListIterator<Statement> statementsIt = blockStatements.listIterator();
         while(statementsIt.hasNext()) {
            Statement statement = statementsIt.next();
            if(statement instanceof StatementCall) {
               StatementCall call = (StatementCall) statement;
               ProcedureRef procedureRef = call.getProcedure();
               Procedure procedure = getScope().getProcedure(procedureRef);
               if(procedure.isDeclaredInline()) {
                  Scope callScope = getScope().getScope(block.getScope());
                  // Remove call
                  statementsIt.remove();
                  // Find call serial number (handles when multiple calls to the same procedure is made in the call scope)
                  int serial = nextSerial(procedure, callScope);
                  // Copy all procedure symbols
                  inlineSymbols(procedure, callScope, serial);
                  // Generate parameter assignments
                  generateParameterAssignments(statementsIt, call, procedure, callScope, serial);
                  // Create a new block label for the rest of the calling block
                  Label restBlockLabel = callScope.addLabelIntermediate();
                  // Copy all procedure blocks
                  List<ControlFlowBlock> procedureBlocks = getGraph().getScopeBlocks(procedure.getRef());
                  for(ControlFlowBlock procedureBlock : procedureBlocks) {
                     LabelRef procBlockLabelRef = procedureBlock.getLabel();
                     Symbol procBlockLabel = getScope().getSymbol(procBlockLabelRef);
                     Label inlinedBlockLabel;
                     if(procedure.equals(procBlockLabel)) {
                        inlinedBlockLabel = callScope.getLabel(procedure.getLocalName() + serial);
                     } else {
                        String inlinedBlockLabelName = getInlineSymbolName(procedure, procBlockLabel, serial);
                        inlinedBlockLabel = callScope.getLabel(inlinedBlockLabelName);
                     }
                     ControlFlowBlock inlineBlock = new ControlFlowBlock(inlinedBlockLabel.getRef(), callScope.getRef());
                     blocksIt.add(inlineBlock);
                     for(Statement procStatement : procedureBlock.getStatements()) {
                        Statement inlinedStatement = inlineStatement(procStatement, procedure, callScope, serial);
                        if(inlinedStatement != null) {
                           inlineBlock.addStatement(inlinedStatement);
                        }
                     }
                     // Set successors
                     if(procedureBlock.getDefaultSuccessor() != null) {
                        LabelRef procBlockSuccessorRef = procedureBlock.getDefaultSuccessor();
                        if(procBlockSuccessorRef.getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
                           // Set successor of the @return block to the rest block
                           inlineBlock.setDefaultSuccessor(restBlockLabel.getRef());
                        } else {
                           Label procBlockSuccessor = getScope().getLabel(procBlockSuccessorRef);
                           String inlinedSuccessorName = getInlineSymbolName(procedure, procBlockSuccessor, serial);
                           Label inlinedSuccessorLabel = callScope.getLabel(inlinedSuccessorName);
                           inlineBlock.setDefaultSuccessor(inlinedSuccessorLabel.getRef());
                        }
                     }
                     if(procedureBlock.getConditionalSuccessor() != null) {
                        throw new CompileError("Not implemented Inline function conditional successors");
                     }
                  }
                  // Create a new block for the rest of the calling block
                  ControlFlowBlock restBlock = new ControlFlowBlock(restBlockLabel.getRef(), callScope.getRef());
                  blocksIt.add(restBlock);
                  // Generate return assignment
                  if(call.getlValue() != null) {
                     Variable procReturnVar = procedure.getVariable("return");
                     String inlinedReturnVarName = getInlineSymbolName(procedure, procReturnVar, serial);
                     Variable inlinedReturnVar = callScope.getVariable(inlinedReturnVarName);
                     restBlock.addStatement(new StatementAssignment(call.getlValue(), inlinedReturnVar.getRef()));
                  }
                  // Copy the rest of the calling block to the new block
                  while(statementsIt.hasNext()) {
                     Statement restStatement = statementsIt.next();
                     statementsIt.remove();
                     restBlock.addStatement(restStatement);
                  }
                  // Set the successors for the rest block
                  restBlock.setDefaultSuccessor(block.getDefaultSuccessor());
                  restBlock.setConditionalSuccessor(block.getConditionalSuccessor());
                  // Set default successor to the original block to the inlined procedure block
                  Label inlinedProcLabel = callScope.getLabel(procedure.getLocalName() + serial);
                  block.setDefaultSuccessor(inlinedProcLabel.getRef());
                  // Log the inlining
                  getLog().append("Inlined call " + call.toString(getProgram(), false));
                  // Exit and restart
                  return true;
               }
            }
         }
      }
      return false;
   }


   /**
    * Find the next inline serial number for the procedure being inlined in the calling scope.
    * The serial number handles when the same procedure is inlined many times in the same scope.
    * Each inlineng gets its own serial - which generates inlined symbol names with different names.
    *
    * @param procedure The procedure being inlined
    * @param callScope the scope it is being inlined into
    * @return the next available serial number
    */
   private int nextSerial(Procedure procedure, Scope callScope) {
      int serial = 1;
      while(true) {
         String localName = procedure.getLocalName() + serial;
         if(callScope.getLabel(localName) == null) {
            return serial;
         }
         serial++;
      }
   }

   /**
    * Inline a statement from a procedure being inlined
    *
    * @param procStatement The statement to inline
    * @param procedure The procedure being inlined
    * @param callScope The scope where the procedure is being inlined
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    * @return A new statement that has inlined all references to variables etc.
    */
   private Statement inlineStatement(Statement procStatement, Procedure procedure, Scope callScope, int serial) {
      Statement inlinedStatement;
      if(procStatement instanceof StatementAssignment) {
         StatementAssignment procAssignment = (StatementAssignment) procStatement;
         LValue inlineLValue = inlineLValue(procAssignment.getlValue(), procedure, callScope, serial);
         RValue inlineRValue1 = inlineRValue(procAssignment.getrValue1(), procedure, callScope, serial);
         RValue inlineRValue2 = inlineRValue(procAssignment.getrValue2(), procedure, callScope, serial);
         inlinedStatement = new StatementAssignment(inlineLValue, inlineRValue1, procAssignment.getOperator(), inlineRValue2);
      } else if(procStatement instanceof StatementReturn) {
         // No statement needed
         return null;
      } else {
         throw new CompileError("Statement type of Inline function not handled " + procStatement);
      }
      return inlinedStatement;
   }

   /**
    * Find/create a new LValue to use when inlining an LValue from a procedure
    *
    * @param lValue The LValue bein used inside the procedure being inlined
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    * @return The LValue to use where the procedure is inlined.
    */
   private LValue inlineLValue(LValue lValue, Procedure procedure, Scope callScope, int serial) {
      return (LValue) inlineRValue(lValue, procedure, callScope, serial);
   }

   /**
    * Find/create a new RValue to use when inlining an RValue from a procedure
    *
    * @param rValue The RValue bein used inside the procedure being inlined
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    * @return The RValue to use where the procedure is inlined.
    */
   private RValue inlineRValue(RValue rValue, Procedure procedure, Scope callScope, int serial) {
      if(rValue == null) {
         return null;
      } else if(rValue instanceof VariableRef) {
         VariableRef procVarRef = (VariableRef) rValue;
         Variable procVar = getScope().getVariable(procVarRef);
         if(procVar.getScope().equals(procedure)) {
            String inlineSymbolName = getInlineSymbolName(procedure, procVar, serial);
            Variable inlineVar = callScope.getVariable(inlineSymbolName);
            return inlineVar.getRef();
         } else {
            return procVarRef;
         }
      } else if(rValue instanceof ConstantValue) {
         return rValue;
      } else {
         throw new CompileError("Symbol Type of Inline function not handled " + rValue);
      }
   }

   /**
    * Generate assignments for the parameters of the inlined function.
    *
    * @param statementsIt The statements iterator to add the assignments for
    * @param call The call to the procedure being inlined
    * @param procedure The procedure being inlined
    * @param callScope The scope where the function is being inlined
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    */
   private void generateParameterAssignments(ListIterator<Statement> statementsIt, StatementCall call, Procedure procedure, Scope callScope, int serial) {
      List<Variable> parameterDecls = procedure.getParameters();
      List<RValue> parameterValues = call.getParameters();
      for(int i = 0; i < parameterDecls.size(); i++) {
         Variable parameterDecl = parameterDecls.get(i);
         String inlineParameterVarName = getInlineSymbolName(procedure, parameterDecl, serial);
         Variable inlineParameterVar = callScope.getVariable(inlineParameterVarName);
         RValue parameterValue = parameterValues.get(i);
         statementsIt.add(new StatementAssignment(inlineParameterVar.getRef(), parameterValue));
      }
   }

   /**
    * Copy all symbols of the procedure being inlined to the calling scope.
    *
    * @param procedure The procedure being inlined
    * @param callScope The calling scope
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    */
   private void inlineSymbols(Procedure procedure, Scope callScope, int serial) {
      // Add a label for the produre itself
      callScope.addLabel(procedure.getLocalName() + serial);
      // And copy all procedure symbols
      for(Symbol procSymbol : procedure.getAllSymbols()) {
         if(procSymbol instanceof Variable) {
            Variable procVar = (Variable) procSymbol;
            String inlineVarName = getInlineSymbolName(procedure, procSymbol, serial);
            VariableUnversioned inlineVar = callScope.addVariable(inlineVarName, procSymbol.getType());
            inlineVar.setInferredType(procVar.isInferredType());
            inlineVar.setDeclaredAlignment(procVar.getDeclaredAlignment());
            inlineVar.setDeclaredConstant(procVar.isDeclaredConstant());
            inlineVar.setDeclaredRegister(procVar.getDeclaredRegister());
         } else if(procSymbol instanceof Label) {
            String inlineLabelName = getInlineSymbolName(procedure, procSymbol, serial);
            callScope.addLabel(inlineLabelName);
         } else {
            throw new CompileError("Symbol Type of Inline function not handled " + procSymbol);
         }
      }
   }

   /**
    * Get the new name of a symbol from the procedure being inlined .
    * The name is &lt;proc&gt;_&lt;symb&gt;, where &lt;proc&gt; is the name of the procedure and &lt;symb&gt; is the local name of the symbol.
    *
    * @param procedure The procedure being inlined
    * @param procSymbol The symbol from the inlined procedure
    * @param serial The serial number (counted up for each inlined call to the same function within the called calling scope).
    * @return The new name used for the symbol, where it is inlined.
    */
   private String getInlineSymbolName(Procedure procedure, Symbol procSymbol, int serial) {
      return procedure.getLocalName() + serial + "_" + procSymbol.getLocalName();
   }

}
