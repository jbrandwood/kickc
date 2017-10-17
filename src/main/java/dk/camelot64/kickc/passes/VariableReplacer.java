package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * A replacer capable to alias all usages of a variable (or constant var) with a suitable replacement
 */
public class VariableReplacer {

   private Map<? extends SymbolRef, ? extends RValue> aliases;

   public VariableReplacer(Map<? extends SymbolRef, ? extends RValue> aliases) {
      this.aliases = aliases;
   }

   public void getReplacement(ControlFlowGraph graph) {
      ControlFlowGraphBaseVisitor<Void> visitor = new GraphReplacer();
      visitor.visitGraph(graph);
   }

   /**
    * Get the alias to use for an RValue.
    * Also looks inside any constant values for replacements.
    * If a replacement is found the replacement is performed and the new value is returned. If no replacement is found null is returned.
    *
    * @param rValue  The RValue to find an alias for
    * @return The alias to use. Null if no alias exists.
    */
   public RValue getReplacement(RValue rValue) {
      if(rValue instanceof SymbolRef) {
         RValue alias = aliases.get(rValue);
         if(alias!=null) {
            RValue replacement = getReplacement(alias);
            if(replacement!=null) {
               return replacement;
            } else {
               return alias;
            }
         }
      } else if (rValue instanceof ConstantUnary) {
         ConstantUnary constantUnary = (ConstantUnary) rValue;
         ConstantValue alias = (ConstantValue) getReplacement(constantUnary.getOperand());
         if (alias != null) {
            return new ConstantUnary(constantUnary.getOperator(), alias);
         }
      } else if (rValue instanceof ConstantBinary) {
         ConstantBinary constantBinary = (ConstantBinary) rValue;
         ConstantValue aliasLeft = (ConstantValue) getReplacement(constantBinary.getLeft());
         ConstantValue aliasRight = (ConstantValue) getReplacement(constantBinary.getRight());
         if (aliasLeft != null || aliasRight != null) {
            if (aliasLeft == null) {
               aliasLeft = constantBinary.getLeft();
            }
            if (aliasRight == null) {
               aliasRight = constantBinary.getRight();
            }
            return new ConstantBinary(aliasLeft, constantBinary.getOperator(), aliasRight);
         }
      }

      // No replacement found - return null
      return null;

   }

   /**
    * Visitor capable of handling replacements in an entire flow graph.
    */
   private class GraphReplacer extends ControlFlowGraphBaseVisitor<Void> {

      @Override
      public Void visitAssignment(StatementAssignment assignment) {
         LValue lValue = assignment.getlValue();
         if (getReplacement(lValue) != null) {
            RValue alias = getReplacement(lValue);
            if (alias instanceof LValue) {
               assignment.setlValue((LValue) alias);
            } else {
               throw new RuntimeException("Error replacing LValue variable " + lValue + " with " + alias);
            }
         }
         if (getReplacement(assignment.getrValue1()) != null) {
            assignment.setrValue1(getReplacement(assignment.getrValue1()));
         }
         if (getReplacement(assignment.getrValue2()) != null) {
            assignment.setrValue2(getReplacement(assignment.getrValue2()));
         }
         // Handle pointer dereference in LValue
         if (lValue instanceof PointerDereferenceSimple) {
            PointerDereferenceSimple deref = (PointerDereferenceSimple) lValue;
            RValue pointer = deref.getPointer();
            if (getReplacement(pointer) != null) {
               deref.setPointer(getReplacement(pointer));
            }
         }
         if (lValue instanceof PointerDereferenceIndexed) {
            PointerDereferenceIndexed deref = (PointerDereferenceIndexed) lValue;
            RValue pointer = deref.getPointer();
            if (getReplacement(pointer) != null) {
               deref.setPointer(getReplacement(pointer));
            }
            RValue index = deref.getIndex();
            if (getReplacement(index) != null) {
               deref.setIndex(getReplacement(index));
            }
         }
         return null;
      }

      @Override
      public Void visitConditionalJump(StatementConditionalJump conditionalJump) {
         if (getReplacement(conditionalJump.getrValue1()) != null) {
            conditionalJump.setrValue1(getReplacement(conditionalJump.getrValue1()));
         }
         if (getReplacement(conditionalJump.getrValue2()) != null) {
            conditionalJump.setrValue2(getReplacement(conditionalJump.getrValue2()));
         }
         return null;
      }

      @Override
      public Void visitReturn(StatementReturn aReturn) {
         if (getReplacement(aReturn.getValue()) != null) {
            aReturn.setValue(getReplacement(aReturn.getValue()));
         }
         return null;
      }

      @Override
      public Void visitCall(StatementCall call) {
         if (call.getParameters() != null) {
            List<RValue> newParams = new ArrayList<>();
            for (RValue parameter : call.getParameters()) {
               RValue newParam = parameter;
               if (getReplacement(parameter) != null) {
                  newParam = getReplacement(parameter);
               }
               newParams.add(newParam);
            }
            call.setParameters(newParams);
         }
         return null;
      }

      @Override
      public Void visitPhiBlock(StatementPhiBlock phi) {
         for (StatementPhiBlock.PhiVariable phiVariable : phi.getPhiVariables()) {
            if (getReplacement(phiVariable.getVariable()) != null) {
               RValue alias = getReplacement(phiVariable.getVariable());
               if (alias instanceof LValue) {
                  phiVariable.setVariable((VariableRef) alias);
               }
            }
            List<StatementPhiBlock.PhiRValue> phirValues = phiVariable.getValues();
            Iterator<StatementPhiBlock.PhiRValue> it = phirValues.iterator();
            while (it.hasNext()) {
               StatementPhiBlock.PhiRValue phirValue = it.next();
               if (getReplacement(phirValue.getrValue()) != null) {
                  RValue alias = getReplacement(phirValue.getrValue());
                  if (LValue.VOID.equals(alias)) {
                     it.remove();
                  } else {
                     phirValue.setrValue(alias);
                  }
               }
            }
         }
         return null;
      }
   }

}
