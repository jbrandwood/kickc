package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;

/**
 * Single Static Assignment Form Statement.
 * Intermediate form used for compiler optimization.
 */
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "@type")
@JsonSubTypes({
      @JsonSubTypes.Type(value = StatementAssignment.class, name = "assign"),
      @JsonSubTypes.Type(value = StatementPhiBlock.class, name = "phiblock"),
      @JsonSubTypes.Type(value = StatementConditionalJump.class, name = "cond"),
      @JsonSubTypes.Type(value = StatementJump.class, name = "jump"),
      @JsonSubTypes.Type(value = StatementLabel.class, name = "label"),
      @JsonSubTypes.Type(value = StatementCall.class, name = "call"),
      @JsonSubTypes.Type(value = StatementReturn.class, name = "return"),
      @JsonSubTypes.Type(value = StatementProcedureBegin.class, name = "procbegin"),
      @JsonSubTypes.Type(value = StatementProcedureEnd.class, name = "procend")
})
public interface Statement {

   String getAsTypedString(ProgramScope scope);

   @JsonIgnore
   String getAsString();

}
