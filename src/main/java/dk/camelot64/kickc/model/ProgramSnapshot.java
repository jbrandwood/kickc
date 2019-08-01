package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.symbols.ProgramScope;

import java.io.*;

/**
 * A snapshot of all dynamic data in a {@link Program}.
 * Used whenever the compiler need to run an experiment where it may need to roll back to a previous state.
 */
public class ProgramSnapshot {

   /** The main scope. PASS 0-5 (DYNAMIC) */
   private ProgramScope scope;
   /** The control flow graph. PASS 1-5 (DYNAMIC) */
   private ControlFlowGraph graph;

   public ProgramSnapshot(ProgramScope scope, ControlFlowGraph graph) {
      this.scope = snapshot(scope);
      this.graph = snapshot(graph);
   }

   public ProgramScope getScope() {
      return scope;
   }

   public ControlFlowGraph getGraph() {
      return graph;
   }

   /**
    * Creates a deep copy of an object (by using serialization)
    * @param orig The object tot copy
    * @return the copy with zero references to the original
    */
   private static <T extends Object> T snapshot(T orig) {
         if(orig==null) return null;
         T obj = null;
         try {
            // Write the object out to a byte array
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(bos);
            out.writeObject(orig);
            out.flush();
            out.close();
            // Make an input stream from the byte array and read a copy of the object back in.
            ObjectInputStream in = new ObjectInputStream(
                  new ByteArrayInputStream(bos.toByteArray()));
            obj = (T) in.readObject();
         }
         catch(IOException | ClassNotFoundException e) {
            e.printStackTrace();
         }
      return obj;
      }

}
