package dk.camelot64.kickc.model.jackson;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.Module;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;

/** Factory for Jackson JSON serialization of the KickC ICL */
public class IclJacksonFactory {

   private static ObjectMapper mapper;
   private static Module module;

   static {
      mapper = new ObjectMapper();
      mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, true);
      mapper.setSerializationInclusion(JsonInclude.Include.ALWAYS);
      mapper.setVisibility(PropertyAccessor.FIELD, JsonAutoDetect.Visibility.ANY);
      SimpleModule jsonModule = new SimpleModule("KickC ICL Types");
      module = jsonModule;
      mapper.registerModule(jsonModule);
   }


   /** Get an ObjectMapper usable for serializing/deserializing KickC ICL to/from JSON */
   public static ObjectMapper getMapper() {
      return mapper;
   }


   /** Get a Jackson Module usable for serializing/deserializing KickC ICL to/from JSON */
   public static Module getModule() {
      return module;
   }

}
