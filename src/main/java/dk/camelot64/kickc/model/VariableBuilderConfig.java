package dk.camelot64.kickc.model;

import dk.camelot64.kickc.CompileLog;
import dk.camelot64.kickc.model.statements.StatementSource;

import java.util.*;

/**
 * Configuration for the {@link VariableBuilder} specifying how different variables should be compiled.
 * Holds settings specified using <code>#pragma var_model(...)</code>
 * The parameters to the pragma has the form <i>scope</i>_<i>type</i>_<i>optimization</i>_<i>memoryarea</i>.
 * <ul>
 *    <li><i>scope</i> is one of <i>global</i>, <i>local</i></li>
 *    <li><i>type</i> is one of <i>struct</i>, <i>array</i>, <i>integer</i>, <i>pointer</i></li>
 *    <li><i>optimization</i> is one of <i>ma</i> (meaning multiple-assignment or load/store), <i>ssa</i> (meaning single-static-assignment)</li>
 *    <li><i>memoryarea</i> is one of <i>zp</i> (meaning zeropage), <i>mem</i> (meaning main memory)</li>
 * </ul>
 * <p>
 * For instance the parameter <i>local_pointer_ssa_zp</i> specifies that local pointer variables must be SSA-optimized and placed on zeropage.
 * The scope or type sub-element of the pragma parameter can be left out to apply to all scopes/types.
 * For instance the parameter <i>pointer_ssa_zp</i> specifies that all pointer variables regardless of scope must be SSA-optimized and placed on zeropage.
 * <p>
 * Multiple parameters can be added to the pragma to apply settings for many types/scopes.
 */
public class VariableBuilderConfig {

   /** The different scopes. */
   public enum Scope {
      LOCAL, GLOBAL, PARAMETER, MEMBER
   }

   /** The different types. */
   public enum Type {
      INTEGER, POINTER, STRUCT, ARRAY
   }

   /** The optimizations. */
   public enum Optimization {
      SSA, MA
   }

   /** The memory areas. */
   public enum MemoryArea {
      ZP, MEM
   }

   /* A single setting. */
   public static class Setting {
      final Scope scope;
      final Type type;
      final MemoryArea memoryArea;
      final Optimization optimization;

      public Setting(Scope scope, Type type, MemoryArea memoryArea, Optimization optimization) {
         this.scope = scope;
         this.type = type;
         this.memoryArea = memoryArea;
         this.optimization = optimization;
      }
   }

   /** Key of the settings map containing scope & type. */
   public static class ScopeType {
      public Scope scope;
      public Type type;

      public ScopeType(Scope scope, Type type) {
         this.scope = scope;
         this.type = type;
      }

      @Override
      public boolean equals(Object o) {
         if(this == o) return true;
         if(o == null || getClass() != o.getClass()) return false;
         ScopeType scopeType = (ScopeType) o;
         return scope == scopeType.scope &&
               type == scopeType.type;
      }

      @Override
      public int hashCode() {
         return Objects.hash(scope, type);
      }
   }

   /**
    * The settings
    */
   private Map<ScopeType, Setting> settings;

   VariableBuilderConfig() {
      this.settings = new HashMap<>();
   }

   public void addSetting(String pragmaParam, CompileLog log, StatementSource statementSource) {
      List<String> paramElements = new ArrayList<>(Arrays.asList(pragmaParam.split("_")));
      List<Scope> scopes = getScopes(paramElements);
      List<Type> types = getTypes(paramElements);
      Optimization optimization = getOptimization(paramElements);
      MemoryArea memoryArea = getMemoryArea(paramElements);
      if(memoryArea == null || optimization == null || paramElements.size() > 0)
         throw new CompileError("Warning: Malformed var_model parameter " + pragmaParam, statementSource);
      for(Scope scope : scopes) {
         for(Type type : types) {
            settings.put(new ScopeType(scope, type), new Setting(scope, type, memoryArea, optimization));
         }
      }
   }

   /**
    * Parses the first parameter element as a scope.
    * If found the scope element is removed from the list.
    *
    * @param paramElements The parameter elements (may be modified)
    * @return The matched scopes
    */
   private List<Scope> getScopes(List<String> paramElements) {
      final String paramElement = paramElements.get(0);
      if(paramElement.equals("global")) {
         paramElements.remove(0);
         return Arrays.asList(Scope.GLOBAL);
      } else if(paramElement.equals("local")) {
         paramElements.remove(0);
         return Arrays.asList(Scope.LOCAL);
      } else if(paramElement.equals("member")) {
         paramElements.remove(0);
         return Arrays.asList(Scope.MEMBER);
      } else if(paramElement.equals("parameter")) {
         paramElements.remove(0);
         return Arrays.asList(Scope.PARAMETER);
      } else
         return Arrays.asList(Scope.values());
   }

   /**
    * Parses the first parameter element as a type.
    * If found the type element is removed from the list.
    *
    * @param paramElements The parameter elements (may be modified)
    * @return The matched types
    */
   private List<Type> getTypes(List<String> paramElements) {
      final String paramElement = paramElements.get(0);
      if(paramElement.equals("integer")) {
         paramElements.remove(0);
         return Arrays.asList(Type.INTEGER);
      } else if(paramElement.equals("pointer")) {
         paramElements.remove(0);
         return Arrays.asList(Type.POINTER);
      } else if(paramElement.equals("array")) {
         paramElements.remove(0);
         return Arrays.asList(Type.ARRAY);
      } else if(paramElement.equals("struct")) {
         paramElements.remove(0);
         return Arrays.asList(Type.STRUCT);
      } else
         return Arrays.asList(Type.values());
   }

   /**
    * Parses the first parameter element as a memory area.
    * The memory area element is removed from the list.
    *
    * @param paramElements The parameter elements (may be modified)
    * @return The matched memory area.
    */
   private MemoryArea getMemoryArea(List<String> paramElements) {
      final String paramElement = paramElements.get(0);
      if(paramElement.equals("mem")) {
         paramElements.remove(0);
         return MemoryArea.MEM;
      } else if(paramElement.equals("zp")) {
         paramElements.remove(0);
         return MemoryArea.ZP;
      } else
         return null;
   }

   /**
    * Parses the first parameter element as a optimization.
    * The optimization element is removed from the list.
    *
    * @param paramElements The parameter elements (may be modified)
    * @return The matched optimization.
    */
   private Optimization getOptimization(List<String> paramElements) {
      final String paramElement = paramElements.get(0);
      if(paramElement.equals("ssa")) {
         paramElements.remove(0);
         return Optimization.SSA;
      } else if(paramElement.equals("ma")) {
         paramElements.remove(0);
         return Optimization.MA;
      } else
         return null;
   }

   /**
    * Get the setting to use for a specific scope/type by default
    *
    * @param scope The scope
    * @param type The type
    * @return The memory area to use
    */
   public Setting getSetting(Scope scope, Type type) {
      return settings.get(new ScopeType(scope, type));
   }

   public static Scope getScope(boolean isScopeGlobal, boolean isScopeLocal, boolean isScopeParameter, boolean isScopeMember) {
      if(isScopeGlobal)
         return Scope.GLOBAL;
      if(isScopeLocal)
         return Scope.LOCAL;
      if(isScopeParameter)
         return Scope.PARAMETER;
      if(isScopeMember)
         return Scope.MEMBER;
      throw new InternalError("Unknown scope!");
   }

   public static Type getType(boolean isTypeInteger, boolean isTypeArray, boolean isTypePointer, boolean isTypeStruct) {
      if(isTypeInteger)
         return Type.INTEGER;
      if(isTypeArray)
         return Type.ARRAY;
      if(isTypePointer)
         return Type.POINTER;
      if(isTypeStruct)
         return Type.STRUCT;
      throw new InternalError("Unknown type!");
   }


}
