package dk.camelot64.kickc.test;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Path;

/**
 * Test reference helper loading reference files from a folder.
 */
public class ReferenceHelperFolder extends ReferenceHelper {

   /** The path of the folder containing the reference files. */
   private String folder;

   public ReferenceHelperFolder(String folder) {
      this.folder = folder;
   }

   URI loadReferenceFile(String fileName, String extension) throws IOException {
      String filePath = folder + fileName + extension;
      //System.out.println("Looking for ref "+filePath);
      File file = new File(filePath);
      if(!file.exists()) {
         throw new IOException("Not found "+filePath);
      }
      return file.toURI();
   }


}
