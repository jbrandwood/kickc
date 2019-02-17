package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.ValueList;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.VariableIntermediate;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypeInteger;

import java.util.ListIterator;

/**
 * Identifies word constructors <code>{ b1, b2 }</code> and replaces
 * them with a binary operator <code>word w = b1 w= b2 ;</code>
 */
public class Pass2FixInlineConstructors extends Pass2SsaOptimization {

   public Pass2FixInlineConstructors(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      WordConstructor wordConstructor = new WordConstructor();
      ProgramValueIterator.execute(getGraph(), wordConstructor);
      DWordConstructor dwordConstructor = new DWordConstructor();
      ProgramValueIterator.execute(getGraph(), dwordConstructor);
      return wordConstructor.isOptimized() || dwordConstructor.isOptimized();
   }

   /** Replaces { b1, b2 } with a w= operator */
   private class WordConstructor extends InlineConstructor {

      public WordConstructor() {
         super(SymbolType.WORD, Operators.WORD);
      }

      @Override
      protected boolean isSubType(SymbolType elmType) {
         return SymbolType.isByte(elmType);
      }
   }

   /** Replaces { w1, w2 } with a dw= operator */
   private class DWordConstructor extends InlineConstructor {

      public DWordConstructor() {
         super(SymbolType.DWORD, Operators.DWORD);
      }

      @Override
      protected boolean isSubType(SymbolType elmType) {
         return SymbolType.isWord(elmType);
      }
   }


   private abstract class InlineConstructor implements ProgramValueHandler {
      private SymbolTypeInteger constructType;
      private Operator constructOperator;
      private boolean optimized;

      public InlineConstructor(SymbolTypeInteger constructType, Operator constructOperator) {
         this.constructType = constructType;
         this.constructOperator = constructOperator;
      }

      protected abstract boolean isSubType(SymbolType elmType);

      public boolean isOptimized() {
         return optimized;
      }

      @Override
      public void execute(ProgramValue programValue, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
         RValue rValue = programValue.get();
         if(rValue instanceof ValueList) {
            ValueList list = (ValueList) rValue;
            if(list.getList().size() == 2) {
               // We have a simple assignment of a length 2 value list to a variable
               SymbolType elmType1 = SymbolTypeInference.inferType(Pass2FixInlineConstructors.this.getScope(), list.getList().get(0));
               SymbolType elmType2 = SymbolTypeInference.inferType(Pass2FixInlineConstructors.this.getScope(), list.getList().get(1));
               if(isSubType(elmType1) && isSubType(elmType2)) {
                  // We have a 2-element list { byte, byte }

                  // Check if we are assigning into a declared byte array
                  if(currentStmt instanceof StatementAssignment) {
                     StatementAssignment assignment = (StatementAssignment) currentStmt;
                     if(assignment.getrValue1() == null && assignment.getOperator() == null && assignment.getrValue2().equals(rValue)) {
                        SymbolType lType = SymbolTypeInference.inferType(Pass2FixInlineConstructors.this.getScope(), assignment.getlValue());
                        if(lType instanceof SymbolTypeArray && isSubType(((SymbolTypeArray) lType).getElementType())) {
                           // We are assigning into a declared byte array - do not convert!
                           return;
                        }
                     }
                  }

                  // Convert list to a word constructor in a new tmp variable
                  Scope currentScope = Pass2FixInlineConstructors.this.getScope().getScope(currentBlock.getScope());
                  VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
                  tmpVar.setTypeInferred(constructType);
                  // Move backward - to insert before the current statement
                  stmtIt.previous();
                  // Add assignment of the new tmpVar
                  StatementAssignment assignment = new StatementAssignment(tmpVar.getRef(), list.getList().get(0), constructOperator, list.getList().get(1), currentStmt.getSource(), Comment.NO_COMMENTS);
                  stmtIt.add(assignment);
                  // Move back before the current statement
                  stmtIt.next();
                  // Replace current value with the reference
                  programValue.set(tmpVar.getRef());
                  Pass2FixInlineConstructors.this.getLog().append("Fixing inline constructor with " + assignment.toString());
                  optimized = true;
               }
            }
         }
      }
   }


}
