package dk.camelot64.kickc.model;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

/** Symbol Types */
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "@type")
@JsonSubTypes({
      @JsonSubTypes.Type(value = SymbolTypeProgram.class, name = "program"),
      @JsonSubTypes.Type(value = SymbolTypeBasic.class, name = "basic"),
      @JsonSubTypes.Type(value = SymbolTypeArray.class, name = "array"),
      @JsonSubTypes.Type(value = SymbolTypePointer.class, name = "pointer"),
      @JsonSubTypes.Type(value = SymbolTypeProcedure.class, name = "procedure")
})
public interface SymbolType {
   public String getTypeName();

}
