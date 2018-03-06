package dk.camelot64.kickc.model.values;

/** A literal constant value */
public interface ConstantLiteral<T> extends ConstantValue {

   T getValue();

}
