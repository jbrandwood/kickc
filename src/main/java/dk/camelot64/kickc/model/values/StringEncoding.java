package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.CompileError;
import kickass.nonasm.c64.CharToPetsciiConverter;

import java.util.Map;
import java.util.PrimitiveIterator;

/** String encoding. */
public enum StringEncoding {

   PETSCII_MIXED("petscii_mixed", "pm", CharToPetsciiConverter.charToScreenCode_mixed),
   PETSCII_UPPER("petscii_upper", "pu", CharToPetsciiConverter.charToScreenCode_upper),
   SCREENCODE_MIXED("screencode_mixed", "sm", CharToPetsciiConverter.charToScreenCode_mixed),
   SCREENCODE_UPPER("screencode_upper", "su", CharToPetsciiConverter.charToScreenCode_upper);

   /** The encoding name. */
   public final String name;

   /** The string suffix usable for selecting the encoding. */
   public final String suffix;

   /** The mapping from character value to integer value for the encoding. */
   public final Map<Character, Byte> mapping;

   StringEncoding(String name, String suffix, Map<Character, Byte> mapping) {
      this.name = name;
      this.suffix = suffix;
      this.mapping = mapping;
   }

   /**
    * Get the integer value of a character using a specific encoding
    *
    * @param aChar The character
    * @return The integer value of the character using the encoding
    */
   public Long getInteger(Character aChar) {
      Byte constCharIntValue = mapping.get(aChar);
      return constCharIntValue.longValue();
   }

   /**
    * Get a character with a specific integer value using the specific encoding
    *
    * @param intValue The integer value
    * @return The character that has the integer value using the encoding
    */
   public Character getChar(Byte intValue) {
      for(Map.Entry<Character, Byte> mapEntry : mapping.entrySet()) {
         if(mapEntry.getValue() == intValue.byteValue())
            return mapEntry.getKey();
      }
      return null;
   }

   /**
    * Find any string escape sequences and convert them to the ASCII-equivalent character
    *
    * @param stringValue The string to convert
    * @return The string where any escape sequence has been converted to ASCII
    * @throws CompileError If the string value has a syntax error (unfinished or illegal escape sequences)
    */
   public String escapeToAscii(String stringValue) {
      StringBuilder stringResult = new StringBuilder();
      final PrimitiveIterator.OfInt escapedIterator = stringValue.chars().iterator();
      while(escapedIterator.hasNext()) {
         stringResult.append(escapeToAsciiFirst(escapedIterator));
      }
      return stringResult.toString();
   }

   /**
    * Grabs the first (potentially escaped) character from an iterator.
    * Converts any escapes such as '\n', '\xnn' etc. to the right ASCII character.
    * Moves the iterator forward.
    *
    * @param escapedString The characters of the string to parse one char from. The iterator is moved beyond any handled chars.
    * @return The first ASCII character of the list.
    */
   public char escapeToAsciiFirst(PrimitiveIterator.OfInt escapedCharsIterator) {
      char stringChar = (char)escapedCharsIterator.nextInt();
      if(stringChar != '\\')
         return stringChar;
      // Escape started - handle it!
      if(!escapedCharsIterator.hasNext()) throw new CompileError("Unfinished string escape sequence at end of string");
      char escapeChar = (char)escapedCharsIterator.nextInt();
      switch(escapeChar) {
         case 'n':
            return '\n';
         case 'r':
            return '\r';
         case 'f':
            return '\f';
         case '"':
            return '"';
         case '\'':
            return '\'';
         case '\\':
            return '\\';
         case 'x':
            String hexNum = "";
            hexNum += (char)escapedCharsIterator.nextInt();
            hexNum += (char)escapedCharsIterator.nextInt();
            final int hexChar = Integer.parseInt(hexNum, 16);
            final Character aChar = getChar((byte) hexChar);
            if(aChar == null)
               throw new CompileError("No character 0x" + hexNum + " in encoding " + name);
            return aChar;
         default:
            throw new CompileError("Illegal string escape sequence \\" + escapeChar);
      }
   }

   /**
    * Converts a char to an escape sequence if needed. If not needed the char itself is returned.
    * @param aChar The char
    * @param escapeSingleQuotes Should single quotes ' be escaped. (true when encoding chars, false when encoding chars)
    * @return The char itself - or the appropriate escape sequence
    */
   public String asciiToEscape(char aChar, boolean escapeSingleQuotes) {
      switch(aChar) {
         case '\n':
            return "\\n";
         case '\r':
            return "\\r";
         case '\f':
            return "\\f";
         case '\"':
            return "\\\"";
         case '\'':
            if(escapeSingleQuotes)
               return "\\'";
            else
               return Character.toString(aChar);
         case '\\':
            return "\\\\";
         default:
            return Character.toString(aChar);
      }
   }

   /**
    * Converts a char to an escape sequence if needed. If not needed the char itself is returned.
    * @param aChar The char
    * @return The char itself - or the appropriate escape sequence
    */
   public String asciiToEscape(String string) {
      StringBuilder escaped = new StringBuilder();
      string.chars().forEach(value -> escaped.append(asciiToEscape((char) value, false)));
      return escaped.toString();
   }


}
