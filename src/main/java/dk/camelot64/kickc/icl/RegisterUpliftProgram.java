package dk.camelot64.kickc.icl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Information about register uplift at the program level
 */
public class RegisterUpliftProgram {

   private List<RegisterUpliftScope> registerUpliftScopes;

   public RegisterUpliftProgram() {
      this.registerUpliftScopes = new ArrayList<>();
   }

   public List<RegisterUpliftScope> getRegisterUpliftScopes() {
      return registerUpliftScopes;
   }

   public void setRegisterUpliftScopes(List<RegisterUpliftScope> registerUpliftScopes) {
      this.registerUpliftScopes = registerUpliftScopes;
   }

   public RegisterUpliftScope addRegisterUpliftScope(ScopeRef scopeRef) {
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
