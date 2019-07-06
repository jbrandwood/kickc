package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmClobber;
import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.VariableVersion;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.values.ScopeRef;
import dk.camelot64.kickc.model.values.Value;
import dk.camelot64.kickc.parser.KickCLexer;
import dk.camelot64.kickc.parser.KickCParser;
import org.antlr.v4.runtime.*;

import java.util.LinkedHashMap;

/**
 * An ASM fragment template usable for generating KickAssembler code for different bindings.
 * The AsmFragmentTemplateSynthesizer can generate multiple different templates usable for a specific fragment signature.
 */
public class AsmFragmentTemplate {

   /** true if the fragment was loaded from disk. */
   private boolean file;
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

   public AsmFragmentTemplate(String signature, String body) {
      this.signature = signature;
      this.body = body;
      this.file = true;
   }

   AsmFragmentTemplate(String signature, String body, AsmFragmentTemplateSynthesisRule synthesis, AsmFragmentTemplate subFragment) {
      this.signature = signature;
      this.body = body;
      this.synthesis = synthesis;
      this.subFragment = subFragment;
      this.file = false;
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
    * Initialize the fields that require parsing the ASM (bodyAsm, clobber, clobber).
    *
    * @return The parsed fragment ready for generating
    */
   private void initAsm() {
      // Parse the body ASM
      CodePointCharStream fragmentCharStream = CharStreams.fromString(body);
      KickCLexer kickCLexer = new KickCLexer(fragmentCharStream);
      KickCParser kickCParser = new KickCParser(new CommonTokenStream(kickCLexer));
      kickCParser.addErrorListener(new BaseErrorListener() {
         @Override
         public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
            throw new RuntimeException("Error parsing fragment " + signature + "\n - Line: " + line + "\n - Message: " + msg);
         }
      });
      kickCParser.setBuildParseTree(true);
      this.bodyAsm = kickCParser.asmFile().asmLines();
      // Generate a dummy instance to find clobber & cycles
      ProgramScope scope = new ProgramScope();
      LinkedHashMap<String, Value> bindings = new LinkedHashMap<>();
      VariableVersion v1 = new VariableVersion("$tmp1", SymbolType.BYTE, null);
      VariableVersion v2 = new VariableVersion("$tmp2", SymbolType.BYTE, null);
      VariableVersion v3 = new VariableVersion("$tmp3", SymbolType.BYTE, null);
      VariableVersion v4 = new VariableVersion("$tmp4", SymbolType.BYTE, null);
      VariableVersion v5 = new VariableVersion("$tmp5", SymbolType.BYTE, null);
      VariableVersion v6 = new VariableVersion("$tmp6", SymbolType.BYTE, null);
      v1.setScope(scope);
      v2.setScope(scope);
      v3.setScope(scope);
      v4.setScope(scope);
      v5.setScope(scope);
      v6.setScope(scope);
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
      if(signature.contains("c1")) bindings.put("c1", new ConstantInteger(10L));
      if(signature.contains("c2")) bindings.put("c2", new ConstantInteger(20L));
      if(signature.contains("c3")) bindings.put("c3", new ConstantInteger(30L));
      if(signature.contains("c4")) bindings.put("c4", new ConstantInteger(40L));
      if(signature.contains("c5")) bindings.put("c5", new ConstantInteger(50L));
      if(signature.contains("c6")) bindings.put("c6", new ConstantInteger(60L));
      if(signature.contains("la1")) bindings.put("la1", new Label("@1", scope, true));
      AsmFragmentInstance fragmentInstance =
            new AsmFragmentInstance(new Program(), signature, ScopeRef.ROOT, this, bindings);
      AsmProgram asm = new AsmProgram();
      asm.startSegment( ScopeRef.ROOT, null, signature);
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
