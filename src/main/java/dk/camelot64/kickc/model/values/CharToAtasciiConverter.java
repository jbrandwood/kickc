package dk.camelot64.kickc.model.values;

import kickass.nonasm.c64.CharToPetsciiConverter;

import java.util.HashMap;
import java.util.Map;

/**
 * Supports the ATARI charset ATASCII and the ATARI screencodes
 */
public class CharToAtasciiConverter {

   /** Map from UNICODE char to Byte value for ATASCII. https://www.atariarchives.org/mapping/appendix10.php */
   public static Map<Character, Byte> charToAtascii;

   /** Map from UNICODE char to Byte value for Atari Screencode. https://www.atariarchives.org/mapping/appendix10.php */
   public static Map<Character, Byte> charToScreenCodeAtari;

   /** ASCII newline encoding. */
   public static final byte NEWLINE_ASCII = 0x0a;

   /** ATASCII newline encoding. */
   public static final byte NEWLINE_ATASCII = (byte) 0x9b;

   static {
      charToAtascii = getCharToAtascii();
      charToScreenCodeAtari = getCharToScreenCodeAtari();
   }

   private static Map<Character, Byte> getCharToAtascii() {
      Map<Character, Byte> charToAtascii = new HashMap<>();
      for(Character asciiChar : CharToPetsciiConverter.charToAscii.keySet()) {
         final Byte asciiByte = CharToPetsciiConverter.charToAscii.get(asciiChar);
         byte atasciiByte;
         if(asciiByte == NEWLINE_ASCII)
            atasciiByte = NEWLINE_ATASCII;
         else
            atasciiByte = asciiByte;
         charToAtascii.put(asciiChar, atasciiByte);
      }
      return charToAtascii;
   }

   private static Map<Character, Byte> getCharToScreenCodeAtari() {
      Map<Character, Byte> charToScreenCodeAtari = new HashMap<>();
      for(Character atasciiChar : charToAtascii.keySet()) {
         final Byte atasciiByte = charToAtascii.get(atasciiChar);
         byte screencodeAtariByte;
         if(atasciiByte >= 0 && atasciiByte <= 31)
            screencodeAtariByte = (byte) (atasciiByte + 64);
         else if(atasciiByte >= 32 && atasciiByte <= 96)
            screencodeAtariByte = (byte) (atasciiByte - 32);
         else
            screencodeAtariByte = atasciiByte;
         charToScreenCodeAtari.put(atasciiChar, screencodeAtariByte);
      }
      return charToScreenCodeAtari;
   }

}
