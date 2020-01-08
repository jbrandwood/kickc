package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolTypePointer;
import dk.camelot64.kickc.model.types.SymbolTypeStruct;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;
import java.util.ListIterator;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Rewrite struct address-of to use the first member if the struct is unwound
 */
public class PassNStructAddressOfRewriting extends Pass2SsaOptimization {

   public PassNStructAddressOfRewriting(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      AtomicBoolean modified = new AtomicBoolean(false);

      // Examine all expressions
      ProgramValueIterator.execute(getProgram(), (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value value = programValue.get();
         if(value instanceof ConstantSymbolPointer) {
            ConstantSymbolPointer constantSymbolPointer = (ConstantSymbolPointer) value;
            SymbolRef toSymbolRef = constantSymbolPointer.getToSymbol();
            Symbol toSymbol = getScope().getSymbol(toSymbolRef);
            if(toSymbol.getType() instanceof SymbolTypeStruct) {
               RValue rewrite = rewriteStructAddressOf((SymbolVariableRef) toSymbol.getRef());
               if(rewrite != null) {
                  programValue.set(rewrite);
                  getLog().append("Rewriting struct address-of to first member " + value.toString(getProgram()));
                  modified.set(true);
               }
            }
         }
      });

      // Examine all statements
      for(ControlFlowBlock block : getProgram().getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(Operators.ADDRESS_OF.equals(assignment.getOperator())) {
                  RValue rValue = assignment.getrValue2();
                  if(rValue instanceof SymbolVariableRef) {
                     Symbol toSymbol = getScope().getSymbol((SymbolVariableRef) rValue);
                     if(toSymbol.getType() instanceof SymbolTypeStruct) {
                        RValue rewrite = rewriteStructAddressOf((SymbolVariableRef) toSymbol.getRef());
                        if(rewrite != null) {
                           assignment.setOperator(null);
                           assignment.setrValue2(rewrite);
                           getLog().append("Rewriting struct address-of to first member " + assignment.toString(getProgram(), false));
                        }
                        modified.set(true);
                     }
                  }
               }
            }
         }
      }

      // Remove all StructUnwoundPlaceholder assignments for C-classic structs
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               if(assignment.getrValue2() instanceof StructUnwoundPlaceholder && assignment.getlValue() instanceof VariableRef)
                  if(getScope().getVariable((SymbolVariableRef) assignment.getlValue()).isStructClassic()) {
                     getLog().append("Removing C-classic struct-unwound assignment "+assignment.toString(getProgram(), false));
                     stmtIt.remove();
                  }
            }
         }
      }
      return modified.get();
   }

   private RValue rewriteStructAddressOf(SymbolVariableRef toSymbol) {
      Variable variable = getScope().getVar(toSymbol);

      // Constant struct values do not need rewriting
      if(variable.isKindConstant())
         return null;

      // Hacky way to handle PHI-masters
      if(variable.isKindPhiMaster()) {
         Collection<Variable> versions = variable.getScope().getVersions(variable);
         for(Variable version : versions) {
            if(variable.isVariable()) {
               variable = version;
               break;
            }
         }
      }

      StatementLValue toSymbolAssignment = getGraph().getAssignment(variable.getVariableRef());
      if(toSymbolAssignment instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) toSymbolAssignment;
         if(assignment.getrValue2() instanceof StructUnwoundPlaceholder) {
            // Found placeholder assignment!
            StructUnwoundPlaceholder placeholder = (StructUnwoundPlaceholder) assignment.getrValue2();
            RValue firstUnwoundMember = placeholder.getUnwoundMembers().get(0);
            if(firstUnwoundMember instanceof SymbolRef) {
               SymbolRef firstMember = (SymbolRef) firstUnwoundMember;
               return new ConstantCastValue(new SymbolTypePointer(placeholder.getTypeStruct()), new ConstantSymbolPointer(firstMember));
            }
         }
      }
      return null;
   }

}
