package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.fragment.synthesis.AsmFragmentTemplateSynthesizer;
import dk.camelot64.kickc.model.Program;

public class AsmFragmentCodeGenerator {

    /**
     * Generate ASM code for an ASM fragment instance
     *
     * @param asm The ASM program to generate into
     * @param fragmentInstanceSpec The ASM fragment instance specification
     * @param program The program. Used for getting global statics.
     */
    public static void generateAsm(AsmProgram asm, AsmFragmentInstanceSpec fragmentInstanceSpec, Program program) {
       AsmEncodingHelper.ensureEncoding(asm, fragmentInstanceSpec);
       String initialSignature = fragmentInstanceSpec.getSignature();
       AsmFragmentInstance fragmentInstance = null;
       StringBuilder fragmentVariationsTried = new StringBuilder();
       while(fragmentInstance == null) {
          try {
             final AsmFragmentTemplateSynthesizer cpuSynthesizer = program.getAsmFragmentMasterSynthesizer().getSynthesizer(program.getTargetCpu());
             fragmentInstance = cpuSynthesizer.getFragmentInstance(fragmentInstanceSpec, program.getLog());
          } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
             // Unknown fragment - keep looking through alternative ASM fragment instance specs until we have tried them all
             String signature = fragmentInstanceSpec.getSignature();
             fragmentVariationsTried.append(signature).append(" ");
             if(fragmentInstanceSpec.hasNextVariation()) {
                fragmentInstanceSpec.nextVariation();
                if(program.getLog().isVerboseFragmentLog()) {
                   program.getLog().append("Fragment not found " + signature + ". Attempting another variation " + fragmentInstanceSpec.getSignature());
                }
             } else {
                // No more variations available - fail with an error
                throw new AsmFragmentTemplateSynthesizer.UnknownFragmentException("Fragment not found " + initialSignature + ". Attempted variations " + fragmentVariationsTried);
             }
          }
       }
       asm.getCurrentChunk().setFragment(fragmentInstance.getFragmentName());
       fragmentInstance.generate(asm);
    }

}
