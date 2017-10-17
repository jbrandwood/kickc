package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

/** Any value (variable, constant, label) */
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "@type")
@JsonSubTypes({
      @JsonSubTypes.Type(value = ConstantBool.class, name = "boolean"),
      @JsonSubTypes.Type(value = ConstantInteger.class, name = "integer"),
      @JsonSubTypes.Type(value = ConstantDouble.class, name = "double"),
      @JsonSubTypes.Type(value = ConstantString.class, name = "string"),
      @JsonSubTypes.Type(value = VariableUnversioned.class, name = "variable_unversioned"),
      @JsonSubTypes.Type(value = VariableVersion.class, name = "variable_versioned"),
      @JsonSubTypes.Type(value = VariableIntermediate.class, name = "variable_intermediate"),
      @JsonSubTypes.Type(value = Label.class, name = "label"),
      @JsonSubTypes.Type(value = VariableRef.class, name = "varref"),
      @JsonSubTypes.Type(value = LabelRef.class, name = "labelref"),
      @JsonSubTypes.Type(value = ProcedureRef.class, name = "procref"),
      @JsonSubTypes.Type(value = PointerDereferenceIndexed.class, name = "pointer_indexed"),
      @JsonSubTypes.Type(value = PointerDereferenceSimple.class, name = "pointer_simple"),
      @JsonSubTypes.Type(value = ProgramScope.class, name = "program"),
      @JsonSubTypes.Type(value = Procedure.class, name = "procedure")
      })
public interface Value {

      String toString(Program program);

}
