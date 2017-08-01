package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.Collection;

/**
 * Information about register uplift at the program level
 */
public class RegisterUpliftProgram {

   private Collection<RegisterUpliftScope> registerUpliftScopes;

   public RegisterUpliftProgram() {
      this.registerUpliftScopes = new ArrayList<>();
   }

   public Collection<RegisterUpliftScope> getRegisterUpliftScopes() {
      return registerUpliftScopes;
   }

   public RegisterUpliftScope addRegisterUpliftScope(LabelRef scopeRef) {
      RegisterUpliftScope registerUpliftScope = new RegisterUpliftScope(scopeRef);
      registerUpliftScopes.add(registerUpliftScope);
      return registerUpliftScope;
   }

   public String toString(VariableRegisterWeights variableRegisterWeights) {
      StringBuilder out = new StringBuilder();
      for (RegisterUpliftScope upliftScope : registerUpliftScopes) {
         out.append(upliftScope.toString(variableRegisterWeights)).append("\n");
      }
      return out.toString();
   }

   @Override
   public String toString() {
      return toString(null);
   }
}
