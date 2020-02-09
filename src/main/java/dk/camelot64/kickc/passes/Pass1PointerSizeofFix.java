package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

import java.util.LinkedHashMap;
import java.util.ListIterator;
import java.util.Map;

/**
 * Fixes pointer math to use sizeof(type)
 */
public class Pass1PointerSizeofFix extends Pass1Base {

   public Pass1PointerSizeofFix(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if((assignment.getrValue1() == null) && (assignment.getOperator() != null) && (assignment.getrValue2() != null)) {
                  fixPointerUnary(assignment);
               } else if((assignment.getrValue1() != null) && (assignment.getOperator() != null) && (assignment.getrValue2() != null)) {
                  fixPointerBinary(block, stmtIt, assignment);
               }
            }
         }
      }

      // For each statement maps RValues used as index to the new *sizeof() variable created
      Map<Statement, Map<RValue, SymbolVariableRef>> handled = new LinkedHashMap<>();
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         if(programValue.get() instanceof ConstantBinary) {
            ConstantBinary binary = (ConstantBinary) programValue.get();
            if(Operators.PLUS.equals(binary.getOperator()) || Operators.MINUS.equals(binary.getOperator())) {
               SymbolTypePointer pointerType = getPointerType(binary.getLeft());
               if(pointerType!=null && pointerType.getElementType().getSizeBytes() > 1) {
                  getLog().append("Fixing constant pointer addition " + binary.toString(getProgram()));
                  ConstantRef sizeOfTargetType = SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType());
                  binary.setRight(new ConstantBinary(binary.getRight(), Operators.MULTIPLY, sizeOfTargetType));
               }
            }
         } else if(programValue.get() instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed deref = (PointerDereferenceIndexed) programValue.get();
            SymbolTypePointer pointerType = getPointerType(deref.getPointer());
            if(pointerType != null) {
               if(pointerType.getElementType().getSizeBytes() > 1) {
                  // Array-indexing into a non-byte pointer - multiply by sizeof()
                  getLog().append("Fixing pointer array-indexing " + deref.toString(getProgram()));
                  SymbolVariableRef idx2VarRef = handled.getOrDefault(currentStmt, new LinkedHashMap<>()).get(deref.getIndex());
                  if(idx2VarRef == null) {
                     Variable idx2Var = getScope().getScope(currentBlock.getScope()).addVariableIntermediate();
                     idx2Var.setType(SymbolTypeInference.inferType(getScope(), deref.getIndex()));
                     ConstantRef sizeOfTargetType = SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType());
                     StatementAssignment idx2 = new StatementAssignment((LValue) idx2Var.getRef(), deref.getIndex(), Operators.MULTIPLY, sizeOfTargetType, true, currentStmt.getSource(), Comment.NO_COMMENTS);
                     stmtIt.previous();
                     stmtIt.add(idx2);
                     stmtIt.next();
                     idx2VarRef = idx2Var.getRef();
                     handled.putIfAbsent(currentStmt, new LinkedHashMap<>());
                     handled.get(currentStmt).put(deref.getIndex(), idx2VarRef);
                  }
                  deref.setIndex(idx2VarRef);
               }
            }
         }
      });
      return false;
   }

   /**
    * Examine if the binary operation in the assignment is a pointer operation - and fix it to reflect sizeof()
    *
    * @param assignment The assignment statement
    */

   public void fixPointerBinary(ControlFlowBlock block, ListIterator<Statement> stmtIt, StatementAssignment assignment) {
      SymbolTypePointer pointerType = getPointerType(assignment.getrValue1());
      if(pointerType != null) {
         if(SymbolType.VOID.equals(pointerType.getElementType())) {
            if(Operators.PLUS.equals(assignment.getOperator()) || Operators.MINUS.equals(assignment.getOperator())) {
               throw new CompileError("Void pointer math not allowed. ", assignment);
            }
         }
         if(pointerType.getElementType().getSizeBytes() > 1) {
            if(Operators.PLUS.equals(assignment.getOperator()) || Operators.MINUS.equals(assignment.getOperator())) {
               boolean isPointerPlusConst = true;
               if(assignment.getrValue2() instanceof SymbolVariableRef) {
                  Symbol symbolR2 = getScope().getSymbol((SymbolVariableRef) assignment.getrValue2());
                  if(symbolR2.getType() instanceof SymbolTypePointer) {
                     // RValue 2 is a pointer
                     isPointerPlusConst = false;
                     getLog().append("Fixing pointer addition " + assignment.toString(getProgram(), false));
                     LValue lValue = assignment.getlValue();
                     Variable tmpVar = getScope().getScope(block.getScope()).addVariableIntermediate();
                     tmpVar.setType(SymbolTypeInference.inferType(getScope(), assignment.getlValue()));
                     assignment.setlValue((LValue) tmpVar.getRef());
                     ConstantRef sizeOfTargetType = SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType());
                     stmtIt.add(new StatementAssignment(lValue, tmpVar.getRef(), Operators.DIVIDE, sizeOfTargetType, assignment.isInitialAssignment(), assignment.getSource(), Comment.NO_COMMENTS));
                  }
               }

               if(isPointerPlusConst) {
                  // Binary operation on a non-byte pointer - sizeof()-handling is probably needed!
                  // Adding to a pointer - multiply by sizeof()
                  getLog().append("Fixing pointer addition " + assignment.toString(getProgram(), false));
                  Variable tmpVar = getScope().getScope(block.getScope()).addVariableIntermediate();
                  tmpVar.setType(SymbolTypeInference.inferType(getScope(), assignment.getrValue2()));
                  stmtIt.remove();
                  ConstantRef sizeOfTargetType = SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType());
                  stmtIt.add(new StatementAssignment((LValue) tmpVar.getRef(), assignment.getrValue2(), Operators.MULTIPLY, sizeOfTargetType, true, assignment.getSource(), Comment.NO_COMMENTS));
                  stmtIt.add(assignment);
                  assignment.setrValue2(tmpVar.getRef());
               }
            }
         }
      }
   }

   /**
    * Examine if the unary operation in the assignment is a pointer operation - and fix it to reflect sizeof()
    *
    * @param assignment The assignment statement
    */
   public void fixPointerUnary(StatementAssignment assignment) {
      // Found assignment with unary operator
      SymbolTypePointer pointerType = getPointerType(assignment.getrValue2());
      if(pointerType != null) {
         if(SymbolType.VOID.equals(pointerType.getElementType())) {
            if(Operators.INCREMENT.equals(assignment.getOperator()) || Operators.DECREMENT.equals(assignment.getOperator())) {
               throw new CompileError("Void pointer math not allowed. ", assignment);
            }
         }
         if(pointerType.getElementType().getSizeBytes() > 1) {
            // Unary operation on non-byte pointer type - sizeof()-handling is needed!
            if(Operators.INCREMENT.equals(assignment.getOperator())) {
               // Pointer increment - add sizeof(type) instead
               getLog().append("Fixing pointer increment " + assignment.toString(getProgram(), false));
               assignment.setrValue1(assignment.getrValue2());
               assignment.setOperator(Operators.PLUS);
               assignment.setrValue2(SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
            } else if(Operators.DECREMENT.equals(assignment.getOperator())) {
               // Pointer Decrement - add sizeof(type) instead
               getLog().append("Fixing pointer decrement " + assignment.toString(getProgram(), false));
               assignment.setrValue1(assignment.getrValue2());
               assignment.setOperator(Operators.MINUS);
               assignment.setrValue2(SizeOfConstants.getSizeOfConstantVar(getProgram().getScope(), pointerType.getElementType()));
            }
         }
      }
   }

   /**
    * Examine the passed value to determine if it is a pointer.
    * If it is a pointer return the type of the pointer
    * @param pointer The potential pointer to examine
    * @return The type of the pointer - if the value was a pointer. null if the value is not a pointer.
    */
   private SymbolTypePointer getPointerType(RValue pointer) {
      if(pointer instanceof SymbolVariableRef) {
         SymbolVariableRef varRef = (SymbolVariableRef) pointer;
         Variable variable = getScope().getVar(varRef);
         SymbolType type = variable.getType();
         if(type instanceof SymbolTypePointer) {
            return (SymbolTypePointer) type;
         }
      } else if(pointer instanceof StructMemberRef) {
         StructMemberRef structMemberRef = (StructMemberRef) pointer;
         RValue struct = structMemberRef.getStruct();
         SymbolType structType = SymbolTypeInference.inferType(getScope(), struct);
         if(structType instanceof SymbolTypeStruct) {
            StructDefinition structDefinition = ((SymbolTypeStruct) structType).getStructDefinition(getScope());
            Variable memberVariable = structDefinition.getMember(structMemberRef.getMemberName());
            SymbolType memberType = memberVariable.getType();
            if(memberType instanceof SymbolTypePointer) {
               return (SymbolTypePointer) memberType;
            }
         }
      }
      return null;
   }

}
