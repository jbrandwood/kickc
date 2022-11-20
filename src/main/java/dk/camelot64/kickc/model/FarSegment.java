package dk.camelot64.kickc.model;

/** A far segment. */
public class FarSegment {

   private final String farSegment;
   private Long farBank;
   private final String procedurePrepare;
   private final String procedureExecute;
   private final String procedureFinalize;

   public FarSegment(String name, Long bank, String procedurePrepare, String procedureExecute, String procedureFinalize) {
      this.farSegment = name;
      this.farBank = bank;
      this.procedurePrepare = procedurePrepare;
      this.procedureExecute = procedureExecute;
      this.procedureFinalize = procedureFinalize;
   }

   public String getFarSegment() {
      return farSegment;
   }

   public Long getFarBank() {
      return farBank;
   }

   public void setFarBank(Long farBank) {
      this.farBank = farBank;
   }

   public String getProcedurePrepare() {
      return procedurePrepare;
   }

   public String getProcedureExecute() {
      return procedureExecute;
   }

   public String getProcedureFinalize() {
      return procedureFinalize;
   }
}
