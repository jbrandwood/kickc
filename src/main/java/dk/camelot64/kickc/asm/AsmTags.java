package dk.camelot64.kickc.asm;

import java.util.ArrayList;
import java.util.List;

/** Tags on AsmLines.
 * <p>
 * Tags are used by the compiler for marking up ASM lines in fragments that the compiler should treat in different ways
 * <p>
 * The syntax for adding tags directly in ASM files is through a comment with a special syntax such as
 **/
public class AsmTags {

   /** The tags. */
   private List<String> tags;

   AsmTags() {
      this.tags = new ArrayList<>();
   }

   /**
    * Add a tag
    *
    * @param The tag to add
    */
   public void add(String tag) {
      tags.add(tag);
   }

   /**
    * Add a tag
    *
    * @param The tag to add
    */
   public boolean has(String tag) {
      return tags.contains(tag);
   }

}
