package dk.camelot64.kickc;

/**
 * Utility functions for working with file names.
 *
 * Terminology
 * <ul>
 * <li>Path: A complete path to a file containing directory, file name and extension.
 * <br>Example <i>/usr/jg/note.txt</i></li>
 * <li>Directory: The part of a file name describing the directory containing the file.
 * <br>Example <i>/usr/jg/</i></li>
 * <li>File name: Part of the path describing the name of the file. The name has a base name and an optional '.' plus an extension.
 * <br>Example <i>note.txt</i></li>
 * <li>Base Name: The file name without any '.' and extension.
 * <br>Example <i>note</i></li>
 * <li>Extension: The extension of the file name. The contents after the last '.' in the file name.
 * <br>Example <i>txt</i></li>
 * </ul>
 */
public class FileNameUtils {

   /**
    * Remove extension from a file name if it is present.
    *
    * @param fileName The file name
    * @return file name without extension
    */
   public static String removeExtension(String fileName) {
      final int lastDotIdx = fileName.lastIndexOf('.');
      final int lastSlashIdx = Math.max(fileName.lastIndexOf('/'), fileName.lastIndexOf('\\'));
      if(lastDotIdx > 0 && lastDotIdx > (lastSlashIdx + 1)) {
         fileName = fileName.substring(0, lastDotIdx);
      }
      return fileName;
   }
   
}
