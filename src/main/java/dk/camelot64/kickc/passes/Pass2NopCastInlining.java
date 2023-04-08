package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
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
 * Compiler Pass inlining cast assignments that has no effect (byte to/from signed byte, word to/from signed word)
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

      for(var block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement stmt = stmtIt.next();
            if(stmt instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) stmt;
               // TODO: Handle constant values?
               if(assignment.getOperator() == null && assignment.getrValue2() instanceof CastValue) {
                  CastValue castValue = (CastValue) assignment.getrValue2();
                  SymbolType subValType = SymbolTypeInference.inferType(getProgramScope(), castValue.getValue());
                  final SymbolType castToType = castValue.getToType();
                  boolean isNopCast = isNopCast(castToType, subValType);
                  if(isNopCast && assignment.getlValue() instanceof VariableRef) {

                     final Variable assignmentVar = getProgramScope().getVariable((VariableRef) assignment.getlValue());
                     if(assignmentVar.isKindLoadStore())
                        continue;

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
                              Variable castVar = getProgramScope().getVariable((VariableRef) castValue.getValue());
                              // Copy type qualifiers from the variable being assigned
                              SymbolType qualifiedType = castVar.getType().getQualified(assignmentVar.getType().isVolatile(), assignmentVar.getType().isNomodify());
                              assignmentVar.setType(qualifiedType);
                              // Remove the assignment
                              stmtIt.remove();
                           }
                        }
                     } else if(mode == null || mode == Mode.EXPR) {
                        boolean modifyExpr = false;
                        RValue castVal = castValue.getValue();
                        while(castVal instanceof CastValue) {
                           castVal = ((CastValue) castVal).getValue();
                        }
                        if(castVal instanceof VariableRef) {
                           VariableRef castVarRef = (VariableRef) castVal;
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
         deleteSymbols(getProgramScope(), delete);
      }

      return (replace1.size() > 0);
   }

   public static boolean isNopCast(SymbolType castToType, SymbolType subValType) {
      boolean isNopCast = false;
      if(SymbolType.BYTE.equals(castToType) && SymbolType.SBYTE.equals(subValType)) {
         isNopCast = true;
      } else if(SymbolType.SBYTE.equals(castToType) && SymbolType.BYTE.equals(subValType)) {
         isNopCast = true;
      } else if(SymbolType.WORD.equals(castToType) && SymbolType.SWORD.equals(subValType)) {
         isNopCast = true;
      } else if(SymbolType.SWORD.equals(castToType) && SymbolType.WORD.equals(subValType)) {
         isNopCast = true;
      } else if(castToType instanceof SymbolTypePointer && SymbolType.WORD.equals(subValType)) {
         isNopCast = true;
      } else if(SymbolType.WORD.equals(castToType) && subValType instanceof SymbolTypePointer) {
         isNopCast = true;
      } else if(castToType instanceof SymbolTypePointer && subValType instanceof SymbolTypePointer) {
         isNopCast = true;
      }
      return isNopCast;
   }


}
