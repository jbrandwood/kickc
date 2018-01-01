package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.ListIterator;

/**
 * Identifies word constructors <code>{ b1, b2 }</code> and replaces
 * them with a binary operator <code>word w = b1 w= b2 ;</code>
 */
public class Pass2FixWordConstructors extends Pass2SsaOptimization {

   public Pass2FixWordConstructors(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      final boolean[] optimized = {false};

      ValueReplacer.executeAll(getGraph(), new ValueReplacer.Replacer() {
         @Override
         public void execute(ValueReplacer.ReplaceableValue replaceable, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) {
            RValue rValue = replaceable.get();
            if(rValue instanceof ValueList) {
               ValueList list = (ValueList) rValue;
               if(list.getList().size() == 2) {
                  // We have a simple assignment of a length 2 value list to a variable
                  SymbolType elmType1 = SymbolTypeInference.inferType(Pass2FixWordConstructors.this.getScope(), list.getList().get(0));
                  SymbolType elmType2 = SymbolTypeInference.inferType(Pass2FixWordConstructors.this.getScope(), list.getList().get(1));
                  if(SymbolType.isByte(elmType1) && SymbolType.isByte(elmType2)) {
                     // We have a 2-element list { byte, byte }

                     // Check if we are assigning into a declared byte array
                     if(currentStmt instanceof StatementAssignment) {
                        StatementAssignment assignment = (StatementAssignment) currentStmt;
                        if(assignment.getrValue1() == null && assignment.getOperator() == null && assignment.getrValue2().equals(rValue)) {
                           SymbolType lType = SymbolTypeInference.inferType(Pass2FixWordConstructors.this.getScope(), assignment.getlValue());
                           if(lType instanceof SymbolTypeArray && SymbolType.isByte(((SymbolTypeArray) lType).getElementType())) {
                              // We are assigning into a declared byte array - do not convert!
                              return;
                           }
                        }
                     }

                     // Convert list to a word constructor in a new tmp variable
                     Scope currentScope = getScope().getScope(currentBlock.getScope());
                     VariableIntermediate tmpVar = currentScope.addVariableIntermediate();
                     tmpVar.setTypeInferred(SymbolType.WORD);
                     // Move backward - to insert before the current statement
                     stmtIt.previous();
                     // Add assignment of the new tmpVar
                     StatementAssignment assignment = new StatementAssignment(tmpVar.getRef(), list.getList().get(0), Operator.WORD, list.getList().get(1));
                     stmtIt.add(assignment);
                     // Move back before the current statement
                     stmtIt.next();
                     // Replace current value with the reference
                     replaceable.set(tmpVar.getRef());
                     Pass2FixWordConstructors.this.getLog().append("Fixing word constructor with " + assignment.toString());
                     optimized[0] = true;
                  }
               }
            }
         }
      });
      return optimized[0];
   }

}
