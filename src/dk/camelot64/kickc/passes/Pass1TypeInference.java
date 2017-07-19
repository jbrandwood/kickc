package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.icl.*;

import java.util.Stack;

/**
 * Pass through the generated statements inferring types of unresolved variables.
 * Also updates procedure calls to point to the actual procedure called.
 */
public class Pass1TypeInference {

   private Scope programScope;

   public Pass1TypeInference(Scope programScope) {
      this.programScope = programScope;
   }

   public void inferTypes(StatementSequence sequence) {
      Stack<Scope> scopes = new Stack<>();
      scopes.add(programScope);
      for (Statement statement : sequence.getStatements()) {
         if(statement instanceof StatementProcedureBegin) {
                StatementProcedureBegin procedureBegin = (StatementProcedureBegin) statement;
                scopes.push(procedureBegin.getProcedure());
         }  else if(statement instanceof StatementProcedureEnd) {
            scopes.pop();
         } else if (statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            if (lValue instanceof VariableRef) {
               Variable symbol = programScope.getVariable((VariableRef) lValue);
               if (SymbolTypeBasic.VAR.equals(symbol.getType())) {
                  // Unresolved symbol - perform inference
                  Operator operator = assignment.getOperator();
                  if (operator == null || assignment.getrValue1() == null) {
                     // Copy operation or Unary operation
                     RValue rValue = assignment.getrValue2();
                     SymbolType subType = inferType(rValue);
                     SymbolType type = inferType(operator, subType);
                     symbol.setTypeInferred(type);
                  } else {
                     // Binary operation
                     SymbolType type1 = inferType(assignment.getrValue1());
                     SymbolType type2 = inferType(assignment.getrValue2());
                     SymbolType type = inferType(type1, operator, type2);
                     symbol.setTypeInferred(type);
                  }
               }
            }
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            LValue lValue = call.getlValue();
            if(lValue instanceof VariableRef) {
               String procedureName = call.getProcedureName();
               Procedure procedure = scopes.peek().getProcedure(procedureName);
               call.setProcedure(procedure);
               if(procedure.getParameters().size()!=call.getParameters().size()) {
                  throw new RuntimeException("Wrong number of parameters in call. Expected " +procedure.getParameters().size()+". "+statement.toString());
               }
               Variable lValueVar = programScope.getVariable((VariableRef) lValue);
               lValueVar.setTypeInferred(procedure.getReturnType());
            }
         }
      }
   }

   private SymbolType inferType(Operator operator, SymbolType subType) {
      if(operator==null) {
         return subType;
      }
      String op = operator.getOperator();
      switch (op) {
         case "*":
            if(subType instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) subType).getElementType();
            } else {
               throw new RuntimeException("Type error: Dereferencing a non-pointer "+subType);
            }
         default:
            return subType;
      }
   }

   private SymbolType inferType(SymbolType type1, Operator operator, SymbolType type2) {
      String op = operator.getOperator();
      switch (op) {
         case "==":
         case "<":
         case "<=":
         case "=<":
         case ">":
         case ">=":
         case "=>":
         case "<>":
         case "!=":
         case "&&":
         case "||":
         case "and":
         case "or":
            return SymbolTypeBasic.BOOLEAN;
         case "+":
         case "-":
            if (type1 instanceof SymbolTypePointer && (type2.equals(SymbolTypeBasic.BYTE) || type2.equals(SymbolTypeBasic.WORD))) {
               return new SymbolTypePointer(((SymbolTypePointer) type1).getElementType());
            }
            if (type1 instanceof SymbolTypePointer && type2 instanceof SymbolTypePointer) {
               SymbolType elmType1 = ((SymbolTypePointer) type1).getElementType();
               SymbolType elmType2 = ((SymbolTypePointer) type2).getElementType();
               return inferType(elmType1, operator, elmType2);
            }
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*":
            if(type1==null && type2 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type2).getElementType();
            }
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "*idx":
            if(type1 instanceof SymbolTypePointer) {
               return ((SymbolTypePointer) type1).getElementType();
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "/":
            if (SymbolTypeBasic.WORD.equals(type1) || SymbolTypeBasic.WORD.equals(type2)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1) && SymbolTypeBasic.BYTE.equals(type2)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         case "<<":
         case ">>":
            if (SymbolTypeBasic.WORD.equals(type1)) {
               return SymbolTypeBasic.WORD;
            } else if (SymbolTypeBasic.BYTE.equals(type1)) {
               return SymbolTypeBasic.BYTE;
            }
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
         default:
            throw new RuntimeException("Type inference case not handled " + type1 + " " + operator + " " + type2);
      }
   }

   public SymbolType inferType(RValue rValue) {
      SymbolType type = null;
      if (rValue instanceof VariableRef) {
         Variable variable = programScope.getVariable((VariableRef) rValue);
         type = variable.getType();
      } else if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         type = rSymbol.getType();
      } else if (rValue instanceof ConstantInteger) {
         ConstantInteger rInt = (ConstantInteger) rValue;
         return rInt.getType();
      } else if (rValue instanceof ConstantString) {
         type = SymbolTypeBasic.STRING;
      } else if (rValue instanceof ConstantBool) {
         type = SymbolTypeBasic.BOOLEAN;
      }
      if (type == null) {
         throw new RuntimeException("Cannot infer type for " + rValue);
      }
      return type;
   }

}
