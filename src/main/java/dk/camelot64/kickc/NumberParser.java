package dk.camelot64.kickc;

/** Parser for converting literal numbers to the corresponding Java Integer/Double */
public class NumberParser {

   public static Number parseLiteral(String literal) {
      boolean isInt = !literal.contains(".");

      if(isInt) {
         if(literal.startsWith("0x")) {
            return parseHexInt(literal.substring(2));
         } else if(literal.startsWith("$")) {
            return parseHexInt(literal.substring(1));
         } else if(literal.startsWith("0b")) {
            return parseBinInt(literal.substring(2));
         } else if(literal.startsWith("%")) {
            return parseBinInt(literal.substring(1));
         } else {
            return parseDecInt(literal);
         }
      } else {
         throw new NumberFormatException("Not Implemented: non-integer parsing. " + literal);
      }
   }

   private static Long parseHexInt(String literal) {
      return Long.parseLong(literal, 16);
   }

   private static Long parseBinInt(String literal) {
      return Long.parseLong(literal, 2);
   }

   private static Long parseDecInt(String literal) {
      return Long.parseLong(literal);
   }


}
