package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.CompileError;
import kickass.nonasm.c64.CharToPetsciiConverter;

import java.util.Map;
import java.util.PrimitiveIterator;

/** String encoding. */
public enum StringEncoding {

   PETSCII_MIXED("petscii_mixed", "petscii_mixed", "pm", CharToPetsciiConverter.charToPetscii_mixed),
   PETSCII_UPPER("petscii_upper", "petscii_upper", "pu", CharToPetsciiConverter.charToPetscii_mixed),
   SCREENCODE_MIXED("screencode_mixed", "screencode_mixed", "sm", CharToPetsciiConverter.charToScreenCode_mixed),
   SCREENCODE_UPPER("screencode_upper", "screencode_upper", "su", CharToPetsciiConverter.charToScreenCode_upper),
   ASCII("ascii", "ascii", "as", CharToPetsciiConverter.charToAscii),
   ATASCII("atascii", "ascii", "at", CharToAtasciiConverter.charToAtascii),
   SCREENCODE_ATARI("screencode_atari", null, "sa", CharToAtasciiConverter.charToScreenCodeAtari)
   ;

   /** Char value used to encode \xnn chars without a value within the chosen encoding. A char C is  encoded as CHAR_SPECIAL_VAL+C */
   public static final char CHAR_SPECIAL_VAL = 64000;
   /** The minimal value of a specially encoded char. */
   public static final char CHAR_SPECIAL_MIN = CHAR_SPECIAL_VAL + Byte.MIN_VALUE;
   /** The maximal value of a specially encoded char. */
   public static final char CHAR_SPECIAL_MAX = CHAR_SPECIAL_VAL + Byte.MAX_VALUE;

   /** The encoding name. */
   public final String name;

   /** The KickAsm Encoding name. Null if KickAsm does not support the encoding. */
   public final String asmEncoding;

   /** The string suffix usable for selecting the encoding. */
   public final String suffix;

   /** The mapping from character value to integer (byte) value for the encoding. */
   public final Map<Character, Byte> mapping;

   StringEncoding(String name, String asmEncoding, String suffix, Map<Character, Byte> mapping) {
      this.name = name;
      this.asmEncoding = asmEncoding;
      this.suffix = suffix;
      this.mapping = mapping;
   }

   /**
    * Get encoding by name.
    *
    * @param name The name
    * @return The encoding
    */
   public static StringEncoding fromName(String name) {
      return valueOf(name);
   }

   /**
    * Examine a string suffix, and find any encoding information inside it.
    *
    * @param suffix The string suffix
    * @param defaultEncoding The encoding to use if suffix does not match an encoding
    * @return The encoding specified by the suffix. If not the current source encoding is returned.
    */
   public static StringEncoding fromSuffix(String suffix, StringEncoding defaultEncoding) {
      if(suffix.contains("pm")) {
         return PETSCII_MIXED;
      } else if(suffix.contains("pu")) {
         return PETSCII_UPPER;
      } else if(suffix.contains("p")) {
         return PETSCII_MIXED;
      } else if(suffix.contains("sm")) {
         return SCREENCODE_MIXED;
      } else if(suffix.contains("su")) {
         return SCREENCODE_UPPER;
      } else if(suffix.contains("s")) {
         return SCREENCODE_MIXED;
      } else {
         return defaultEncoding;
      }
   }

   /**
    * Get the integer value of a character within the specific encoding
    *
    * @param aChar The character in UNICODE/ASCII
    * @return The integer value of the character within the encoding
    */
   public Byte encodedFromChar(Character aChar) {
      Byte encodedValue = mapping.get(aChar);
      if(encodedValue != null)
         return encodedValue;
      else
         // Char is not in encoding - it must be made up!
         return (byte) (aChar - CHAR_SPECIAL_VAL);
   }

   /**
    * Determine if a character has en encoding within the specific encoding
    *
    * @param aChar The char to examine
    * @return true if the char has a proper encoding. False if it does not.
    */
   public boolean hasEncoding(Character aChar) {
      Byte encodedValue = mapping.get(aChar);
      return encodedValue != null;
   }


   /**
    * Get UNICODE/ASCII character for a specific encoded integer value using the specific encoding
    *
    * @param encodedValue The integer value
    * @return The character that has the integer value using the encoding
    */
   public Character charFromEncoded(Byte encodedValue) {
      for(Map.Entry<Character, Byte> mapEntry : mapping.entrySet()) {
         if(mapEntry.getValue() == encodedValue.byteValue())
            return mapEntry.getKey();
      }
      // If the mapping does not handle the Char - make one up
      return (char) (CHAR_SPECIAL_VAL + encodedValue);
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
    * @param escapedCharsIterator The characters of the string to parse one char from. The iterator is moved beyond any handled chars.
    * @return The first ASCII character of the list.
    */
   public char escapeToAsciiFirst(PrimitiveIterator.OfInt escapedCharsIterator) {
      char stringChar = (char) escapedCharsIterator.nextInt();
      if(stringChar != '\\')
         return stringChar;
      // Escape started - handle it!
      if(!escapedCharsIterator.hasNext()) throw new CompileError("Unfinished string escape sequence at end of string");
      char escapeChar = (char) escapedCharsIterator.nextInt();
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
            hexNum += (char) escapedCharsIterator.nextInt();
            hexNum += (char) escapedCharsIterator.nextInt();
            final byte hexEncoding = (byte) Integer.parseInt(hexNum, 16);
            return charFromEncoded(hexEncoding);
         default:
            throw new CompileError("Illegal string escape sequence \\" + escapeChar);
      }
   }

   /**
    * Converts a char to an encoded escape sequence if needed. If not needed the char itself is returned.
    *
    * @param aChar The char
    * @param escapeSingleQuotes Should single quotes ' be escaped. (true when encoding chars, false when encoding chars)
    * @return The char itself - or the appropriate escape sequence if needed.
    */
   public String asciiToEscapedEncoded(char aChar, boolean escapeSingleQuotes) {
      if(this.asmEncoding == null) {
         // Encoding not supported by KickAsm - convert to ASCII / use escapes
         final byte encoded = encodedFromChar(aChar);
         if(encoded != ASCII.encodedFromChar(aChar))
            // Not the same as in ASCII - use escape
            return String.format("\\$%02x", encoded);
      }

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
      }
      if(aChar > 127) {
         // Encode all large chars - including SPECIAL's
         final byte encoded = encodedFromChar(aChar);
         return String.format("\\$%02x", encoded);
      } else
         return Character.toString(aChar);
   }

   /**
    * Escapes chars in string if needed
    *
    * @param string The string
    * @return The escaped string.
    */
   public String asciiToEscapedEncoded(String string) {
      StringBuilder escaped = new StringBuilder();
      string.chars().forEach(value -> escaped.append(asciiToEscapedEncoded((char) value, false)));
      return escaped.toString();
   }

}
