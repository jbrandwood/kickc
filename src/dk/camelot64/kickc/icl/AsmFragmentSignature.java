package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/**  Signature and Binding for a Code Generation Fragment */
public abstract class AsmFragmentSignature {

   /** The symbol table. */
   private SymbolTable symbols;

   /** Binding of named values in the fragment to values (constants, variables, ...) .*/
   private Map<String, Value> bindings;

   /** The string signature/name of the asm fragment. */
   private String signature;

   public AsmFragmentSignature(SymbolTable symbols) {
      this.symbols = symbols;
      this.bindings = new HashMap<>();
   }

   public Value getBinding(String name) {
      return bindings.get(name);
   }

   public String getSignature() {
      return signature;
   }

   public void setSignature(String signature) {
      this.signature = signature;
   }

   /** Zero page byte register name indexing. */
   private int nextZpByteIdx = 1;

   /** Zero page bool register name indexing. */
   private int nextZpBoolIdx = 1;

   /** Constant byte indexing. */
   private int nextConstByteIdx = 1;

   /** Label indexing. */
   private int nextLabelIdx = 1;

   /**
    * Add bindings of a value.
    * @param value The value to bind.
    * @return The bound name of the value. If the value has already been bound the existing bound name is returned.
    */
   public String bind(Value value) {
      // Find value if it is already bound
      for (String name : bindings.keySet()) {
         if (value.equals(bindings.get(name))) {
            return name;
         }
      }
      if (value instanceof Variable) {
         RegisterAllocation.Register register = symbols.getRegister((Variable) value);
         if (RegisterAllocation.RegisterType.ZP_BYTE.equals(register.getType())) {
            String name = "zpby" + nextZpByteIdx++;
            bindings.put(name, value);
            return name;
         } else if (RegisterAllocation.RegisterType.ZP_BOOL.equals(register.getType())) {
            String name = "zpbo" + nextZpBoolIdx++;
            bindings.put(name, value);
            return name;
         } else {
            throw new RuntimeException("Binding of register type not supported " + register.getType());
         }
      } else if (value instanceof ConstantInteger) {
         ConstantInteger intValue = (ConstantInteger) value;
         if(intValue.getType().equals(SymbolType.BYTE)) {
            String name = "coby"+ nextConstByteIdx++;
            bindings.put(name, value);
            return name;
         } else {
            throw new RuntimeException("Binding of word integers not supported " + intValue);
         }
      } else if (value instanceof Label) {
            String name = "la"+ nextLabelIdx++;
            bindings.put(name, value);
            return name;
      } else {
         throw new RuntimeException("Binding of value type not supported " + value);
      }
   }

}
