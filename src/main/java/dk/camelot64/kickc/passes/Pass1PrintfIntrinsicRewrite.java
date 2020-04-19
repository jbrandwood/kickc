package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.*;

import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Rewrite printf() calls to a series of printf-calls by parsing the format string.
 */
public class Pass1PrintfIntrinsicRewrite extends Pass2SsaOptimization {

   /** The printf procedure name. */
   public static final String INTRINSIC_PRINTF_NAME = "printf";

   public Pass1PrintfIntrinsicRewrite(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall && ((StatementCall) statement).getProcedureName().equals(INTRINSIC_PRINTF_NAME)) {
               StatementCall printfCall = (StatementCall) statement;
               final List<RValue> parameters = printfCall.getParameters();
               final RValue formatParameter = parameters.get(0);
               if(!(formatParameter instanceof ConstantValue))
                  throw new CompileError("Error! Only constant printf() format parameter supported!", statement);
               final ConstantLiteral formatLiteral = ((ConstantValue) formatParameter).calculateLiteral(getProgram().getScope());
               if(!(formatLiteral instanceof ConstantString))
                  throw new CompileError("Error! printf() format parameter must be a string!", statement);
               final String formatString = ((ConstantString) formatLiteral).getString();
               final StringEncoding formatEncoding = ((ConstantString) formatLiteral).getEncoding();

               // Remove the call to printf()
               stmtIt.remove();

               // Printf Placeholder Format String
               // "%"                  start
               // ([1-9][0-9]* "$")?   parameter (gives the # of the parameter to use)
               // [-+ 0'#]*            flags (different flags affecting the formatting "-": left-align, "0": zero-prepend, "+": always sign)
               // [1-9][0-9]*          width (the minimum number of characters)
               // ("hh" | "l" )?       length (specifies the type of integer "hh": char "": int, "l": long)
               // [%diuxXoscp]         type (specifies the type of the parameter/output "d"/"i" decimal signed, "u": decimal unsigned, "x": hexadecimal unsigned (lowercase), "X": hexadecimal unsigned (uppercase), "o": octal unsigned, "s": string, "c": character, "p": pointer, "%": output "%" )
               Pattern pattern = Pattern.compile("%([1-9][0-9]*[$])?([-+0#]*)([1-9][0-9]*)?(hh|l)?([%diuxXoscp])");
               final Matcher matcher = pattern.matcher(formatString);
               int formatIdx = 0;
               int paramIdx = 1;
               while(true) {
                  // Find the next pattern match!
                  boolean found = matcher.find();
                  if(!found) {
                     // No more matching patterns
                     break;
                  }
                  final int start = matcher.start();
                  final int end = matcher.end();
                  final String param = matcher.group(1);
                  final String flags = matcher.group(2);
                  final String width = matcher.group(3);
                  final String length = matcher.group(4);
                  final String type = matcher.group(5);

                  if(param!=null)
                     throw new CompileError("printf parameter field not supported", printfCall);

                  // First grab the non-matching part
                  String prefix = formatString.substring(formatIdx, start);
                  printfConstantString(prefix, printfCall, stmtIt, formatEncoding);

                  formatIdx = end;
                  if(type.equals("s")) {
                     // A string
                     long w = (width==null)?0:Integer.parseInt(width);
                     long leftJustify = (flags!=null && flags.contains("-"))?1:0;
                     final ValueList format_string_struct = new ValueList(Arrays.asList(new ConstantInteger(w, SymbolType.BYTE), new ConstantInteger(leftJustify, SymbolType.BYTE)));
                     final StatementCall call_printf_str = new StatementCall(null, "printf_string", Arrays.asList(parameters.get(paramIdx), format_string_struct), printfCall.getSource(), Comment.NO_COMMENTS);
                     call_printf_str.setProcedure(getScope().getLocalProcedure(call_printf_str.getProcedureName()).getRef());
                     stmtIt.add(call_printf_str);
                     paramIdx++;
                  } else if(type.equals("d")) {
                     System.out.println("decimal");
                  }
               }
               // Grab the rest
               String suffix = formatString.substring(formatIdx);
               printfConstantString(suffix, printfCall, stmtIt, formatEncoding);
            }
         }
      }
      return false;
   }

   /**
    * Add a printf_str() that prints a constant string.
    * @param prefix The string to print
    * @param printfCall The original printf call
    * @param stmtIt The statement iterator to add to
    * @param encoding The string encoding
    */
   private void printfConstantString(String prefix, StatementCall printfCall, ListIterator<Statement> stmtIt, StringEncoding encoding) {
      final StatementCall call_printf_str = new StatementCall(null, "printf_str", Arrays.asList(new ConstantString(prefix, encoding, true)), printfCall.getSource(), Comment.NO_COMMENTS);
      call_printf_str.setProcedure(getScope().getLocalProcedure(call_printf_str.getProcedureName()).getRef());
      stmtIt.add(call_printf_str);
   }


}
