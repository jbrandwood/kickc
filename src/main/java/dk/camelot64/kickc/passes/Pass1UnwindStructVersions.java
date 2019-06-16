package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.StructUnwinding;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.symbols.StructDefinition;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.StructUnwoundPlaceholder;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;

/** Find the versioned unwound structs - and update the StructUnwinding data structure */
public class Pass1UnwindStructVersions extends Pass1Base {

   public Pass1UnwindStructVersions(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      boolean modified = false;
      StructUnwinding structUnwinding = getProgram().getStructUnwinding();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getOperator() == null && assignment.getlValue() instanceof VariableRef && assignment.getrValue2() instanceof StructUnwoundPlaceholder) {
                  VariableRef structVarRef = (VariableRef) assignment.getlValue();
                  if(structUnwinding.getVariableUnwinding(structVarRef) == null) {
                     StructUnwinding.VariableUnwinding versionedUnwinding = structUnwinding.createVariableUnwinding(structVarRef);
                     StructUnwoundPlaceholder placeholder = (StructUnwoundPlaceholder) assignment.getrValue2();
                     SymbolTypeStruct typeStruct = placeholder.getTypeStruct();
                     StructDefinition structDefinition = typeStruct.getStructDefinition(getProgram().getScope());
                     Collection<Variable> members = structDefinition.getAllVariables(false);
                     Iterator<Variable> memberDefIt = members.iterator();
                     List<RValue> unwoundMembers = placeholder.getUnwoundMembers();
                     Iterator<RValue> memberUnwoundIt = unwoundMembers.iterator();
                     while(memberDefIt.hasNext()) {
                        Variable memberVar = memberDefIt.next();
                        RValue memberVal = memberUnwoundIt.next();
                        versionedUnwinding.setMemberUnwinding(memberVar.getLocalName(), (VariableRef) memberVal);
                     }
                     getLog().append("Adding versioned struct unwinding for "+assignment.getlValue().toString(getProgram()));
                     modified = true;
                  }
               }
            }
         }
      }
      return modified;
   }

}
