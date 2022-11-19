package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.Procedure;

import java.util.List;

/** A far segment. */
public class FarSegment {

   private String name;
   private Integer bank;
   private String call_prepare;
   private String call_execute;
   private String call_finalize;

   public FarSegment(String name, Integer bank, String call_prepare, String call_execute, String call_finalize) {
      this.name = name;
      this.bank = bank;
      this.call_prepare = call_prepare;
      this.call_execute = call_execute;
      this.call_finalize = call_finalize;
   }

   public String getName() {
      return name;
   }


   public Integer getBank() {
      return bank;
   }
}
