package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.Registers;
import dk.camelot64.kickc.model.statements.StatementSource;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.SymbolVariable;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.parser.AsmParser;
import dk.camelot64.kickc.parser.KickCParser;

import java.util.LinkedHashMap;

/**
 * An ASM fragment template usable for generating KickAssembler code for different bindings.
 * The AsmFragmentTemplateSynthesizer can generate multiple different templates usable for a specific fragment signature.
 */
public class AsmFragmentTemplate {

   /** true if the fragment was loaded from disk. */
   private boolean file;
   /** true if the fragment was loaded from the disk cache. */
   private boolean cache;
   /** The fragment template signature name. */
   private String signature;
   /** The fragment template body */
   private String body;
   /** The synthesis that created the fragment. null if the fragment template was loaded. */
   private AsmFragmentTemplateSynthesisRule synthesis;
   /** The sub fragment template that the synthesis modified to create this. null if the fragment template was loaded. */
   private AsmFragmentTemplate subFragment;

   /** The parsed ASM lines. Initially null. Will be non-null, is the template is ever used to generate ASM code. */
   private KickCParser.AsmLinesContext bodyAsm;
   /** The ASM clobber of the fragment. */
   private AsmFragmentClobber clobber;
   /** The cycles consumed by the ASM of the fragment. */
   private Double cycles;

   public AsmFragmentTemplate(String signature, String body, boolean cache) {
      this.signature = signature;
      this.body = body;
      this.file = true;
      this.cache = cache;
   }

   AsmFragmentTemplate(String signature, String body, AsmFragmentTemplateSynthesisRule synthesis, AsmFragmentTemplate subFragment) {
      this.signature = signature;
      this.body = body;
      this.synthesis = synthesis;
      this.subFragment = subFragment;
      this.file = false;
      this.cache = false;
   }

   /**
    * Creates an inline ASM fragment template
    *
    * @param bodyLines Parsed ASM body
    */
   public AsmFragmentTemplate(KickCParser.AsmLinesContext bodyLines) {
      this.signature = "--inline--";
      this.bodyAsm = bodyLines;
   }

   /**
    * Initialize the fields that require parsing the ASM (bodyAsm, clobber, cycles).
    *
    * @return The parsed fragment ready for generating
    */
   private void initAsm() {
      // Parse the body ASM
      this.bodyAsm = AsmParser.parseAsm(this.body, new StatementSource(signature+".asm", 1, this.body, 0, 0));
      // Generate a dummy instance to find clobber & cycles
      ProgramScope scope = new ProgramScope();
      LinkedHashMap<String, Value> bindings = new LinkedHashMap<>();
      {
         Variable v1 = new Variable("z1", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         Variable v2 = new Variable("z2", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         Variable v3 = new Variable("z3", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         Variable v4 = new Variable("z4", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         Variable v5 = new Variable("z5", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         Variable v6 = new Variable("z6", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.PHI_VERSION);
         v1.setAllocation(new Registers.RegisterZpByte(2));
         v2.setAllocation(new Registers.RegisterZpByte(4));
         v3.setAllocation(new Registers.RegisterZpByte(6));
         v4.setAllocation(new Registers.RegisterZpByte(8));
         v5.setAllocation(new Registers.RegisterZpByte(9));
         v6.setAllocation(new Registers.RegisterZpByte(10));
         if(signature.contains("z1")) bindings.put("z1", v1);
         if(signature.contains("z2")) bindings.put("z2", v2);
         if(signature.contains("z3")) bindings.put("z3", v3);
         if(signature.contains("z4")) bindings.put("z4", v4);
         if(signature.contains("z5")) bindings.put("z5", v5);
         if(signature.contains("z6")) bindings.put("z6", v6);
      }
      {
         Variable v1 = new Variable("m1", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         Variable v2 = new Variable("m2", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         Variable v3 = new Variable("m3", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         Variable v4 = new Variable("m4", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         Variable v5 = new Variable("m5", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         Variable v6 = new Variable("m6", scope, SymbolType.BYTE, null, SymbolVariable.StorageStrategy.MEMORY);
         v1.setAllocation(new Registers.RegisterMemory());
         v2.setAllocation(new Registers.RegisterMemory());
         v3.setAllocation(new Registers.RegisterMemory());
         v4.setAllocation(new Registers.RegisterMemory());
         v5.setAllocation(new Registers.RegisterMemory());
         v6.setAllocation(new Registers.RegisterMemory());
         if(signature.contains("m1")) bindings.put("m1", v1);
         if(signature.contains("m2")) bindings.put("m2", v2);
         if(signature.contains("m3")) bindings.put("m3", v3);
         if(signature.contains("m4")) bindings.put("m4", v4);
         if(signature.contains("m5")) bindings.put("m5", v5);
         if(signature.contains("m6")) bindings.put("m6", v6);
      }
      if(signature.contains("c1")) bindings.put("c1", new ConstantInteger(310L));
      if(signature.contains("c2")) bindings.put("c2", new ConstantInteger(320L));
      if(signature.contains("c3")) bindings.put("c3", new ConstantInteger(330L));
      if(signature.contains("c4")) bindings.put("c4", new ConstantInteger(340L));
      if(signature.contains("c5")) bindings.put("c5", new ConstantInteger(350L));
      if(signature.contains("c6")) bindings.put("c6", new ConstantInteger(360L));
      if(signature.contains("la1")) bindings.put("la1", new Label("@1", scope, true));
      AsmFragmentInstance fragmentInstance =
            new AsmFragmentInstance(new Program(), signature, ScopeRef.ROOT, this, bindings);
      AsmProgram asm = new AsmProgram();
      asm.startChunk(ScopeRef.ROOT, null, signature);
      fragmentInstance.generate(asm);
      AsmClobber asmClobber = asm.getClobber();
      this.clobber = new AsmFragmentClobber(asmClobber);
      this.cycles = asm.getCycles();
   }

   public String getSignature() {
      return signature;
   }

   public String getBody() {
      return body;
   }

   public KickCParser.AsmLinesContext getBodyAsm() {
      if(bodyAsm == null) {
         initAsm();
      }
      return bodyAsm;
   }

   public AsmFragmentClobber getClobber() {
      if(clobber == null) {
         initAsm();
      }
      return clobber;
   }

   public double getCycles() {
      if(cycles == null) {
         initAsm();
      }
      return cycles;
   }

   public boolean isFile() {
      return file;
   }

   public boolean isCache() {
      return cache;
   }

   public AsmFragmentTemplateSynthesisRule getSynthesis() {
      return synthesis;
   }

   public AsmFragmentTemplate getSubFragment() {
      return subFragment;
   }

   public String getName() {
      StringBuilder name = new StringBuilder();
      name.append(signature);
      if(synthesis != null) {
         name.append(" < ");
         name.append(subFragment.getName());
      }
      return name.toString();
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      AsmFragmentTemplate that = (AsmFragmentTemplate) o;
      return getName().equals(that.getName());
   }

   @Override
   public int hashCode() {
      return getName().hashCode();
   }

}
