package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.RValue;
import dk.camelot64.kickc.model.values.SymbolVariableRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.LinkedHashMap;
import java.util.ListIterator;
import java.util.Map;

/** Compiler Pass eliminating phi variables where all rValues are the same */
public class Pass2IdenticalPhiElimination extends Pass2SsaOptimization {

   public Pass2IdenticalPhiElimination(Program program) {
      super(program);
   }

   /**
    * Find phi-variables where all rValues are identical - and eliminate them (by alias-replacing with the passed value)
    */
   @Override
   public boolean step() {
      Map<VariableRef, RValue> consts = new LinkedHashMap<>();
      Pass2AliasElimination.Aliases aliases = new Pass2AliasElimination.Aliases();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock statementPhi = (StatementPhiBlock) statement;
               ListIterator<StatementPhiBlock.PhiVariable> phiVariableIt = statementPhi.getPhiVariables().listIterator();
               while(phiVariableIt.hasNext()) {
                  StatementPhiBlock.PhiVariable phiVariable = phiVariableIt.next();
                  RValue rValue = null;
                  boolean identical = true;
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     if(phiRValue.getrValue() instanceof SymbolVariableRef) {
                        Variable symbolVar = (Variable) getScope().getSymbol((SymbolVariableRef) phiRValue.getrValue());
                        if(symbolVar.getRegister() != null) { //TODO: Handle register/memory/storage strategy differently!
                           // Do not collapse PHI's for variables with declared registers (this prevents procedure parameters from being turned into constants)
                           identical = false;
                           break;
                        }
                     }
                     if(phiRValue.getrValue().equals(phiVariable.getVariable())) {
                        // Self PHI - skip that
                        continue;
                     }
                     if(rValue == null) {
                        rValue = phiRValue.getrValue();
                     } else {
                        if(!rValue.equals(phiRValue.getrValue())) {
                           identical = false;
                           break;
                        }
                     }
                  }
                  if(identical && rValue != null) {
                     // Found a phi-value with all rValues being identical
                     if(rValue instanceof VariableRef) {
                        // Flip the sequence to let the incoming RValue win if the AliasSet.keepvar scores are identical
                        aliases.add((VariableRef) rValue, phiVariable.getVariable());
                     } else {
                        consts.put(phiVariable.getVariable(), rValue);
                     }
                  }
               }
            }
         }
      }
      // Handle constants
      if(consts.size() > 0) {
         removeAssignments(getGraph(), consts.keySet());
         replaceVariables(consts, getProgram());
         for(VariableRef var : consts.keySet()) {
            RValue alias = consts.get(var);
            getLog().append("Identical Phi Const Values " + var.toString(getProgram()) + " " + alias.toString(getProgram()));
         }
         deleteSymbols(getScope(), consts.keySet());
      }
      // Handle variable aliases
      if(aliases.size() > 0) {
         Pass2AliasElimination.cleanUpAliasCandidates(aliases, getProgram());
         Pass2AliasElimination.fixAliasSources(aliases, getProgram());
         Pass2AliasElimination.removeAliasAssignments(aliases, getProgram());
         replaceVariables(aliases.getReplacements(getScope()), getProgram());
         for(Pass2AliasElimination.AliasSet aliasSet : aliases.getAliasSets()) {
            getLog().append("Identical Phi Alias " + aliasSet.toString(getProgram()));
         }
         deleteSymbols(getScope(), aliases.getSymbolsToRemove(getScope()));
      }
      return (consts.size() > 0) || (aliases.size() > 0);
   }

}
