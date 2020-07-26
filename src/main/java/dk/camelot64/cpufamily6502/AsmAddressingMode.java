package dk.camelot64.cpufamily6502;

/** 6502 Family Addressing Modes. */
public enum AsmAddressingMode {

   /**
    * None / Implied / Accumulator
    * IMPLIED ADDRESSING — In the implied addressing mode, the address containing the operand is implicitly stated in
    * the operation code of the instruction.
    * ACCUMULATOR ADDRESSING — This form of addressing is represented with a one byte instruction, implying an operation
    * on the accumulator"
    */
   NON("", "%i", 1),
   /**
    * Immediate
    * IMMEDIATE ADDRESSING — In immediate addressing, the operand is contained in the second byte of the instruction,
    * with no further memory addressing required.
    */
   IMM("#imm", "%i #%p", 2),
   /**
    * Zeropage
    * ZERO PAGE ADDRESSING — The zero page instructions allow for shorter code and execution times by only fetching the
    * second byte of the instruction and assuming a zero high address byte. Careful use of the zero page can result in
    * significant increase in code efficiency.
    */
   ZP("zp", "%i.z %p", 2),
   /**
    * X Indexed Zeropage
    * INDEXED ZERO PAGE ADDRESSING - (X, Y indexing) — This form of addressing is used in conjunction with the index
    * register and is referred to as “Zero Page, X" or "Zero Page, Y.” The effective address is calculated by adding the
    * second byte to the contents of the index register. Since this is a form of "Zero Page" addressing, the content of
    * the second byte references a location in page zero. Additionally, due to the “Zero Page" addressing nature of this
    * mode, no carry is added to the high order 8 bits of memory and crossing of page boundaries does not occur.
    */
   ZPX("zp,x", "%i.z %p,x", 2),
   /**
    * Y Indexed Zeropage
    * INDEXED ZERO PAGE ADDRESSING - (X, Y indexing) — This form of addressing is used in coniunction with the index
    * register and is referred to as “Zero Page, X" or "Zero Page, Y.” The effective address is calculated by adding
    * the second byte to the contents of the index register. Since this is a form of "Zero Page" addressing, the content
    * of the second byte references a location in page zero. Additionally, due to the “Zero Page" addressing nature of
    * this mode, no carry is added to the high order 8 bits of memory and crossing of page boundaries does not occur.
    */
   ZPY("zp,y", "%i.z %p,y", 2),
   /**
    * Absolute
    * ABSOLUTE ADDRESSING — In absolute addressing, the second byte of the instruction specifies the eight low order
    * bits of the effective address while the third byte specifies the eight high order bits. Thus, the absolute
    * addressing mode allows access to the entire 65 K bytes of addressable memory.
    */
   ABS("abs", "%i %p", 3),
   /**
    * Absolute X
    * INDEX ABSOLUTE ADDRESSING — (X, Y indexing) — This form of addressing is used in conjunction with X and Y index
    * register and is referred to as "Absolute. X," and “Absolute. Y." The effective address is formed by adding the
    * contents of X and Y to the address contained in the second and third bytes of the instruction. This mode allows
    * the index register to contain the index or count value and the instruction to contain the base address. This type
    * of indexing allows any location referencing and the index to modify multiple fields resulting in reduced coding
    * and execution time.
    */
   ABX("abs,x", "%i %p,x", 3),
   /**
    * Absolute Y
    * INDEX ABSOLUTE ADDRESSING — (X, Y indexing) — This form of addressing is used in conjunction with X and Y index
    * register and is referred to as "Absolute. X," and “Absolute. Y." The effective address is formed by adding the
    * contents of X and Y to the address contained in the second and third bytes of the instruction. This mode allows the
    * index register to contain the index or count value and the instruction to contain the base address. This type of
    * indexing allows any location referencing and the index to modify multiple fields resulting in reduced coding and
    * execution time.
    */
   ABY("abs,y", "%i %p,y", 4),
   /**
    * Indirect Zeropage X
    * INDEXED INDIRECT ADDRESSING - In indexed indirect addressing (referred to as [Indirect, X]), the second byte of
    * the instruction is added to the contents of the.X index register, discarding the carry. The result of this
    * addition points to a memory
    * location on page zero whose contents is the low order eight bits of the effective address. The next memory
    * location in page zero contains the high order eight bits of the effective address. Both memory locations
    * specifying the high and low order bytes of the effective address must be in page zero."
    */
   IZX("(zp,x)", "%i (%p,x)", 2),
   /**
    * Indirect Zeropage Y
    * INDIRECT INDEXED ADDRESSING — In indirect indexed addressing (referred to as (Indirect, Y]), the second byte of
    * the instruction points to a memory location in page zero. The contents of this memory location is added to the
    * contents of the Y index register, the result being the low order eight bits of the effective
    * address. The carry from this addition is added to the contents of the next page zero memory location, the result
    * being the high order eight bits of the effective address."
    */
   IZY("(zp),y", "%i (%p),y", 2),
   /**
    * Relative
    * RELATIVE ADDRESSING — Relative addressing is used only with branch instructions and establishes a destination for
    * the conditional branch. The second byte of-the instruction becomes the operand which is an “Offset"" added to the
    * contents of the lower eight bits of the program counter when the counter is set at the next instruction. The range
    * of the offset is — 128 to + 127 bytes from the next instruction."
    */
   REL("rel", "%i %p", 2),
   /**
    * Indirect Absolute
    * ABSOLUTE INDIRECT — The second byte of the instruction contains the low order eight bits of a memory location.
    * The high order eight bits of that memory location is contained in the third byte of the instruction.
    * The contents of the fully specified memory location is the low order byte of the effective address.
    * The next memory location contains the high order byte of the effective address which is loaded into the sixteen
    * bits of the program counter.
    */
   IND("(ind)", "%i (%p)", 3);

   /** The short name of the addressing mode. */
   private String name;

   /** The template for an instruction using the addressing mode. */
   private String template;

   /** The number of bytes that an instruction takes up when using the addressing mode. This includes both opcode and operands. */
   private int bytes;

   AsmAddressingMode(String name, String template, int bytes) {
      this.bytes = bytes;
      this.template = template;
      this.name = name;
   }

   public int getBytes() {
      return bytes;
   }

   public String getName() {
      return name;
   }

   public String getAsm(String mnemnonic, String parameter) {
      String replaced = template.replace("%i", mnemnonic);
      if(parameter != null) {
         replaced = replaced.replace("%p", parameter);
      }
      return replaced;
   }

}
