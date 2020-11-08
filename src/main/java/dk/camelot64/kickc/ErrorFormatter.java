package dk.camelot64.kickc;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.statements.StatementSource;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Formats a CompileError using the GCC format, so that it may be easily parsed by IDEs and automated tools.
 */
public class ErrorFormatter {
   public ErrorFormatter() {
   }

   public String formatError(CompileError e) {
      StatementSource source = e.getSource();
      if (source != null) {
         Path currentPath = new File(".").toPath().toAbsolutePath();
         Path sourcePath = Paths.get(source.getFileName());
         Path relativePath = currentPath.relativize(sourcePath);
         return String.format("%s:%s:%s: error: %s", relativePath.toString(), source.getLineNumber(), source.getStartIndex(), e.getMessage());
      } else {
         // Cannot determine the location of the error, just print it directly.
         return e.getMessage();
      }
   }
}
