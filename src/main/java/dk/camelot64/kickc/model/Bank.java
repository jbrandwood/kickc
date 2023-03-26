package dk.camelot64.kickc.model;

/** A Bank segment. */
public class Bank {

   private final String bankArea;
   private Long bank;

   public Bank(String bankArea, Long bank) {
      this.bankArea = bankArea;
      this.bank = bank;
   }

   public String getBankArea() {
      return bankArea;
   }

   public Long getBank() {
      return bank;
   }

   public void setBank(Long bank) {
      this.bank = bank;
   }
}
