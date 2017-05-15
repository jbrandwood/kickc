package dk.camelot64.kickc.icl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**  Code Generation Fragment that can handle loading of fragment file and binding of values / registers */
public class AsmFragment {

   /** The symbol table. */
   private SymbolTable symbols;

   /** Binding of named values in the fragment to values (constants, variables, ...) .*/
   private Map<String, Value> bindings;

   /** The string signature/name of the asm fragment. */
   private String signature;

   public AsmFragment(StatementConditionalJump conditionalJump, SymbolTable symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      StringBuilder signature = new StringBuilder();
      signature.append(bind(conditionalJump.getCondition()));
      signature.append("?");
      signature.append(bind(conditionalJump.getDestination()));
      setSignature(signature.toString());
   }

   public AsmFragment(StatementAssignment assignment, SymbolTable symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(assignment.getLValue(), assignment.getRValue1(), assignment.getOperator(), assignment.getRValue2()));
   }

   public AsmFragment(LValue lValue, RValue rValue, SymbolTable symbols) {
      this.bindings = new HashMap<>();
      this.symbols = symbols;
      setSignature(assignmentSignature(lValue, null, null, rValue));
   }

   private String assignmentSignature(LValue lValue, RValue rValue1, Operator operator, RValue rValue2) {
      StringBuilder signature = new StringBuilder();
      signature.append(bind(lValue));
      signature.append("=");
      if (rValue1 != null) {
         signature.append(bind(rValue1));
      }
      if (operator != null) {
         signature.append(operator.getOperator());
      }
      signature.append(bind(rValue2));
      return signature.toString();
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

   /**
    * Get the value to replace a bound name with from the fragment signature
    *
    * @param name         The name of the bound value in the fragment
    * @return The bound value to use in the generated ASM code
    */
   public String getValue(String name) {
      Value boundValue = getBinding(name);
      String bound;
      if (boundValue instanceof Variable) {
         RegisterAllocation.Register register = symbols.getRegister((Variable) boundValue);
         if (register instanceof RegisterAllocation.RegisterZpByte) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpByte) register).getZp());
         } else if (register instanceof RegisterAllocation.RegisterZpBool) {
            bound = Integer.toString(((RegisterAllocation.RegisterZpBool) register).getZp());
         } else {
            throw new RuntimeException("Register Type not implemented " + register);
         }
      } else if (boundValue instanceof ConstantInteger) {
         ConstantInteger boundInt = (ConstantInteger) boundValue;
         if (boundInt.getType().equals(SymbolType.BYTE)) {
            bound = Integer.toString(boundInt.getNumber());
         } else {
            throw new RuntimeException("Bound Value Type not implemented " + boundValue);
         }
      } else if (boundValue instanceof Label) {
         bound = ((Label) boundValue).getName().replace('@', 'B');
      } else {
         throw new RuntimeException("Bound Value Type not implemented " + boundValue);
      }
      return bound;
   }

   /**
    * Generate assembler code for the assembler fragment.
    *
    * @param asm               The assembler sequence to generate into.
    */
   public void generateAsm(AsmSequence asm) {
      String signature = this.getSignature();
      ClassLoader classLoader = this.getClass().getClassLoader();
      URL fragmentResource = classLoader.getResource("dk/camelot64/kickc/icl/asm/" + signature + ".asm");
      if (fragmentResource == null) {
         System.out.println("Fragment not found " + fragmentResource);
         asm.addAsm("  // Fragment not found: " + signature);
         return;
      }
      Pattern bindPattern = Pattern.compile(".*\\{([^}]*)}.*");
      try {
         InputStream fragmentStream = fragmentResource.openStream();
         BufferedReader fragmentReader = new BufferedReader(new InputStreamReader(fragmentStream));
         String line;
         while ((line = fragmentReader.readLine()) != null) {
            Matcher matcher = bindPattern.matcher(line);
            if (matcher.matches()) {
               String name = matcher.group(1);
               String bound = this.getValue(name);
               line = line.replaceFirst("\\{[^}]*}", bound);
            }
            asm.addAsm("  " + line);
         }
         fragmentReader.close();
         fragmentStream.close();
      } catch (IOException e) {
         throw new RuntimeException("Error reading code fragment " + fragmentResource);
      }

   }



}
