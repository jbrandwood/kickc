package dk.camelot64.kickc.icl;

/** SSA form constant value */
public interface Constant extends RValue {

   SymbolType getType(ProgramScope scope);

}
