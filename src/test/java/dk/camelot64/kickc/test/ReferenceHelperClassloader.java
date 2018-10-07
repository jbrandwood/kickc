package dk.camelot64.kickc.test;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

/**
 * Test refefence helper loading reference files using the class loader.
 */
public class ReferenceHelperClassloader extends ReferenceHelper {

   /** The sub-path / package to look for reference files in. */
   private String refPath;


   public ReferenceHelperClassloader(String refPath) {
      this.refPath = refPath;
   }

   URI loadReferenceFile(String fileName, String extension) throws URISyntaxException {
      String refFile = refPath + fileName + extension;
      ClassLoader classLoader = this.getClass().getClassLoader();
      URL refResource = classLoader.getResource(refFile);
      return refResource.toURI();
   }


}
