package dk.camelot64.kickc.icl;

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
         throw new RuntimeException("Not Implemented: non-integer parsing");
      }
   }

   private static Integer parseHexInt(String literal) {
      return Integer.parseInt(literal, 16);
   }

   private static Integer parseBinInt(String literal) {
      return Integer.parseInt(literal, 2);
   }

   private static Integer parseDecInt(String literal) {
      return Integer.parseInt(literal);
   }


}
