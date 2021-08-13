package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.Comment;
import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementCall;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Symbol;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeInference;
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

   /** The printf procedure name. */
   public static final String INTRINSIC_SNPRINTF_NAME = "snprintf";

   /** The printf routine used to print a raw char */
   private static final String CPUTC = "cputc";

   /** The snprintf routine used to print a raw char */
   private static final String SNPUTC = "snputc";

   /** The printf routine used to print a raw string */
   private static final String SNPRINTF_INIT = "snprintf_init";
   /** The printf routine used to print a raw string */
   private static final String PRINTF_STR = "printf_str";
   /** The printf routine used to print formatted strings. */
   private static final String PRINTF_STRING = "printf_string";
   /** The printf routine used to print signed chars. */
   private static final String PRINTF_SCHAR = "printf_schar";
   /** The printf routine used to print unsigned chars. */
   private static final String PRINTF_UCHAR = "printf_uchar";
   /** The printf routine used to print signed integers. */
   private static final String PRINTF_SINT = "printf_sint";
   /** The printf routine used to print unsigned integers. */
   private static final String PRINTF_UINT = "printf_uint";
   /** The printf routine used to print signed long integers. */
   private static final String PRINTF_SLONG = "printf_slong";
   /** The printf routine used to print unsigned long integers. */
   private static final String PRINTF_ULONG = "printf_ulong";

   /** Hexadecimal Radix name. */
   public static final String HEXADECIMAL = "HEXADECIMAL";
   /** Decimal Radix name. */
   public static final String DECIMAL = "DECIMAL";
   /** Octal Radix name. */
   public static final String OCTAL = "OCTAL";

   public Pass1PrintfIntrinsicRewrite(Program program) {
      super(program);
   }

   @Override
   public boolean step() {

      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         final ListIterator<Statement> stmtIt = block.getStatements().listIterator();
         while(stmtIt.hasNext()) {
            Statement statement = stmtIt.next();
            if(statement instanceof StatementCall) {
               if(((StatementCall) statement).getProcedureName().equals(INTRINSIC_PRINTF_NAME)) {
                  StatementCall call = (StatementCall) statement;
                  stmtIt.remove();
                  List<RValue> callParameters = call.getParameters();
                  final RValue format = getParameterValue(callParameters, 0, call);
                  List<RValue> formatParameters = callParameters.subList(1, callParameters.size());
                  addPrintfFormatStatements(stmtIt, call, format, formatParameters, CPUTC);
               } else if(((StatementCall) statement).getProcedureName().equals(INTRINSIC_SNPRINTF_NAME)) {
                  StatementCall call = (StatementCall) statement;
                  stmtIt.remove();
                  List<RValue> callParameters = call.getParameters();
                  final RValue buffer = getParameterValue(callParameters, 0, call);
                  final RValue capacity = getParameterValue(callParameters, 1, call);
                  final RValue format = getParameterValue(callParameters, 2, call);
                  List<RValue> formatParameters = callParameters.subList(3, callParameters.size());
                  addPrintfCall(SNPRINTF_INIT, Arrays.asList(buffer, capacity), stmtIt, call);
                  addPrintfFormatStatements(stmtIt, call, format, formatParameters, SNPUTC);
                  addPrintfCall(SNPUTC, Arrays.asList(new ConstantInteger(0L, SymbolType.BYTE)), stmtIt, call);
               }
            }
         }
      }
      return false;
   }

   /**
    * Add statements to the program printing the formatted string specified
    * @param stmtIt Iterator used to add statements
    * @param printfCall The original printf() statement
    * @param format The format string (must be constant)
    * @param parameters The parameters to the printf function (only the ... parameters)
    * @param putcName The name of the function to use to output a single character
    */
   private StringEncoding addPrintfFormatStatements(ListIterator<Statement> stmtIt, StatementCall printfCall, RValue format, List<RValue> parameters, String putcName) {

      if(!(format instanceof ConstantValue))
         throw new CompileError("Only constant printf() format parameter supported!", printfCall);
      final ConstantLiteral formatLiteral = ((ConstantValue) format).calculateLiteral(getProgram().getScope());
      if(!(formatLiteral instanceof ConstantString))
         throw new CompileError("printf() format parameter must be a string!", printfCall);
      final String formatString = ((ConstantString) formatLiteral).getString();
      final StringEncoding formatEncoding = ((ConstantString) formatLiteral).getEncoding();

      Symbol putcSymbol = getScope().getGlobalSymbol(putcName);
      if(putcSymbol==null)
         throw new CompileError("Needed printf sub-procedure not found " + putcName + "().", ((Statement) printfCall).getSource());
      ConstantValue putcRef = new ConstantSymbolPointer(putcSymbol.getRef());

      // Printf Placeholder Format String - source: https://en.wikipedia.org/wiki/Printf_format_string
      // "%"                  start
      // ([1-9][0-9]* "$")?   parameter (gives the # of the parameter to use)
      // [-+ 0'#]*            flags (different flags affecting the formatting "-": left-align, "0": zero-prepend, "+": always sign)
      // [1-9][0-9]*          width (the minimum number of characters)
      // ("hh" | "l" )?       length (specifies the type of integer "hh": char "": int, "l": long)
      // [%diuxXoscp]         type (specifies the type of the parameter/output "d"/"i" decimal signed, "u": decimal unsigned, "x": hexadecimal unsigned (lowercase), "X": hexadecimal unsigned (uppercase), "o": octal unsigned, "s": string, "c": character, "p": pointer, "%": output "%" )
      Pattern pattern = Pattern.compile("%([1-9][0-9]*[$])?([-+0#]*)([1-9][0-9]*)?(hh|l)?([%diuxXoscp])");
      final Matcher matcher = pattern.matcher(formatString);
      // The index for the format field within the string
      int formatIdx = 0;
      // The index of the parameter being used as value for formatting. Incremented automatically unless field parameter index syntax (eg. %2$d) is used.
      int paramIdx = 0;
      // True if field parameter index syntax (eg. %2$d) is used.
      boolean fieldParamIdx = false;
      while(true) {
         // Find the next pattern match!
         boolean found = matcher.find();
         if(!found) {
            // No more matching patterns
            break;
         }
         final int start = matcher.start();
         final int end = matcher.end();

         final String typeField = matcher.group(5);
         final String paramField = matcher.group(1);
         // Ensure that all fields use parameter index syntax!
         if(paramField == null && fieldParamIdx && !typeField.equals("%"))
            throw new CompileError("If any single printf() placeholder specifies a parameter, all the rest of the placeholders must also specify a parameter!", printfCall);
         if(paramField != null) {
            if(!fieldParamIdx && paramIdx > 0)
               throw new CompileError("If any single printf() placeholder specifies a parameter, all the rest of the placeholders must also specify a parameter!", printfCall);
            fieldParamIdx = true;
            paramIdx = Integer.parseInt(paramField.substring(0, paramField.length() - 1))-1;
         }
         final String flagsField = matcher.group(2);
         long leftJustify = (flagsField != null && flagsField.contains("-")) ? 1 : 0;
         long signAlways = (flagsField != null && flagsField.contains("+")) ? 1 : 0;
         long zeroPadding = (flagsField != null && flagsField.contains("0")) ? 1 : 0;
         final String widthField = matcher.group(3);
         long width = (widthField == null) ? 0 : Integer.parseInt(widthField);
         final String lengthField = matcher.group(4);
         long upperCase = 0L;

         // First output the non-matching part before the pattern
         String prefix = formatString.substring(formatIdx, start);
         if(prefix.length() > 0) {
            addPrintfCall(PRINTF_STR, Arrays.asList(putcRef, new ConstantString(prefix, formatEncoding, true)), stmtIt, printfCall);
         }
         formatIdx = end;

         if(typeField.equals("%")) {
            addPrintfCall(putcName, Arrays.asList(new ConstantChar('%', formatEncoding)), stmtIt, printfCall);
         } else if(typeField.equals("s")) {
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
            addPrintfCall(PRINTF_STRING, Arrays.asList(putcRef, getParameterValue(parameters, paramIdx, printfCall), format_string_struct), stmtIt, printfCall);
            paramIdx++;
         } else if("diuxXo".contains(typeField)) {
            // A formatted integer
            SymbolVariableRef radix;
            String printf_number_procedure;
            boolean signed;
            switch(typeField) {
               case "d":
               case "i":
                  radix = getScope().getLocalConstant(DECIMAL).getRef();
                  signed = true;
                  break;
               case "u":
                  radix = getScope().getLocalConstant(DECIMAL).getRef();
                  signed = false;
                  break;
               case "x":
                  radix = getScope().getLocalConstant(HEXADECIMAL).getRef();
                  signed = false;
                  break;
               case "X":
                  radix = getScope().getLocalConstant(HEXADECIMAL).getRef();
                  signed = false;
                  upperCase = 1l;
                  break;
               case "o":
                  radix = getScope().getLocalConstant(OCTAL).getRef();
                  signed = false;
                  break;
               default:
                  throw new CompileError("printf type field not supported", printfCall);
            }

            if(lengthField == null) {
               // Check if the parameter type is 8-bit or 32-bit
               RValue paramValue = getParameterValue(parameters, paramIdx, printfCall);
               SymbolType paramType = SymbolTypeInference.inferType(getScope(), paramValue);
               if(SymbolType.BYTE.equals(paramType) || SymbolType.SBYTE.equals(paramType)) {
                  // Integer (8bit)
                  printf_number_procedure = signed ? PRINTF_SCHAR : PRINTF_UCHAR;
               } else if(SymbolType.DWORD.equals(paramType) || SymbolType.SDWORD.equals(paramType)) {
                  // Integer (32bit)
                  printf_number_procedure = signed ? PRINTF_SLONG : PRINTF_ULONG;
               } else {
                  // Integer (16bit)
                  printf_number_procedure = signed ? PRINTF_SINT : PRINTF_UINT;
               }
            } else if(lengthField.equals("hh")) {
               // Integer (8bit)
               printf_number_procedure = signed ? PRINTF_SCHAR : PRINTF_UCHAR;
            } else if(lengthField.equals("l")) {
               // Integer (32bit)
               printf_number_procedure = signed ? PRINTF_SLONG : PRINTF_ULONG;
            } else {
               throw new CompileError("printf length field not supported", printfCall);
            }

            // Format specifying how to format a printed number
            // struct printf_format_number {
            // char min_length; // The minimal number of chars to output (used for padding with spaces or 0)
            // char justify_left; // Justify left instead of right, which is the default.
            // char sign_always; // Always show a sign for a number, even if is is positive. (Default is to only show sign for negative numbers)
            // char zero_padding; // Pad the number with zeros to get the min width
            // char upper_case; // Upper-case the letters in the number
            // enum RADIX radix; // The number radix to use for formatting
            // };
            final ValueList format_number_struct =
                  new ValueList(Arrays.asList(
                        new ConstantInteger(width, SymbolType.BYTE),
                        new ConstantInteger(leftJustify, SymbolType.BYTE),
                        new ConstantInteger(signAlways, SymbolType.BYTE),
                        new ConstantInteger(zeroPadding, SymbolType.BYTE),
                        new ConstantInteger(upperCase, SymbolType.BYTE),
                        radix
                  ));
            addPrintfCall(printf_number_procedure, Arrays.asList(putcRef, getParameterValue(parameters, paramIdx, printfCall), format_number_struct), stmtIt, printfCall);
            paramIdx++;
         } else if(typeField.equals("c")) {
            // Print char
            addPrintfCall(putcName, Arrays.asList(getParameterValue(parameters, paramIdx, printfCall)), stmtIt, printfCall);
            paramIdx++;
         } else if(typeField.equals("p")) {
            // Print a pointer
            final ValueList format_number_struct =
                  new ValueList(Arrays.asList(
                        new ConstantInteger(width, SymbolType.BYTE),
                        new ConstantInteger(leftJustify, SymbolType.BYTE),
                        new ConstantInteger(signAlways, SymbolType.BYTE),
                        new ConstantInteger(zeroPadding, SymbolType.BYTE),
                        new ConstantInteger(upperCase, SymbolType.BYTE),
                        getScope().getLocalConstant(HEXADECIMAL).getRef()
                  ));
            addPrintfCall(PRINTF_UINT, Arrays.asList(putcRef, new CastValue(SymbolType.WORD, getParameterValue(parameters, paramIdx, printfCall)), format_number_struct), stmtIt, printfCall);
            paramIdx++;
         }
      }
      // Grab the rest
      String suffix = formatString.substring(formatIdx);
      if(suffix.length() > 0)
         addPrintfCall(PRINTF_STR, Arrays.asList(putcRef, new ConstantString(suffix, formatEncoding, true)), stmtIt, printfCall);

      return formatEncoding;
   }

   /**
    * Get a specific parameter value.
    * @param parameters The list of parameters
    * @param paramIdx The index of the parameter to get
    * @param printfCall The printf call statement used for errors
    * @return The parameter value.
    *
    * @throws CompileError if the parameter is not present
    */
   private RValue getParameterValue(List<RValue> parameters, int paramIdx, StatementCall printfCall) {
      if(parameters.size()<=paramIdx)
         throw new CompileError("printf missing parameter with index "+(paramIdx+1), printfCall);
      return parameters.get(paramIdx);
   }

   /**
    * Adds a call to a PRINTF sub-function.
    *
    * @param printfProcedureName The name of ths sub-function to call
    * @param printfProcedureParameters The parameters to pass
    * @param stmtIt The statement iterator to add to
    * @param printfCall The original printf call statement
    */
   private void addPrintfCall(String printfProcedureName, List<RValue> printfProcedureParameters, ListIterator<Statement> stmtIt, StatementCall printfCall) {
      final StatementCall call_printf_str_prefix = new StatementCall(null, printfProcedureName, printfProcedureParameters, printfCall.getSource(), Comment.NO_COMMENTS);
      final Procedure printfProcedure = getScope().getLocalProcedure(call_printf_str_prefix.getProcedureName());
      if(printfProcedure == null) {
         throw new CompileError("Needed printf sub-procedure not found " + printfProcedureName + "().", printfCall.getSource());
      }
      call_printf_str_prefix.setProcedure(printfProcedure.getRef());
      stmtIt.add(call_printf_str_prefix);
   }


}
