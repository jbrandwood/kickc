package dk.camelot64.kickc.fragment;

import dk.camelot64.kickc.asm.AsmProgram;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Graph;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.ConstantChar;
import dk.camelot64.kickc.model.values.ConstantString;
import dk.camelot64.kickc.model.values.StringEncoding;
import dk.camelot64.kickc.model.values.Value;

import java.util.LinkedHashSet;
import java.util.ListIterator;
import java.util.Map;
import java.util.Set;

public class AsmEncodingHelper {

    /**
     * Ensure that the current encoding in the ASM matches any encoding in the data to be emitted
     *
     * @param asm The ASM program (where any .encoding directive will be emitted)
     * @param asmFragmentInstance The ASM fragment to be emitted
     */
    static void ensureEncoding(AsmProgram asm, AsmFragmentInstanceSpec asmFragmentInstance) {
       asm.ensureEncoding(getEncoding(asmFragmentInstance));
    }

    public static void ensureEncoding(AsmProgram asm, Value value) {
       asm.ensureEncoding(getEncoding(value));
    }

    /**
     * Examine a constantvalue to see if any string encoding information is present
     *
     * @param value The constant to examine
     * @return Any encoding found inside the constant
     */
    public static Set<StringEncoding> getEncoding(Value value) {
       LinkedHashSet<StringEncoding> encodings = new LinkedHashSet<>();
       ProgramValue programValue = new ProgramValue.GenericValue(value);
       ProgramValueHandler handler = (ProgramValue pVal, Statement currentStmt, ListIterator<Statement> stmtIt, Graph.Block currentBlock) -> {
          Value val = pVal.get();
          if(val instanceof ConstantChar) {
             encodings.add(((ConstantChar) val).getEncoding());
          } else if(val instanceof ConstantString) {
             encodings.add(((ConstantString) val).getEncoding());
          }
       };
       ProgramValueIterator.execute(programValue, handler, null, null, null);
       return encodings;
    }

    /**
     * Examine an ASM fragment to see if any string encoding information is present
     *
     * @param asmFragmentInstance The asm fragment instance to examine
     * @return Any encoding found inside the constant
     */
    private static Set<StringEncoding> getEncoding(AsmFragmentInstanceSpec asmFragmentInstance) {
       LinkedHashSet<StringEncoding> encodings = new LinkedHashSet<>();
       Map<String, Value> bindings = asmFragmentInstance.getBindings();
       for(Value boundValue : bindings.values()) {
          encodings.addAll(getEncoding(boundValue));
       }
       return encodings;
    }
}
