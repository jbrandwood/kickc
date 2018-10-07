package dk.camelot64.kickc.model.values;

/** A reference to a block introducing a local scope*/
public class BlockScopeRef extends ScopeRef implements RValue {

   public BlockScopeRef(String fullName) {
      super(fullName);
   }

}
