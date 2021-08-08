package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramExpressionBinary;
import dk.camelot64.kickc.model.iterator.ProgramExpressionIterator;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCallPointer;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantSymbolPointer;
import dk.camelot64.kickc.model.values.PointerDereferenceSimple;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Add a cast a variable is assigned something of a convertible type.
 */
public class PassNAddTypeConversionAssignment extends Pass2SsaOptimization {

   private boolean pass1;

   public PassNAddTypeConversionAssignment(Program program, boolean pass1) {
      super(program);
      this.pass1 = pass1;
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);
      ProgramExpressionIterator.execute(getProgram(), (programExpression, currentStmt, stmtIt, currentBlock) -> {
         if(programExpression instanceof ProgramExpressionBinary) {
            ProgramExpressionBinary binary = (ProgramExpressionBinary) programExpression;
            RValue left = binary.getLeft();
            RValue right = binary.getRight();
            SymbolType leftType;
            SymbolType rightType;
            try {
               leftType = SymbolTypeInference.inferType(getProgram().getScope(), left);
               rightType = SymbolTypeInference.inferType(getProgram().getScope(), right);
            } catch(CompileError e) {
               throw new CompileError(e.getMessage(), currentStmt.getSource());
            }
            if(!SymbolTypeConversion.assignmentTypeMatch(leftType, rightType) || SymbolType.VAR.equals(rightType)) {
               // Assigning a pointer from an unsigned word
               if(programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryAssignmentLValue || programExpression instanceof ProgramExpressionBinary.ProgramExpressionBinaryCallParameter) {
                  if((leftType instanceof SymbolTypePointer) && rightType instanceof SymbolTypePointer && SymbolType.VOID.equals(((SymbolTypePointer) leftType).getElementType())) {
                     if(!pass1 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding void pointer type conversion cast (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getProgram());
                     modified.set(true);
                  } else if((leftType instanceof SymbolTypePointer) && rightType instanceof SymbolTypePointer && SymbolType.VOID.equals(((SymbolTypePointer) rightType).getElementType())) {
                     if(!pass1 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding pointer type conversion cast to void pointer (" + leftType + ") " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     binary.addRightCast(leftType, stmtIt, currentBlock.getScope(), getProgram());
                     modified.set(true);
                  } else if((leftType instanceof SymbolTypePointer) && (((SymbolTypePointer) leftType).getElementType() instanceof SymbolTypeProcedure) && rightType instanceof SymbolTypeProcedure) {
                     // Assigning procedure to pointer to procedure - add pointer
                     if(!pass1 || getLog().isVerbosePass1CreateSsa())
                        getLog().append("Adding address-of to function reference " + binary.getRight().toString() + " in " + currentStmt.toString(getProgram(), false));
                     ProgramValue rightValue = binary.getRightValue();
                     rightValue.set(new ConstantSymbolPointer((SymbolRef) rightValue.get()));
                  }
               }
            }
         }
      });

      // Add dereference to call to pointer to function
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementCallPointer) {
               RValue procedure = ((StatementCallPointer) statement).getProcedure();
               SymbolType procType = SymbolTypeInference.inferType(getScope(), procedure);
               if(procType instanceof SymbolTypePointer && ((SymbolTypePointer) procType).getElementType() instanceof SymbolTypeProcedure) {
                  // Allow calling pointer to procedure directly
                  // Add an automatic dereference to a pointer to procedure
                  if(!pass1 || getLog().isVerbosePass1CreateSsa())
                     getLog().append("Adding dereference to call function pointer " + procedure.toString() + " in " + statement.toString(getProgram(), false));
                  ((StatementCallPointer) statement).setProcedure(new PointerDereferenceSimple(procedure));
               }
            }
         }
      }

      return modified.get();
   }

}
