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

   static {
      charToAtascii = CharToPetsciiConverter.charToAscii;
      charToScreenCodeAtari = new HashMap<>();
      for(Character atasciiChar : charToAtascii.keySet()) {
         final Byte atasciiByte = charToAtascii.get(atasciiChar);
         Byte screencodeAtariByte;
         if(atasciiByte >= 0 && atasciiByte <= 31)
            screencodeAtariByte = (byte) (atasciiByte + 64);
         else if(atasciiByte >= 32 && atasciiByte <= 96)
            screencodeAtariByte = (byte) (atasciiByte - 32);
         else
            screencodeAtariByte = atasciiByte;
         charToScreenCodeAtari.put(atasciiChar, screencodeAtariByte);
      }
   }

}
