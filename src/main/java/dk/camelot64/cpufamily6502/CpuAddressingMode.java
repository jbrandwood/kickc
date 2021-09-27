package dk.camelot64.cpufamily6502;

/** 6502 Family Addressing Modes. */
public enum CpuAddressingMode {

   /**
    * None / Implied / Accumulator
    * IMPLIED ADDRESSING — In the implied addressing mode, the address containing the operand is implicitly stated in
    * the operation code of the instruction.
    * ACCUMULATOR ADDRESSING — This form of addressing is represented with a one byte instruction, implying an operation
    * on the accumulator"
    */
   NON("", "%i", 0),

   /**
    * #imm Immediate <br>
    * IMMEDIATE ADDRESSING — In immediate addressing, the operand is contained in the second byte of the instruction,
    * with no further memory addressing required.
    */
   IMM("#imm", "%i #%p", 1),

   /**
    * zp Zeropage <br>
    * ZERO PAGE ADDRESSING — The zero page instructions allow for shorter code and execution times by only fetching the
    * second byte of the instruction and assuming a zero high address byte. Careful use of the zero page can result in
    * significant increase in code efficiency.
    */
   ZP("zp", "%i.z %p", 1),

   /**
    * zp,x X Indexed Zeropage <br>
    * INDEXED ZERO PAGE ADDRESSING - (X, Y indexing) — This form of addressing is used in conjunction with the index
    * register and is referred to as “Zero Page, X" or "Zero Page, Y.” The effective address is calculated by adding the
    * second byte to the contents of the index register. Since this is a form of "Zero Page" addressing, the content of
    * the second byte references a location in page zero. Additionally, due to the “Zero Page" addressing nature of this
    * mode, no carry is added to the high order 8 bits of memory and crossing of page boundaries does not occur.
    */
   ZPX("zp,x", "%i.z %p,x", 1),

   /**
    * zp,y Y Indexed Zeropage <br>
    * INDEXED ZERO PAGE ADDRESSING - (X, Y indexing) — This form of addressing is used in coniunction with the index
    * register and is referred to as “Zero Page, X" or "Zero Page, Y.” The effective address is calculated by adding
    * the second byte to the contents of the index register. Since this is a form of "Zero Page" addressing, the content
    * of the second byte references a location in page zero. Additionally, due to the “Zero Page" addressing nature of
    * this mode, no carry is added to the high order 8 bits of memory and crossing of page boundaries does not occur.
    */
   ZPY("zp,y", "%i.z %p,y", 1),

   /**
    * abs Absolute <br>
    * ABSOLUTE ADDRESSING — In absolute addressing, the second byte of the instruction specifies the eight low order
    * bits of the effective address while the third byte specifies the eight high order bits. Thus, the absolute
    * addressing mode allows access to the entire 65 K bytes of addressable memory.
    */
   ABS("abs", "%i %p", 2),

   /**
    * abs,x Absolute X <br>
    * INDEX ABSOLUTE ADDRESSING — (X, Y indexing) — This form of addressing is used in conjunction with X and Y index
    * register and is referred to as "Absolute. X," and “Absolute. Y." The effective address is formed by adding the
    * contents of X and Y to the address contained in the second and third bytes of the instruction. This mode allows
    * the index register to contain the index or count value and the instruction to contain the base address. This type
    * of indexing allows any location referencing and the index to modify multiple fields resulting in reduced coding
    * and execution time.
    */
   ABX("abs,x", "%i %p,x", 2),

   /**
    * abs,y Absolute Y <br>
    * INDEX ABSOLUTE ADDRESSING — (X, Y indexing) — This form of addressing is used in conjunction with X and Y index
    * register and is referred to as "Absolute. X," and “Absolute. Y." The effective address is formed by adding the
    * contents of X and Y to the address contained in the second and third bytes of the instruction. This mode allows the
    * index register to contain the index or count value and the instruction to contain the base address. This type of
    * indexing allows any location referencing and the index to modify multiple fields resulting in reduced coding and
    * execution time.
    */
   ABY("abs,y", "%i %p,y", 2),

   /**
    * (zp,x) Indirect Zeropage X <br>
    * INDEXED INDIRECT ZEROPAGE ADDRESSING - In indexed indirect addressing (referred to as (Indirect, X)), the second byte of
    * the instruction is added to the contents of the.X index register, discarding the carry. The result of this
    * addition points to a memory
    * location on page zero whose contents is the low order eight bits of the effective address. The next memory
    * location in page zero contains the high order eight bits of the effective address. Both memory locations
    * specifying the high and low order bytes of the effective address must be in page zero."
    */
   IZX("(zp,x)", "%i (%p,x)", 1),

   /**
    * (abs,x) Indirect Absolute X <br>
    * "ABSOLUTE INDEXED INDIRECT
    * With the Absolute Indexed Indirect addressing mode, the X Index Register is added to the second and third bytes of
    * the instruction to form an address to a pointer. This address mode is only used with the JMP/JSR instruction and the
    * program Counter is loaded with the first and second bytes at this pointer."
    */
   IAX("(abs,x)", "%i (%p,x)", 2),

   /**
    * (zp),y Indirect Zeropage Y
    * INDIRECT INDEXED ADDRESSING — In indirect indexed addressing (referred to as (Indirect),Y ), the second byte of
    * the instruction points to a memory location in page zero. The contents of this memory location is added to the
    * contents of the Y index register, the result being the low order eight bits of the effective
    * address. The carry from this addition is added to the contents of the next page zero memory location, the result
    * being the high order eight bits of the effective address."
    */
   IZY("(zp),y", "%i (%p),y", 1),

   /**
    * (zp),z Indirect Zeropage Z <br>
    * INDIRECT INDEXED ADDRESSING — In indirect indexed addressing (referred to as (Indirect),Z ), the second byte of
    * the instruction points to a memory location in page zero. The contents of this memory location is added to the
    * contents of the Y index register, the result being the low order eight bits of the effective
    * address. The carry from this addition is added to the contents of the next page zero memory location, the result
    * being the high order eight bits of the effective address."
    */
   IZZ("(zp),z", "%i (%p),z", 1),

   /**
    * (abs) Indirect Absolute <br>
    * ABSOLUTE INDIRECT — The second byte of the instruction contains the low order eight bits of a memory location.
    * The high order eight bits of that memory location is contained in the third byte of the instruction.
    * The contents of the fully specified memory location is the low order byte of the effective address.
    * The next memory location contains the high order byte of the effective address which is loaded into the sixteen
    * bits of the program counter.
    */
   IND("(abs)", "%i (%p)", 2),

   /**
    * (zp) Indirect Zeropage <br>
    * ZEROPAGE INDIRECT
    * The second byte of the instruction contains address of a zeropage memory location.
    */
   INZ("(zp)", "%i (%p)", 1),

   /**
    * ((zp)) 32-bit Indirect Zeropage <br>
    * 32BIT ZEROPAGE INDIRECT ADDRESSING
    * In indirect addressing the second byte of the instruction points to a memory location in page zero. This mode is
    * formed by preceding a Base Page Indirect Mode instruction with NEG NEG NOP instructions.
    */
   LIN("((zp))", "%i ((%p))", 1),

   /**
    * ((zp)),z 32-bit Indirect Zeropage Z <br>
    * 32BIT INDIRECT INDEXED ADDRESSING
    * In indirect indexed addressing the second byte of the instruction points to a memory location in page zero. This
    * mode is formed by preceding a Base Page Indirect Z-Indexed Mode instruction with the NOP instruction (opcode $EA).
    */
   LIZ("((zp)),z", "%i ((%p)),z", 1),

   /**
    * (zp,sp),y Stack Pointer Indirect Indexed <br>
    * STACK POINTER INDIRECT INDEXED - This new mode is similar to indirect indexed addressing. The Stack replaces
    * the Base Page and the second instruction byte specifies the displacement from the current stack pointer location
    * rather than the location within Base Page. The contents of this displaced stack location are added to the contents
    * of the Y index register, the result becomes the low order eight bits ot the effective address. The carry from this
    * addition is added to the contents of the next (D -1) stack location the result being the high order eight bits of
    * the effective address."	STA ($12,SP),Y
    */
   ISY("(zp,sp),y", "%i (%p,sp),y", 1),

   /**
    * Relative <br>
    * RELATIVE ADDRESSING — Relative addressing is used only with branch instructions and establishes a destination for
    * the conditional branch. The second byte of-the instruction becomes the operand which is an “Offset"" added to the
    * contents of the lower eight bits of the program counter when the counter is set at the next instruction. The range
    * of the offset is — 128 to + 127 bytes from the next instruction."
    */
   REL("rel", "%i %p", 1),

   /**
    * zp,rel Zeropage Test Relative
    * ZEROPAGE TEST RELATIVE. It needs two one-byte operands, one for the zero page address that is used for the bit
    * test, and one indicating the signed relative PC offset if the branch is taken. This makes BBRi and BBSi the single
    * instructions with two explicit operands.
    */
   REZ("zp,rel", "%i %p,%q", 2);

   /** The short name of the addressing mode. */
   private String name;

   /** The template for an instruction using the addressing mode. */
   private String template;

   /**
    * The number of bytes that the operands of the instruction uses. This does not include the bytes used by the opcode.
    * TODO: This does not take into account word-relative branches and immediate word*/
   private int bytes;

   CpuAddressingMode(String name, String template, int bytes) {
      this.bytes = bytes;
      this.template = template;
      this.name = name;
   }

   /**
    * Get the number of bytes that the operands of the instruction uses. This does not include the bytes used by the opcode.
    * NOTE: This misreports number of bytes for instructions that use immediate word or long relative.
    * TODO: This does not take into account word-relative branches and immediate word
    * @return The number of bytes.
    */
   public int getBytes() {
      return bytes;
   }

   public String getName() {
      return name;
   }

   /**
    * Get the printed ASM code for the instruction with an operand value.
    * This prints to the syntax that KickAssembler expects.
    *
    * @param mnemnonic The opcode mnemonic
    * @param operand The operand value. Null if addressing mode is Implied/A/None
    * @param operand2 The second operand value (only used for addressing mode Zeropage Test Relative)
    * @return The printed ASM code for the instruction
    */
   public String getAsm(String mnemnonic, String operand, String operand2) {
      String replaced = template.replace("%i", mnemnonic);
      if(operand != null) {
         replaced = replaced.replace("%p", operand);
      }
      if(operand2 != null) {
         replaced = replaced.replace("%q", operand2);
      }
      return replaced;
   }

}
