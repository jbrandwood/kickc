package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.values.CastValue;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.*;

/**
 * Compiler Pass inlineng cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
 */
public class Pass2NopCastInlining extends Pass2SsaOptimization {

   public Pass2NopCastInlining(Program program) {
      super(program);
   }

   /** We can either inline intermediate vars or expressions - not both at once */
   enum Mode {
      VARS, EXPR
   }

   /**
    * Inline cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
    */
   @Override
   public boolean step() {
      LinkedHashMap<SymbolRef, RValue> replace1 = new LinkedHashMap<>();
      LinkedHashMap<SymbolRef, RValue> replace2 = new LinkedHashMap<>();
      Set<SymbolRef> delete = new HashSet<>();

      Mode mode = null;

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement stmt = stmtIt.next();
            if(stmt instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) stmt;
               // TODO: Handle constant values?
               if(assignment.getOperator() == null && assignment.getrValue2() instanceof CastValue) {
                  CastValue castValue = (CastValue) assignment.getrValue2();
                  SymbolType subValType = SymbolTypeInference.inferType(getScope(), castValue.getValue());
                  boolean isNopCast = false;
                  if(SymbolType.BYTE.equals(castValue.getToType()) && SymbolType.SBYTE.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.SBYTE.equals(castValue.getToType()) && SymbolType.BYTE.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.WORD.equals(castValue.getToType()) && SymbolType.SWORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.SWORD.equals(castValue.getToType()) && SymbolType.WORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(castValue.getToType() instanceof SymbolTypePointer && SymbolType.WORD.equals(subValType)) {
                     isNopCast = true;
                  } else if(SymbolType.WORD.equals(castValue.getToType()) && subValType instanceof SymbolTypePointer) {
                     isNopCast = true;
                  } else if(castValue.getToType() instanceof SymbolTypePointer && subValType instanceof SymbolTypePointer) {
                     isNopCast = true;
                  }
                  if(isNopCast && assignment.getlValue() instanceof VariableRef) {

                     boolean isIntermediateVar = false;
                     if(castValue.getValue() instanceof VariableRef && ((VariableRef) castValue.getValue()).isIntermediate()) {
                        isIntermediateVar = true;
                     }
                     if(isIntermediateVar) {
                        if(mode == null || mode == Mode.VARS) {
                           mode = Mode.VARS;
                           Collection<Integer> varUseStatements = getProgram().getVariableReferenceInfos().getVarUseStatements((VariableRef) castValue.getValue());
                           if(varUseStatements.size() == 1 && assignment.getIndex().equals(varUseStatements.iterator().next())) {
                              // Cast variable is only ever used in the cast
                              getLog().append("Inlining Noop Cast " + assignment.toString(getProgram(), false) + " keeping " + assignment.getlValue());
                              // 1. Inline the cast
                              replace1.put((VariableRef) assignment.getlValue(), castValue);
                              // 2. Rename the cast variable (since we like the assignment variable better)
                              replace2.put((SymbolRef) castValue.getValue(), assignment.getlValue());
                              // 3. Delete the cast variable
                              delete.add((SymbolRef) castValue.getValue());
                              // Change the type of the assignment variable
                              Variable assignmentVar = getScope().getVariable((VariableRef) assignment.getlValue());
                              Variable castVar = getScope().getVariable((VariableRef) castValue.getValue());
                              assignmentVar.setType(castVar.getType());
                              // Remove the assignment
                              stmtIt.remove();
                           }
                        }
                     } else if(mode == null || mode == Mode.EXPR) {
                        boolean modifyExpr = false;
                        if(castValue.getValue() instanceof VariableRef) {
                           VariableRef castVarRef = (VariableRef) castValue.getValue();
                           VariableRef lValueRef = (VariableRef) assignment.getlValue();
                           if(castVarRef.getScopeNames().equals(lValueRef.getScopeNames())) {
                              // Same scope - optimize away
                              modifyExpr = true;
                           }
                        } else {
                           modifyExpr = true;
                        }

                        if(modifyExpr) {
                           mode = Mode.EXPR;
                           getLog().append("Inlining Noop Cast " + assignment.toString(getProgram(), false) + " keeping " + castValue.getValue());
                           // 1. Inline the cast
                           replace1.put((VariableRef) assignment.getlValue(), assignment.getrValue2());
                           // 2. Delete the assignment variable
                           delete.add((VariableRef) assignment.getlValue());
                           // Remove the assignment
                           stmtIt.remove();
                        }
                     }
                  }
               }
            }
         }
      }

      if(replace1.size() > 0) {
         // 1. Perform first replace
         replaceVariables(replace1);
         // 2. Perform second replace
         replaceVariables(replace2);
         // 3. Delete unused symbols
         deleteSymbols(getScope(), delete);
      }

      return (replace1.size() > 0);
   }


}
