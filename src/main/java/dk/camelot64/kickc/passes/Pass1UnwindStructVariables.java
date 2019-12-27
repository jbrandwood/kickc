package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StructUnwinding;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;

/** Create unwindings for all unwinding struct variables. The unwinding is a conversion to one variable per member.
 * The unwindings are stored in {@link Program#getStructUnwinding()}
 * */
public class Pass1UnwindStructVariables extends Pass1Base {

   public Pass1UnwindStructVariables(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      if(getProgram().getStructUnwinding() == null) {
         getProgram().setStructUnwinding(new StructUnwinding());
      }
      // Iterate through all scopes generating member-variables for each struct
      return unwindStructVariables();
   }

   /**
    * Iterate through all scopes generating member-variables for each struct variable
    *
    * @return Information about all unwound struct variables
    */
   private boolean unwindStructVariables() {
      boolean modified = false;
      // Iterate through all scopes generating member-variables for each struct
      for(Variable variable : getScope().getAllVariables(true)) {
         if(variable.isStructUnwind()) {
            StructUnwinding structUnwinding = getProgram().getStructUnwinding();
            if(structUnwinding.getVariableUnwinding(variable.getRef()) == null) {
               // A non-volatile struct variable
               Scope scope = variable.getScope();
               if(!(scope instanceof StructDefinition)) {
                  // Not inside another struct
                  StructDefinition structDefinition = ((SymbolTypeStruct) variable.getType()).getStructDefinition(getProgram().getScope());
                  StructUnwinding.VariableUnwinding variableUnwinding = structUnwinding.createVariableUnwinding(variable.getRef());
                  for(Variable member : structDefinition.getAllVars(false)) {
                     boolean isParameter = scope instanceof Procedure && ((Procedure) scope).getParameters().contains(variable);
                     Variable memberVariable = Variable.createStructMemberUnwound(variable, member, isParameter);
                     scope.add(memberVariable);
                     variableUnwinding.setMemberUnwinding(member.getLocalName(), memberVariable.getRef(), memberVariable.getType());
                     getLog().append("Created struct value member variable " + memberVariable.toString(getProgram()));
                  }
                  getLog().append("Converted struct value to member variables " + variable.toString(getProgram()));
                  modified = true;
               }
            }
         }
      }
      return modified;
   }

}
