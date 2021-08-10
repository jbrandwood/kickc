package dk.camelot64.kickc.test;

import dk.camelot64.kickc.model.symbols.ArraySpec;
import dk.camelot64.kickc.model.symbols.ProgramScope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.ConstantInteger;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.Arrays;

/// Test correct printing of types in legal C declaration format
/// https://cdecl.org
public class testTypeCDecl {

   @Test
   void testTypes() {
      Assertions.assertEquals("char",SymbolType.BYTE.toCDecl());
      Assertions.assertEquals("signed char",SymbolType.SBYTE.toCDecl());
      Assertions.assertEquals("int",SymbolType.SWORD.toCDecl());
      Assertions.assertEquals("unsigned int",SymbolType.WORD.toCDecl());
      Assertions.assertEquals("long",SymbolType.SDWORD.toCDecl());
      Assertions.assertEquals("unsigned long",SymbolType.DWORD.toCDecl());
      Assertions.assertEquals("long",SymbolType.SDWORD.toCDecl());
      Assertions.assertEquals("bool",SymbolType.BOOLEAN.toCDecl());
      Assertions.assertEquals("number",SymbolType.NUMBER.toCDecl());
      Assertions.assertEquals("snumber",SymbolType.SNUMBER.toCDecl());
      Assertions.assertEquals("unumber",SymbolType.UNUMBER.toCDecl());
      Assertions.assertEquals("volatile char", SymbolType.BYTE.getQualified(true, false).toCDecl());
      Assertions.assertEquals("char *",new SymbolTypePointer(SymbolType.BYTE).toCDecl());
      Assertions.assertEquals("int *",new SymbolTypePointer(SymbolType.SWORD).toCDecl());
      Assertions.assertEquals("unsigned long **",new SymbolTypePointer(new SymbolTypePointer(SymbolType.DWORD)).toCDecl());
   }

   @Test
   void testSimple() {
      assertCDecl("char x", "x", SymbolType.BYTE);
      assertCDecl("signed char x", "x", SymbolType.SBYTE);
      assertCDecl("volatile char x", "x", SymbolType.BYTE.getQualified(true, false));
      assertCDecl("const int x", "x", SymbolType.SWORD.getQualified(false, true));
      assertCDecl("volatile const unsigned long qwe", "qwe", SymbolType.DWORD.getQualified(true, true));
   }

   @Test
   void testSpecial() {
      assertCDecl("number x", "x", SymbolType.NUMBER);
      assertCDecl("snumber x", "x", SymbolType.SNUMBER);
      assertCDecl("bool x", "x", SymbolType.BOOLEAN);
      assertCDecl("var x", "x", SymbolType.VAR);
      assertCDecl("void x", "x", SymbolType.VOID);
   }

   @Test
   void testPointerVar() {
      assertCDecl("char *ptr", "ptr", new SymbolTypePointer(SymbolType.BYTE));
      assertCDecl("void *ptr", "ptr", new SymbolTypePointer(SymbolType.VOID));
      assertCDecl("volatile unsigned int * const ptr", "ptr", new SymbolTypePointer(SymbolType.WORD.getQualified(true, false)).getQualified(false, true));
      assertCDecl("volatile char * volatile * volatile ptr", "ptr", new SymbolTypePointer(new SymbolTypePointer(SymbolType.BYTE.getQualified(true, false)).getQualified(true, false)).getQualified(true, false));
   }

   @Test
   void testArray() {
      assertCDecl("char NUM[5]", "NUM", new SymbolTypePointer(SymbolType.BYTE, new ArraySpec(new ConstantInteger(5L)), false, false));
      assertCDecl("int BOARD[8][8]", "BOARD", new SymbolTypePointer(new SymbolTypePointer(SymbolType.SWORD, new ArraySpec(new ConstantInteger(8L)), false, false), new ArraySpec(new ConstantInteger(8L)), false, false));
      assertCDecl("long * const ls[7]", "ls", new SymbolTypePointer(new SymbolTypePointer(SymbolType.SDWORD, null, false, true), new ArraySpec(new ConstantInteger(7L)), false, false));
      assertCDecl("char (* volatile x[2])[3]", "x", new SymbolTypePointer(new SymbolTypePointer(new SymbolTypePointer(SymbolType.BYTE, new ArraySpec(new ConstantInteger(3L)), false, false), null, true, false), new ArraySpec(new ConstantInteger(2L)), false, false));
   }

   @Test
   void testStructUnionEnum() {
      assertCDecl("struct Point p", "p", new SymbolTypeStruct("Point", false, 4, false, false));
      assertCDecl("struct Point *ptr", "ptr", new SymbolTypePointer(new SymbolTypeStruct("Point", false, 4, false, false)));
      assertCDecl("const union IPV4 ip", "ip", new SymbolTypeStruct("IPV4", true, 4, false, true));
      assertCDecl("struct Point * const ptr", "ptr", new SymbolTypePointer(new SymbolTypeStruct("Point", false, 4, false, false)).getQualified(false, true));
      assertCDecl("struct Point points[9]", "points", new SymbolTypePointer(new SymbolTypeStruct("Point", false, 4, false, false), new ArraySpec(new ConstantInteger(9l)), false, false) );
      assertCDecl("enum SUIT suit", "suit", new SymbolTypeEnum("SUIT",  false, false));
   }

   @Test
   void testProcedure() {
      assertCDecl("char fn(char)", "fn", new SymbolTypeProcedure(SymbolType.BYTE, Arrays.asList(SymbolType.BYTE)));
      assertCDecl("void (*fn)(void)", "fn", new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.VOID, Arrays.asList(SymbolType.VOID))));
      assertCDecl("char (*fn)(long, int)", "fn", new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.BYTE, Arrays.asList(SymbolType.SDWORD, SymbolType.SWORD))));
      assertCDecl("char (FUNCS[3])(void)", "FUNCS", new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.BYTE, Arrays.asList(SymbolType.VOID)), new ArraySpec(new ConstantInteger(3l)), false, false));
      assertCDecl("void (*transform)(char (*)(char))", "transform", new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.VOID, Arrays.asList(new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.BYTE, Arrays.asList(SymbolType.BYTE)))))));
      assertCDecl("void (*(*getfn)(char))(void)", "getfn", new SymbolTypePointer(new SymbolTypeProcedure(new SymbolTypePointer(new SymbolTypeProcedure(SymbolType.VOID, Arrays.asList(SymbolType.VOID))), Arrays.asList(SymbolType.BYTE))));
   }

   private void assertCDecl(String cdecl, String name, SymbolType type) {
      ProgramScope scope = new ProgramScope();
      Variable var = scope.add(new Variable(name, Variable.Kind.LOAD_STORE, type, scope, Variable.MemoryArea.MAIN_MEMORY, "Data", null));
      Assertions.assertEquals(cdecl, var.toCDecl());
   }

}
