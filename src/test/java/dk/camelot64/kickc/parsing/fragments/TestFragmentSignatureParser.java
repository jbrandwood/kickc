package dk.camelot64.kickc.parsing.fragments;

import dk.camelot64.kickc.fragment.signature.AsmFragmentSignature;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.MessageFormat;
import java.util.Objects;

public class TestFragmentSignatureParser {

    @Test
    void testSignatureParser() throws IOException {

        final ClassLoader classLoader = getClass().getClassLoader();
        final InputStream fragmentsInputStream = classLoader.getResourceAsStream("dk/camelot64/kickc/parsing/fragments/fragment_signatures.txt");

        final InputStreamReader fragmentsReader = new InputStreamReader(Objects.requireNonNull(fragmentsInputStream));
        try (BufferedReader br = new BufferedReader(fragmentsReader)) {
            int line = 1;
            for (String sigName; (sigName = br.readLine()) != null; ) {
                final AsmFragmentSignature sig = AsmFragmentSignature.parse(sigName);
                System.out.println(MessageFormat.format("Parsing {0}: {1}", line, sigName));
                Assertions.assertNotNull(sig);
                Assertions.assertEquals(sigName, sig.getName());
                line++;
            }
        }
    }


}
