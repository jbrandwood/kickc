package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
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
               Procedure procedure = getProgramScope().getProcedure(procedureRef);
               if(procedure.isDeclaredInline()) {
                  procedure.setCallingConvention(Procedure.CallingConvention.PHI_CALL);
                  if(procedure.getInterruptType()!=null) {
                     throw new CompileError("Error! Interrupts cannot be inlined. "+procedure.getRef().toString());
                  }
                  inlineProcedureCall(call, procedure, statementsIt, block, blocksIt);
                  // Exit and restart
                  return true;
               }
            }
         }
      }
      return false;
   }

   /**
    * Inline a specific call to a procedure.
    *
    * @param call The call to inline
    * @param procedure The procedure being called
    * @param statementsIt The statement iterator pointing to the call statement
    * @param block The block containing the call
    * @param blocksIt The block iterator pointing to the block containing the call
    */
   private void inlineProcedureCall(StatementCall call, Procedure procedure, ListIterator<Statement> statementsIt, ControlFlowBlock block, ListIterator<ControlFlowBlock> blocksIt) {
      Scope callScope = getProgramScope().getScope(block.getScope());
      // Remove call
      statementsIt.remove();
      // Find call serial number (handles when multiple calls to the same procedure is made in the call scope)
      int serial = nextSerial(procedure, callScope);
      // Copy all procedure symbols
      inlineSymbols(procedure, callScope, serial);
      // Generate parameter assignments
      inlineParameterAssignments(statementsIt, call, procedure, callScope, serial);
      // Create a new block label for the rest of the calling block
      Label restBlockLabel = callScope.addLabelIntermediate();
      // Copy all procedure blocks
      List<ControlFlowBlock> procedureBlocks = getGraph().getScopeBlocks(procedure.getRef());
      for(ControlFlowBlock procedureBlock : procedureBlocks) {
         LabelRef procBlockLabelRef = procedureBlock.getLabel();
         Symbol procBlockLabel = getProgramScope().getSymbol(procBlockLabelRef);
         Label inlinedBlockLabel;
         if(procedure.equals(procBlockLabel)) {
            inlinedBlockLabel = callScope.getLocalLabel(procedure.getLocalName() + serial);
         } else {
            String inlinedBlockLabelName = getInlineSymbolName(procedure, procBlockLabel, serial);
            inlinedBlockLabel = callScope.getLocalLabel(inlinedBlockLabelName);
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
            LabelRef inlinedSuccessor = inlineSuccessor(procBlockSuccessorRef, procedure, callScope, serial, restBlockLabel);
            inlineBlock.setDefaultSuccessor(inlinedSuccessor);
         }
         if(procedureBlock.getConditionalSuccessor() != null) {
            LabelRef procBlockSuccessorRef = procedureBlock.getConditionalSuccessor();
            LabelRef inlinedSuccessor = inlineSuccessor(procBlockSuccessorRef, procedure, callScope, serial, restBlockLabel);
            inlineBlock.setConditionalSuccessor(inlinedSuccessor);
         }
      }
      // Create a new block for the rest of the calling block
      ControlFlowBlock restBlock = new ControlFlowBlock(restBlockLabel.getRef(), callScope.getRef());
      blocksIt.add(restBlock);
      // Generate return assignment
      if(!procedure.getReturnType().equals(SymbolType.VOID)) {
         Variable procReturnVar = procedure.getLocalVariable("return");
         String inlinedReturnVarName = getInlineSymbolName(procedure, procReturnVar, serial);
         Variable inlinedReturnVar = callScope.getLocalVariable(inlinedReturnVarName);
         restBlock.addStatement(new StatementAssignment(call.getlValue(), inlinedReturnVar.getRef(), false, call.getSource(), Comment.NO_COMMENTS));
      } else {
         // Remove the tmp var receiving the result
         LValue lValue = call.getlValue();
         if(lValue instanceof VariableRef) {
            callScope.remove(getProgramScope().getVariable((VariableRef) lValue));
            call.setlValue(null);
         }
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
      Label inlinedProcLabel = callScope.getLocalLabel(procedure.getLocalName() + serial);
      block.setDefaultSuccessor(inlinedProcLabel.getRef());
      // Set conditional successor of original block to null (as any condition has been moved to the rest block)
      block.setConditionalSuccessor(null);
      // Log the inlining
      getLog().append("Inlined call " + call.toString(getProgram(), false));
   }

   private LabelRef inlineSuccessor(LabelRef procBlockSuccessorRef, Procedure procedure, Scope callScope, int serial, Label restBlockLabel) {
      LabelRef inlinedSuccessor;
      if(procBlockSuccessorRef.getFullName().equals(SymbolRef.PROCEXIT_BLOCK_NAME)) {
         // Set successor of the @return block to the rest block
         inlinedSuccessor = restBlockLabel.getRef();
      } else {
         Label procBlockSuccessor = getProgramScope().getLabel(procBlockSuccessorRef);
         String inlinedSuccessorName = getInlineSymbolName(procedure, procBlockSuccessor, serial);
         Label inlinedSuccessorLabel = callScope.getLocalLabel(inlinedSuccessorName);
         inlinedSuccessor = inlinedSuccessorLabel.getRef();
      }
      return inlinedSuccessor;
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
         if(callScope.getLocalLabel(localName) == null) {
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
         inlinedStatement = new StatementAssignment(procAssignment.getlValue(), procAssignment.getrValue1(), procAssignment.getOperator(), procAssignment.getrValue2(), procAssignment.isInitialAssignment(), procAssignment.getSource(), Comment.NO_COMMENTS);
      } else if(procStatement instanceof StatementCall) {
         StatementCall procCall = (StatementCall) procStatement;
         StatementCall inlinedCall = new StatementCall(procCall.getlValue(), procCall.getProcedureName(), new ArrayList<>(procCall.getParameters()), procCall.getSource(), procCall.getComments());
         inlinedCall.setProcedure(procCall.getProcedure());
         inlinedStatement = inlinedCall;
      } else if(procStatement instanceof StatementAsm) {
         StatementAsm procAsm = (StatementAsm) procStatement;
         StatementAsm inlinedAsm = new StatementAsm(procAsm.getAsmLines(), new LinkedHashMap<>(procAsm.getReferenced()), procAsm.getDeclaredClobber(), procAsm.getSource(), Comment.NO_COMMENTS);
         inlinedStatement = inlinedAsm;
      } else if(procStatement instanceof StatementKickAsm) {
         StatementKickAsm procKasm = (StatementKickAsm) procStatement;
         StatementKickAsm inlinedAsm = new StatementKickAsm(procKasm.getKickAsmCode(), procKasm.getBytes(), procKasm.getCycles(), procKasm.getUses(), procKasm.getDeclaredClobber(), procKasm.getSource(), Comment.NO_COMMENTS);
         inlinedStatement = inlinedAsm;
      } else if(procStatement instanceof StatementConditionalJump) {
         StatementConditionalJump procConditional = (StatementConditionalJump) procStatement;
         LabelRef procDestinationRef = procConditional.getDestination();
         Label procDestination = getProgramScope().getLabel(procDestinationRef);
         Label inlinedDest = procDestination;
         if(procDestination.getScope().equals(procedure)) {
            String inlineSymbolName = getInlineSymbolName(procedure, procDestination, serial);
            inlinedDest = callScope.getLocalLabel(inlineSymbolName);
         }
         StatementConditionalJump inlinedConditionalJump = new StatementConditionalJump(procConditional.getrValue1(), procConditional.getOperator(), procConditional.getrValue2(), inlinedDest.getRef(), procConditional.getSource(), Comment.NO_COMMENTS);
         inlinedConditionalJump.setDeclaredUnroll(procConditional.isDeclaredUnroll());
         inlinedStatement = inlinedConditionalJump;
      } else if(procStatement instanceof StatementReturn) {
         // No statement needed
         return null;
      } else {
         throw new CompileError("Statement type of Inline function not handled " + procStatement, procStatement.getSource());
      }
      if(inlinedStatement!=null) {
         ProgramValueIterator.execute(inlinedStatement, new RValueInliner(procedure, serial, callScope), null, null);
      }
      return inlinedStatement;
   }

   /**
    * Ensures that all VariableRefs pointing to variables in the procedure being inlined are converted to refs to the new inlined variables
    * Also copies all intermediate RValue objects to ensure they are not references to objects from the original statements in the procedure being inlined
    */
   private class RValueInliner implements ProgramValueHandler {

      /** The scope where the precedure is being inlined into. */
      private final Scope callScope;
      /** The procedure being inlined. */
      private final Procedure procedure;
      /** The serial number (counted up for each inlined call to the same function within the called calling scope) */
      private final int serial;

      public RValueInliner(Procedure procedure, int serial, Scope callScope) {
         this.procedure = procedure;
         this.serial = serial;
         this.callScope = callScope;
      }

      @Override
      public void execute(ProgramValue programValue, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
         Value rValue = programValue.get();
         if(rValue instanceof VariableRef) {
            VariableRef procVarRef = (VariableRef) rValue;
            Variable procVar = Pass1ProcedureInline.this.getProgramScope().getVariable(procVarRef);
            if(procVar.getScope().equals(procedure)) {
               String inlineSymbolName = Pass1ProcedureInline.this.getInlineSymbolName(procedure, procVar, serial);
               Variable inlineVar = callScope.getLocalVariable(inlineSymbolName);
               programValue.set(inlineVar.getRef());
            }
         } else if(rValue instanceof PointerDereferenceSimple) {
            programValue.set(new PointerDereferenceSimple(((PointerDereferenceSimple) rValue).getPointer()));
         } else if(rValue instanceof PointerDereferenceIndexed) {
            programValue.set(new PointerDereferenceIndexed(((PointerDereferenceIndexed) rValue).getPointer(), ((PointerDereferenceIndexed) rValue).getIndex()));
         } else if(rValue instanceof CastValue) {
            programValue.set(new CastValue(((CastValue) rValue).getToType(), ((CastValue) rValue).getValue()));
         } else if(rValue instanceof ValueList) {
            programValue.set(new ValueList(new ArrayList<>(((ValueList) rValue).getList())));
         }
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
   private void inlineParameterAssignments(ListIterator<Statement> statementsIt, StatementCall call, Procedure procedure, Scope callScope, int serial) {
      List<Variable> parameterDecls = procedure.getParameters();
      List<RValue> parameterValues = call.getParameters();
      for(int i = 0; i < parameterDecls.size(); i++) {
         Variable parameterDecl = parameterDecls.get(i);
         String inlineParameterVarName = getInlineSymbolName(procedure, parameterDecl, serial);
         Variable inlineParameterVar = callScope.getLocalVariable(inlineParameterVarName);
         RValue parameterValue = parameterValues.get(i);
         statementsIt.add(new StatementAssignment((VariableRef)inlineParameterVar.getRef(), parameterValue, true, call.getSource(), Comment.NO_COMMENTS));
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
            Variable inlineVar = Variable.createCopy(inlineVarName, callScope, procVar);
            callScope.add(inlineVar);
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
