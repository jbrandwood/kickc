package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.*;

import java.util.*;

/**
 * A replacer capable to alias all usages of a variable (or constant var) with a suitable replacement
 */
public class VariableReplacer {

   private Map<? extends SymbolRef, ? extends RValue> aliases;

   public VariableReplacer(Map<? extends SymbolRef, ? extends RValue> aliases) {
      this.aliases = aliases;
   }

   public void execute(ControlFlowGraph graph) {
      //new GraphReplacer().visitGraph(graph);
      for (ControlFlowBlock block : graph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               execute(new ReplacableLValue((StatementLValue) statement));
               execute(new ReplacableRValue1((StatementAssignment) statement));
               execute(new ReplacableRValue2((StatementAssignment) statement));
            } else if (statement instanceof StatementCall) {
               execute(new ReplacableLValue((StatementLValue) statement));
               StatementCall call = (StatementCall) statement;
               if(call.getParameters()!=null) {
                  int size = call.getParameters().size();
                  for (int i = 0; i < size; i++) {
                     execute(new ReplacableCallParameter(call, i));
                  }
               }
            } else if (statement instanceof StatementConditionalJump) {
               execute(new ReplacableCondRValue1((StatementConditionalJump) statement));
               execute(new ReplacableCondRValue2((StatementConditionalJump) statement));
            } else if (statement instanceof StatementReturn) {
               execute(new ReplacableReturn((StatementReturn) statement));
            } else if (statement instanceof StatementPhiBlock) {
               for (StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  execute(new ReplacablePhiVariable(phiVariable));
                  int size = phiVariable.getValues().size();
                  for (int i = 0; i < size; i++) {
                     execute(new ReplacablePhiValue(phiVariable, i));
                  }
               }
            }
         }
      }
   }

   /**
    * Execute replacements inside a replacable value - and its sub-values.
    * @param replacable The replacable value
    */
   void execute(ReplacableValue replacable) {
      if(replacable.get()!=null) {
         RValue replacement = getReplacement(replacable.get());
         if(replacement!=null) {
            replacable.set(replacement);
         }
         for (ReplacableValue subReplacable : replacable.getSubValues()) {
            execute(subReplacable);
         }
      }
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
      if (rValue instanceof SymbolRef) {
         RValue alias = aliases.get(rValue);
         if (alias != null) {
            if (alias.equals(rValue)) {
               return alias;
            }
            RValue replacement = getReplacement(alias);
            if (replacement != null) {
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
      } else if(rValue instanceof ConstantArray) {
         ConstantArray constantArray = (ConstantArray) rValue;
         ArrayList<ConstantValue> replacementList = new ArrayList<>();
         boolean any = false;
         for (ConstantValue elemValue : constantArray.getElements()) {
            RValue elemReplacement = getReplacement(elemValue);
            if(elemReplacement!=null) {
               replacementList.add((ConstantValue) elemReplacement);
               any = true;
            } else{
               replacementList.add(elemValue);
            }
         }
         if(any) {
            return new ConstantArray(replacementList, constantArray.getElementType());
         }
      }

      // No replacement found - return null
      return null;

   }

   /**
    * Interface representing an RValue that can be replaced.
    * The value may have sub-values that can also be replaced.
    */
   public static abstract class ReplacableValue {

      public abstract RValue get();

      public abstract void set(RValue value);

      public Collection<ReplacableValue> getSubValues() {
         RValue value = get();
         ArrayList<ReplacableValue> subValues = new ArrayList<>();
         if (value instanceof PointerDereferenceIndexed) {
            subValues.add(new ReplacablePointer((PointerDereference) value));
            subValues.add(new ReplacablePointerIndex((PointerDereferenceIndexed) value));
         } else if (value instanceof PointerDereferenceSimple) {
            subValues.add(new ReplacablePointer((PointerDereference) value));
         } else if (value instanceof ValueList) {
            ValueList valueList = (ValueList) value;
            int size = valueList.getList().size();
            for (int i = 0; i < size; i++) {
               subValues.add(new ReplacableListElement(valueList, i));
            }
         }
         return subValues;
      }

   }

   /** Replacable LValue as part of an assignment statement (or a call). */
   public static class ReplacableLValue extends ReplacableValue {
      private final StatementLValue statement;

      public ReplacableLValue(StatementLValue statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getlValue();
      }

      @Override
      public void set(RValue value) {
         statement.setlValue((LValue) value);
      }

   }

   /** Replacable pointer inside a pointer dererence value. */
   public static class ReplacablePointer extends ReplacableValue {
      private final PointerDereference pointer;

      ReplacablePointer(PointerDereference pointer) {
         this.pointer = pointer;
      }

      @Override
      public RValue get() {
         return pointer.getPointer();
      }

      @Override
      public void set(RValue val) {
         pointer.setPointer(val);
      }

   }

   public static class ReplacableListElement extends ReplacableValue {
      private ValueList list;
      private int idx;

      public ReplacableListElement(ValueList list, int idx) {
         this.list = list;
         this.idx = idx;
      }

      @Override
      public RValue get() {
         return list.getList().get(idx);
      }

      @Override
      public void set(RValue value) {
         list.getList().set(idx, value);
      }

   }

   /** Replacable pointer index inside a indexed pointer dererence value. */
   public static class ReplacablePointerIndex extends ReplacableValue {
      private final PointerDereferenceIndexed pointer;

      ReplacablePointerIndex(PointerDereferenceIndexed pointer) {
         this.pointer = pointer;
      }

      @Override
      public RValue get() {
         return pointer.getIndex();
      }

      @Override
      public void set(RValue val) {
         pointer.setIndex(val);
      }

   }

   public static class ReplacableRValue1 extends ReplacableValue {
      private final StatementAssignment statement;

      public ReplacableRValue1(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue1();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue1(value);
      }
   }

   public static class ReplacableRValue2 extends ReplacableValue {
      private final StatementAssignment statement;

      public ReplacableRValue2(StatementAssignment statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue2();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue2(value);
      }
   }

   public static class ReplacableCallParameter extends ReplacableValue {
      private final StatementCall call;
      private final int i;

      public ReplacableCallParameter(StatementCall call, int i) {
         this.call = call;
         this.i = i;
      }

      @Override
      public RValue get() {
         return call.getParameters().get(i);
      }

      @Override
      public void set(RValue value) {
         call.getParameters().set(i, value);
      }
   }

   public static class ReplacableCondRValue1 extends ReplacableValue {
      private final StatementConditionalJump statement;

      public ReplacableCondRValue1(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue1();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue1(value);
      }
   }

   public static class ReplacableCondRValue2 extends ReplacableValue {
      private final StatementConditionalJump statement;

      public ReplacableCondRValue2(StatementConditionalJump statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getrValue2();
      }

      @Override
      public void set(RValue value) {
         statement.setrValue2(value);
      }
   }

   public static class ReplacableReturn extends ReplacableValue {
      private final StatementReturn statement;

      public ReplacableReturn(StatementReturn statement) {
         this.statement = statement;
      }

      @Override
      public RValue get() {
         return statement.getValue();
      }

      @Override
      public void set(RValue value) {
         statement.setValue(value);
      }
   }

   public static class ReplacablePhiValue extends ReplacableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;
      private final int i;

      public ReplacablePhiValue(StatementPhiBlock.PhiVariable phiVariable, int i) {
         this.phiVariable = phiVariable;
         this.i = i;
      }

      @Override
      public RValue get() {
         return phiVariable.getValues().get(i).getrValue();
      }

      @Override
      public void set(RValue value) {
         phiVariable.getValues().get(i).setrValue(value);
      }
   }

   /** Replacable LValue as part of an assignment statement (or a call). */
   public static class ReplacablePhiVariable extends ReplacableValue {
      private final StatementPhiBlock.PhiVariable phiVariable;

      public ReplacablePhiVariable(StatementPhiBlock.PhiVariable phiVariable) {
         this.phiVariable = phiVariable;
      }

      @Override
      public RValue get() {
         return phiVariable.getVariable();
      }

      @Override
      public void set(RValue value) {
         phiVariable.setVariable((VariableRef) value);
      }

   }

}
