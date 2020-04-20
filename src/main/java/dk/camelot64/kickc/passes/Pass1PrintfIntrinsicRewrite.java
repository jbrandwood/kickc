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
   /** The printf routine used to print formatted strings. */
   public static final String PRINTF_STRING = "printf_string";
   /** The printf routine used to print signed integers. */
   public static final String PRINTF_SINT = "printf_sint";
   /** The printf routine used to print unsigned integers. */
   public static final String PRINTF_UINT = "printf_uint";

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

               // Printf Placeholder Format String - source: https://en.wikipedia.org/wiki/Printf_format_string
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

                  final String paramField = matcher.group(1);
                  if(paramField != null)
                     throw new CompileError("printf parameter field not supported", printfCall);

                  final String flagsField = matcher.group(2);
                  long leftJustify = (flagsField != null && flagsField.contains("-")) ? 1 : 0;
                  long signAlways = (flagsField != null && flagsField.contains("+")) ? 1 : 0;
                  long zeroPadding = (flagsField != null && flagsField.contains("0")) ? 1 : 0;

                  final String widthField = matcher.group(3);
                  long width = (widthField == null) ? 0 : Integer.parseInt(widthField);

                  final String lengthField = matcher.group(4);

                  final String typeField = matcher.group(5);

                  // First output the non-matching part before the pattern
                  String prefix = formatString.substring(formatIdx, start);
                  printfConstantString(prefix, printfCall, stmtIt, formatEncoding);
                  formatIdx = end;


                  if(typeField.equals("s")) {
                     // A formatted string
                     //struct printf_format_string {
                     // char min_length; // The minimal number of chars to output (used for padding with spaces or 0).
                     // char justify_left; // Justify left instead of right, which is the default.
                     //};
                     final ValueList format_string_struct =
                           new ValueList(Arrays.asList(
                                 new ConstantInteger(width, SymbolType.BYTE),
                                 new ConstantInteger(leftJustify, SymbolType.BYTE)
                           ));
                     final StatementCall call_printf_str = new StatementCall(null, PRINTF_STRING, Arrays.asList(parameters.get(paramIdx), format_string_struct), printfCall.getSource(), Comment.NO_COMMENTS);
                     call_printf_str.setProcedure(getScope().getLocalProcedure(call_printf_str.getProcedureName()).getRef());
                     stmtIt.add(call_printf_str);
                     paramIdx++;
                  } else if("diuxXo".contains(typeField)) {
                     // A formatted integer
                     SymbolVariableRef radix;
                     String printf_number_procedure;
                     if(typeField.equals("d")) {
                        radix = getScope().getLocalConstant("DECIMAL").getRef();
                        printf_number_procedure = PRINTF_SINT;
                     } else if(typeField.equals("x")) {
                        radix = getScope().getLocalConstant("HEXADECIMAL").getRef();
                        printf_number_procedure = PRINTF_UINT;
                     } else {
                        throw new CompileError("printf type field not supported", printfCall);
                     }

                     // Format specifying how to format a printed number
                     // struct printf_format_number {
                     // char min_length; // The minimal number of chars to output (used for padding with spaces or 0)
                     // char justify_left; // Justify left instead of right, which is the default.
                     // char sign_always; // Always show a sign for a number, even if is is positive. (Default is to only show sign for negative numbers)
                     // char zero_padding; // Pad the number with zeros to get the min width
                     // enum RADIX radix; // The number radix to use for formatting
                     // };
                     final ValueList format_number_struct =
                           new ValueList(Arrays.asList(
                                 new ConstantInteger(width, SymbolType.BYTE),
                                 new ConstantInteger(leftJustify, SymbolType.BYTE),
                                 new ConstantInteger(signAlways, SymbolType.BYTE),
                                 new ConstantInteger(zeroPadding, SymbolType.BYTE),
                                 radix
                           ));
                     final StatementCall call_printf_str = new StatementCall(null, printf_number_procedure, Arrays.asList(parameters.get(paramIdx), format_number_struct), printfCall.getSource(), Comment.NO_COMMENTS);
                     call_printf_str.setProcedure(getScope().getLocalProcedure(call_printf_str.getProcedureName()).getRef());
                     stmtIt.add(call_printf_str);
                     paramIdx++;
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
    *
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
