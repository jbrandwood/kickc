package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.fragment.*;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.calcs.PassNCalcVariableReferenceInfos;

import java.io.File;
import java.util.*;

/**
 * Code Generation of 6502 Assembler from ICL/SSA Control Flow Graph
 */
public class Pass4CodeGeneration {

   /** Should the generated ASM contain verbose alive info for the statements (costs a bit more to generate). */
   boolean verboseAliveInfo;

   /** Missing fragments produce a warning instead of an error. */
   boolean warnFragmentMissing;

   /** The program being generated. */
   private Program program;

   /**
    * Keeps track of the phi transitions into blocks during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    * Maps to-blocks to the transition information for the block
    */
   private Map<PhiTransitions.PhiTransition, Boolean> transitionsGenerated = new LinkedHashMap<>();

   /** The current encoding used for printing strings. */
   private ConstantString.Encoding currentEncoding = ConstantString.Encoding.SCREENCODE_MIXED;

   /**
    * Determines if a phi-transition has already been code-generated
    *
    * @param transition The transition to examine
    * @return true if it has already been generated
    */
   private boolean transitionIsGenerated(PhiTransitions.PhiTransition transition) {
      return Boolean.TRUE.equals(transitionsGenerated.get(transition));
   }

   /**
    * Mark a Phi transition as generated
    *
    * @param transition The transition
    */
   private void transitionSetGenerated(PhiTransitions.PhiTransition transition) {
      transitionsGenerated.put(transition, Boolean.TRUE);
   }

   public Pass4CodeGeneration(Program program, boolean verboseAliveInfo, boolean warnFragmentMissing) {
      this.program = program;
      this.verboseAliveInfo = verboseAliveInfo;
      this.warnFragmentMissing = warnFragmentMissing;
   }

   ControlFlowGraph getGraph() {
      return program.getGraph();
   }

   ProgramScope getScope() {
      return program.getScope();
   }

   public void generate() {
      AsmProgram asm = new AsmProgram();
      ScopeRef currentScope = ScopeRef.ROOT;

      // Add file level comments
      asm.startChunk(currentScope, null, "File Comments");
      generateComments(asm, program.getFileComments());

      String outputPrgPath = new File(program.getFileName()).getName()+".prg";
      asm.startChunk(currentScope, null, "Upstart");
      Number programPc = program.getProgramPc();
      if(TargetPlatform.C64BASIC.equals(program.getTargetPlatform())) {
         useSegments = false;
         if(programPc==null) programPc = 0x080d;
         asm.addLine(new AsmSetPc("Basic", AsmFormat.getAsmNumber(0x0801)));
         asm.addLine(new AsmBasicUpstart("bbegin"));
         asm.addLine(new AsmSetPc("Program", AsmFormat.getAsmNumber(programPc)));
      } else if(TargetPlatform.ASM6502.equals(program.getTargetPlatform())) {
         useSegments = false;
         if(programPc==null) programPc = 0x2000;
         asm.addLine(new AsmSetPc("Program", AsmFormat.getAsmNumber(programPc)));
      } else if(TargetPlatform.CUSTOM.equals(program.getTargetPlatform())) {
         useSegments = true;
         if(program.getLinkScriptBody()!=null) {
            asm.addLine(new AsmInlineKickAsm(program.getLinkScriptBody(), 0L, 0L));
         }
         if(programPc!=null) {
            asm.addLine(new AsmSetPc("Program", AsmFormat.getAsmNumber(programPc)));
         }
      }

      // Generate global ZP labels
      asm.startChunk(currentScope, null, "Global Constants & labels");
      addConstants(asm, currentScope);
      addZpLabels(asm, currentScope);
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         if(!block.getScope().equals(currentScope)) {
            // The current block is in a different scope. End the old scope.
            generateScopeEnding(asm, currentScope);
            currentScope = block.getScope();
            if(block.isProcedureEntry(program)) {
               Procedure procedure = block.getProcedure(program);
               currentCodeSegmentName = procedure.getCodeSegment();
            }
            setCurrentSegment(currentCodeSegmentName, asm);
            asm.startChunk(currentScope, null, block.getLabel().getFullName());
            // Add any procedure comments
            if(block.isProcedureEntry(program)) {
               Procedure procedure = block.getProcedure(program);
               generateComments(asm, procedure.getComments());
               // Generate parameter information
               generateSignatureComments(asm, procedure);
            }
            // Start the new scope
            asm.addScopeBegin(AsmFormat.asmFix(block.getLabel().getFullName()));
            // Add all ZP labels for the scope
            addConstants(asm, currentScope);
            addZpLabels(asm, currentScope);
         }

         generateComments(asm, block.getComments());
         // Generate entry points (if needed)
         genBlockEntryPoints(asm, block);

         if(block.isProcedureEntry(program)) {
            // Generate interrupt entry if needed
            Procedure procedure = block.getProcedure(program);
            if(procedure != null && procedure.getInterruptType() != null) {
               generateInterruptEntry(asm, procedure);
            }
         } else {
            // Generate label for block inside procedure
            asm.startChunk(currentScope, null, block.getLabel().getFullName());
            asm.addLabel(AsmFormat.asmFix(block.getLabel().getLocalName()));
         }
         // Generate statements
         genStatements(asm, block);
         // Generate exit
         ControlFlowBlock defaultSuccessor = getGraph().getDefaultSuccessor(block);
         if(defaultSuccessor != null) {
            if(defaultSuccessor.hasPhiBlock()) {
               PhiTransitions.PhiTransition transition = getTransitions(defaultSuccessor).getTransition(block);
               if(!transitionIsGenerated(transition)) {
                  genBlockPhiTransition(asm, block, defaultSuccessor, defaultSuccessor.getScope());
                  String label = AsmFormat.asmFix(defaultSuccessor.getLabel().getLocalName());
                  asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
               } else {
                  String label = AsmFormat.asmFix(defaultSuccessor.getLabel().getLocalName() + "_from_" + block.getLabel().getLocalName());
                  asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
               }
            } else {
               String label = AsmFormat.asmFix(defaultSuccessor.getLabel().getLocalName());
               asm.addInstruction("JMP", AsmAddressingMode.ABS, label, false);
            }
         }
      }
      generateScopeEnding(asm, currentScope);

      currentScope = ScopeRef.ROOT;
      asm.startChunk(currentScope, null, "File Data");
      addData(asm, ScopeRef.ROOT);
      // Add all absolutely placed inline KickAsm
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementKickAsm) {
               StatementKickAsm statementKasm = (StatementKickAsm) statement;
               if(statementKasm.getLocation() != null) {
                  String asmLocation = AsmFormat.getAsmConstant(program, (ConstantValue) statementKasm.getLocation(), 99, ScopeRef.ROOT);
                  String chunkName = "Inline";
                  if(asmLocation.matches("[a-zA-Z_][a-zA-Z0-9_]*")) {
                     chunkName = asmLocation;
                  }
                  asm.addLine(new AsmSetPc(chunkName, asmLocation));
                  addKickAsm(asm, statementKasm);
               }
            }
         }
      }
      program.setAsm(asm);
   }

   // Should the generated program use segments?
   private boolean useSegments = false;
   // Name of the current data segment
   private String currentCodeSegmentName = Scope.SEGMENT_CODE_DEFAULT;
   // Name of the current code segment
   private String currentDataSegmentName = Scope.SEGMENT_DATA_DEFAULT;
   // Name of the current active segment
   private String currentSegmentName = "";

   /**
    * Set the current ASM segment - if needed
    *
    * @param segmentName The segment name we want
    * @param asm The ASM program (where a .segment line is added if needed)
    */
   private void setCurrentSegment(String segmentName, AsmProgram asm) {
      if(useSegments && !currentSegmentName.equals(segmentName)) {
         asm.addLine(new AsmSegment(segmentName));
         currentSegmentName = segmentName;
      }
   }

   /**
    * ASM names of variables being used for indirect calls in the current scope (procedure).
    * These will all be added as indirect JMP's at the end of the procedure scope.
    */
   private List<String> indirectCallAsmNames = new ArrayList<>();

   /**
    * Generate the end of a scope
    *
    * @param asm The assembler program being generated
    * @param currentScope The current scope, which is ending here
    */
   private void generateScopeEnding(AsmProgram asm, ScopeRef currentScope) {
      if(!ScopeRef.ROOT.equals(currentScope)) {
         // Generate any indirect calls pending
         for(String indirectCallAsmName : indirectCallAsmNames) {
            asm.addLabel("bi_" + indirectCallAsmName);
            asm.addInstruction("jmp", AsmAddressingMode.IND, indirectCallAsmName, false);
         }
         indirectCallAsmNames = new ArrayList<>();
         addData(asm, currentScope);
         asm.addScopeEnd();
      }
   }

   /**
    * Add an indirect call to the assembler program. Also queues ASM for the indirect jump to be added at the end of the block.
    *
    * @param asm The ASM program being built
    * @param procedureVariable The variable containing the function pointer
    * @param codeScopeRef The scope containing the code being generated. Used for adding scope to the name when needed (eg. line.x1 when referencing x1 variable inside line scope from outside line scope).
    */
   private void generateIndirectCall(AsmProgram asm, Variable procedureVariable, ScopeRef codeScopeRef) {
      String varAsmName = AsmFormat.getAsmParamName(procedureVariable, codeScopeRef);
      indirectCallAsmNames.add(varAsmName);
      asm.addInstruction("jsr", AsmAddressingMode.ABS, "bi_" + varAsmName, false);
   }

   /**
    * Generate a comment that describes the procedure signature and parameter transfer
    *
    * @param asm The assembler program being generated
    * @param procedure The procedure
    */
   private void generateSignatureComments(AsmProgram asm, Procedure procedure) {
      StringBuilder signature = new StringBuilder();
      signature.append(" ").append(procedure.getLocalName()).append("(");
      int i = 0;
      for(Variable parameter : procedure.getParameters()) {
         List<VariableVersion> versions = new ArrayList<>(procedure.getVersions((VariableUnversioned) parameter));
         if(versions.size() > 0) {
            VariableVersion param = versions.get(0);
            Registers.Register allocation = param.getAllocation();
            if(i++ > 0) signature.append(", ");
            signature.append(param.getType().getTypeName()).append(" ");
            if(allocation instanceof Registers.RegisterZp) {
               Registers.RegisterZp registerZp = (Registers.RegisterZp) allocation;
               signature.append("zeropage(").append(AsmFormat.getAsmNumber(registerZp.getZp())).append(")");
            } else if(allocation instanceof Registers.RegisterAByte) {
               signature.append("register(A)");
            } else if(allocation instanceof Registers.RegisterXByte) {
               signature.append("register(X)");
            } else if(allocation instanceof Registers.RegisterYByte) {
               signature.append("register(Y)");
            }
            signature.append(" ");
            signature.append(parameter.getLocalName());
         }
      }
      signature.append(")");
      if(i > 0) {
         asm.addComment(signature.toString(), false);
      }
   }

   /**
    * Add constant declarations for all scope constants
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addConstants(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<ConstantVar> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      for(ConstantVar constantVar : scopeConstants) {
         if(!hasData(constantVar)) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               added.add(asmName);
               // Add any comments
               generateComments(asm, constantVar.getComments());
               // Ensure encoding is good
               ensureEncoding(asm, constantVar.getValue());
               // Find the constant value calculation
               String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getValue(), 99, scopeRef);
               if(constantVar.getType() instanceof SymbolTypePointer) {
                  // Must use a label for pointers
                  asm.addLabelDecl(AsmFormat.asmFix(asmName), asmConstant);
               } else if(SymbolType.isInteger(constantVar.getType()) && constantVar.getRef().getScopeDepth() > 0) {
                  // Use label for integers referenced in other scope - to allow cross-scope referencing
                  if(useLabelForConst(scopeRef, constantVar)) {
                     // Use label for integers referenced in other scope - to allow cross-scope referencing
                     asm.addLabelDecl(AsmFormat.asmFix(asmName), asmConstant);
                  } else {
                     // Use constant for constant integers not referenced outside scope
                     asm.addConstant(AsmFormat.asmFix(asmName), asmConstant);
                  }
               } else {
                  // Use constant otherwise
                  asm.addConstant(AsmFormat.asmFix(asmName), asmConstant);
               }
            }
         }
      }
   }

   /**
    * Add comments to the assembler program
    *
    * @param asm The assembler program
    * @param comments The comments to add
    */
   private void generateComments(AsmProgram asm, List<Comment> comments) {
      for(Comment comment : comments) {
         asm.addComment(comment.getComment(), comment.isBlock());
      }
   }

   private boolean hasData(ConstantVar constantVar) {
      ConstantValue constantValue = constantVar.getValue();
      if(constantValue instanceof ConstantArray) {
         return true;
      } else {
         try {
            ConstantLiteral literal = constantValue.calculateLiteral(getScope());
            if(literal instanceof ConstantString) {
               return true;
            }
         } catch(ConstantNotLiteral e) {
            // can't calculate literal value, so it is not data
         }
      }
      return false;
   }

   /**
    * Determines whether to use a .label instead of .const for a constant.
    * This can be necessary because KickAssembler does not allow constant references between scopes.
    * If a constant in one scope is referenced from another scope a .label is generated in stead - to allow the cross-scope reference.
    *
    * @param scopeRef The current scope
    * @param constantVar The constant to examine
    * @return true if a .label should be used in the generated ASM
    */
   private boolean useLabelForConst(ScopeRef scopeRef, ConstantVar constantVar) {
      boolean useLabel = false;
      Collection<Integer> constRefStatements = program.getVariableReferenceInfos().getConstRefStatements(constantVar.getRef());
      if(constRefStatements != null) {
         for(Integer constRefStmtIdx : constRefStatements) {
            Statement statement = program.getStatementInfos().getStatement(constRefStmtIdx);
            ScopeRef refScope = program.getStatementInfos().getBlock(constRefStmtIdx).getScope();
            if(statement instanceof StatementPhiBlock) {
               // Const reference in PHI block - examine if the only predecessor is current scope
               boolean found = false;
               for(StatementPhiBlock.PhiVariable phiVariable : ((StatementPhiBlock) statement).getPhiVariables()) {
                  for(StatementPhiBlock.PhiRValue phiRValue : phiVariable.getValues()) {
                     RValue phiRRValue = phiRValue.getrValue();
                     Collection<ConstantRef> phiRValueConstRefs = PassNCalcVariableReferenceInfos.getReferencedConsts(phiRRValue);
                     for(ConstantRef phiRValueConstRef : phiRValueConstRefs) {
                        if(phiRValueConstRef.equals(constantVar.getRef())) {
                           found = true;
                           // Found the constant
                           LabelRef pred = phiRValue.getPredecessor();
                           ControlFlowBlock predBlock = program.getGraph().getBlock(pred);
                           ScopeRef predScope = predBlock.getScope();
                           if(!predScope.equals(scopeRef)) {
                              // Scopes in PHI RValue differs from const scope - generate label
                              useLabel = true;
                           }
                        }
                     }
                  }
               }
               if(!found) {
                  // PHI-reference is complex - generate label
                  program.getLog().append("Warning: Complex PHI-value using constant. Using .label as fallback. " + statement);
                  useLabel = true;
               }
            } else if(!refScope.equals(scopeRef)) {
               // Used in a non-PHI statement in another scope - generate label
               useLabel = true;
            }
         }
      }
      Collection<SymbolVariableRef> symbolRefConsts = program.getVariableReferenceInfos().getSymbolRefConsts(constantVar.getRef());
      if(symbolRefConsts != null) {
         for(SymbolVariableRef symbolRefConst : symbolRefConsts) {
            SymbolVariable symbolRefVar = (SymbolVariable) program.getScope().getSymbol(symbolRefConst);
            if(!symbolRefVar.getScope().getRef().equals(scopeRef)) {
               // Used in constant in another scope - generate label
               useLabel = true;
               break;
            }
         }
      }
      return useLabel;
   }

   /**
    * Add data directives for constants declarations
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addData(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<ConstantVar> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      for(ConstantVar constantVar : scopeConstants) {
         if(hasData(constantVar)) {
            // Skip if already added
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(added.contains(asmName)) {
               continue;
            }
            // Set segment
            setCurrentSegment(constantVar.getDataSegment(), asm);
            // Add any comments
            generateComments(asm, constantVar.getComments());
            // Add any alignment
            Integer declaredAlignment = constantVar.getDeclaredAlignment();
            if(declaredAlignment != null) {
               String alignment = AsmFormat.getAsmNumber(declaredAlignment);
               asm.addDataAlignment(alignment);
            }
            ConstantValue constantValue = constantVar.getValue();
            if(constantValue instanceof ConstantArrayList) {
               SymbolTypeArray constTypeArray = (SymbolTypeArray) constantVar.getType();
               SymbolType elementType = constTypeArray.getElementType();
               ConstantArrayList constantArrayList = (ConstantArrayList) constantValue;
               if(elementType instanceof SymbolTypeStruct) {
                  // Constant array of structs - output each struct as a separate chunk
                  asm.addLabel(asmName).setDontOptimize(true);
                  for(ConstantValue element : constantArrayList.getElements()) {
                     AsmProgram.AsmDataNumericChunk asmDataChunk = new AsmProgram.AsmDataNumericChunk();
                     ensureEncoding(asm, element);
                     addChunkData(asmDataChunk, element, scopeRef);
                     asm.addDataNumeric(null, asmDataChunk);
                  }
               } else if(elementType instanceof SymbolTypeArray) {
                  // Constant array of sub-arrays
                  throw new InternalError("Array of array not supported");
               } else {
                  // Constant array of a "simple" type - add to a single chunk
                  AsmProgram.AsmDataNumericChunk asmDataChunk = new AsmProgram.AsmDataNumericChunk();
                  for(ConstantValue element : constantArrayList.getElements()) {
                     ensureEncoding(asm, element);
                     addChunkData(asmDataChunk, element, scopeRef);
                  }
                  asm.addDataNumeric(asmName, asmDataChunk);
               }
            } else if(constantValue instanceof ConstantArrayFilled) {
               ConstantArrayFilled constantArrayFilled = (ConstantArrayFilled) constantValue;
               ConstantValue arraySize = constantArrayFilled.getSize();
               // ensure encoding is good
               ensureEncoding(asm, arraySize);
               ConstantLiteral arraySizeConst = arraySize.calculateLiteral(getScope());
               if(!(arraySizeConst instanceof ConstantInteger)) {
                  throw new Pass2SsaAssertion.AssertionFailed("Error! Array size is not constant integer " + constantVar.toString(program));
               }
               int size = ((ConstantInteger) arraySizeConst).getInteger().intValue();
               if(SymbolType.BYTE.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, arraySize, 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.BYTE, asmSize, size, "0");
                  added.add(asmName);
               } else if(SymbolType.SBYTE.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, arraySize, 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.BYTE, asmSize, size, "0");
                  added.add(asmName);
               } else if(SymbolType.WORD.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger(2L), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.WORD, asmSize, size, "0");
                  added.add(asmName);
               } else if(SymbolType.SWORD.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger(2L), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.WORD, asmSize, size, "0");
                  added.add(asmName);
               } else if(SymbolType.DWORD.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger(4L), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.DWORD, asmSize, size, "0");
                  added.add(asmName);
               } else if(SymbolType.SDWORD.equals(constantArrayFilled.getElementType())) {
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger(4L), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.DWORD, asmSize, size, "0");
                  added.add(asmName);
               } else if(constantArrayFilled.getElementType() instanceof SymbolTypePointer) {
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger(2L), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.WORD, asmSize, size, "0");
                  added.add(asmName);
               } else if(constantArrayFilled.getElementType() instanceof SymbolTypeStruct) {
                  SymbolTypeStruct structElementType = (SymbolTypeStruct) constantArrayFilled.getElementType();
                  String asmSize = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) structElementType.getSizeBytes()), Operators.MULTIPLY, arraySize), 99, scopeRef);
                  asm.addDataFilled(AsmFormat.asmFix(asmName), AsmDataNumeric.Type.WORD, asmSize, size, "0");
                  added.add(asmName);
               } else {
                  throw new InternalError("Unhandled constant array element type " + constantArrayFilled.toString(program));
               }
            } else if(constantValue instanceof ConstantArrayKickAsm) {
               ConstantArrayKickAsm kickAsm = (ConstantArrayKickAsm) constantValue;
               SymbolType type = constantVar.getType();
               // default - larger then 256
               int bytes = 1023;
               if(type instanceof SymbolTypeArray) {
                  SymbolType elementType = ((SymbolTypeArray) type).getElementType();
                  RValue size = ((SymbolTypeArray) type).getSize();
                  if(size instanceof ConstantValue) {
                     ConstantLiteral sizeLiteral = ((ConstantValue) size).calculateLiteral(getScope());
                     if(sizeLiteral instanceof ConstantInteger) {
                        bytes = (int) (((ConstantInteger) sizeLiteral).getInteger() * elementType.getSizeBytes());
                     }
                  }
               }
               asm.addDataKickAsm(AsmFormat.asmFix(asmName), bytes, kickAsm.getKickAsmCode());
            } else {
               try {
                  ConstantLiteral literal = constantValue.calculateLiteral(getScope());
                  if(literal instanceof ConstantString) {
                     // Ensure encoding is good
                     ensureEncoding(asm, constantValue);
                     String asmConstant = AsmFormat.getAsmConstant(program, constantValue, 99, scopeRef);
                     asm.addDataString(AsmFormat.asmFix(asmName), asmConstant);
                     if(((ConstantString) literal).isZeroTerminated()) {
                        asm.addDataNumeric(null, AsmDataNumeric.Type.BYTE, Collections.singletonList(AsmFormat.getAsmNumber(0L)));
                     }
                     added.add(asmName);
                  }
               } catch(ConstantNotLiteral e) {
                  // can't calculate literal value, so it is not data - just return
               }
            }
         }
      }
   }


   /**
    * Fill the data of a constant value into a data chunk
    *
    * @param dataChunk The data chunk
    * @param value The constant value
    */
   private void addChunkData(AsmProgram.AsmDataNumericChunk dataChunk, ConstantValue value, ScopeRef scopeRef) {
      SymbolType elementType = value.getType(program.getScope());
      if(elementType instanceof SymbolTypeStruct) {
         // Add each struct member recursively
         ConstantStructValue structValue = (ConstantStructValue) value;
         for(VariableRef memberRef : structValue.getMembers()) {
            ConstantValue memberValue = structValue.getValue(memberRef);
            addChunkData(dataChunk, memberValue, scopeRef);
         }
      } else if(SymbolType.BYTE.equals(elementType) || SymbolType.SBYTE.equals(elementType)) {
         dataChunk.addData(AsmDataNumeric.Type.BYTE, AsmFormat.getAsmConstant(program, value, 99, scopeRef));
      } else if(SymbolType.WORD.equals(elementType) || SymbolType.SWORD.equals(elementType)) {
         dataChunk.addData(AsmDataNumeric.Type.WORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef));
      } else if(SymbolType.DWORD.equals(elementType) || SymbolType.SDWORD.equals(elementType)) {
         dataChunk.addData(AsmDataNumeric.Type.DWORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef));
      } else if(elementType instanceof SymbolTypePointer) {
         dataChunk.addData(AsmDataNumeric.Type.WORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef));
      } else {
         throw new InternalError("Unhandled array element type " + elementType.toString() + " value " + value.toString(program));
      }
   }

   /**
    * Add label declarations for all scope variables assigned to ZP registers
    *
    * @param asm The ASM program
    * @param scope The scope
    */
   private void addZpLabels(AsmProgram asm, ScopeRef scope) {
      Collection<Variable> scopeVars = program.getScope().getScope(scope).getAllVariables(false);
      Set<String> added = new LinkedHashSet<>();
      for(Variable scopeVar : scopeVars) {
         Registers.Register register = scopeVar.getAllocation();
         if(register != null && register.isZp()) {
            Registers.RegisterZp registerZp = (Registers.RegisterZp) register;
            String asmName = scopeVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               // Add any comments
               generateComments(asm, scopeVar.getComments());
               // Add the label declaration
               asm.addLabelDecl(AsmFormat.asmFix(asmName), registerZp.getZp());
               added.add(asmName);
            }
         }
      }
   }

   private void genStatements(AsmProgram asm, ControlFlowBlock block) {
      Iterator<Statement> statementsIt = block.getStatements().iterator();
      AsmCodegenAluState aluState = new AsmCodegenAluState();
      while(statementsIt.hasNext()) {
         Statement statement = statementsIt.next();
         if(!(statement instanceof StatementPhiBlock)) {
            try {
               generateStatementAsm(asm, block, statement, aluState, true);
            } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
               if(warnFragmentMissing) {
                  program.getLog().append("Warning! Unknown fragment for statement " + statement.toString(program, false) + "\nMissing ASM fragment " + e.getFragmentSignature()+"\n"+statement.getSource().toString());
                  asm.addLine(new AsmInlineKickAsm(".assert \"Missing ASM fragment "+ e.getFragmentSignature()+"\", 0, 1", 0L, 0L));
               }  else {
                  throw new CompileError("Unknown fragment for statement " + statement.toString(program, false) + "\nMissing ASM fragment " + e.getFragmentSignature(), statement.getSource());
               }
            } catch(CompileError e) {
               if(e.getSource()==null) {
                  throw new CompileError(e.getMessage(), statement);
               }
            }
         }
      }
   }

   /**
    * Generate ASM code for a single statement
    *
    * @param asm The ASM program to generate into
    * @param block The block containing the statement
    * @param statement The statement to generate ASM code for
    * @param aluState State of the special ALU register. Used to generate composite fragments when two consecutive statements can be executed effectively.
    * For example ADC $1100,x combines two statements $0 = $1100 staridx X, A = A+$0 .
    */
   public void generateStatementAsm(AsmProgram asm, ControlFlowBlock block, Statement statement, AsmCodegenAluState aluState, boolean genCallPhiEntry) {

      asm.startChunk(block.getScope(), statement.getIndex(), statement.toString(program, verboseAliveInfo));
      generateComments(asm, statement.getComments());
      // IF the previous statement was added to the ALU register - generate the composite ASM fragment
      if(aluState.hasAluAssignment()) {
         StatementAssignment assignmentAlu = aluState.getAluAssignment();
         if(!(statement instanceof StatementAssignment)) {
            throw new AsmFragmentInstance.AluNotApplicableException();
         }
         StatementAssignment assignment = (StatementAssignment) statement;
         AsmFragmentInstanceSpecFactory asmFragmentInstanceSpecFactory = new AsmFragmentInstanceSpecFactory(assignment, assignmentAlu, program);
         ensureEncoding(asm, asmFragmentInstanceSpecFactory);
         generateAsm(asm, asmFragmentInstanceSpecFactory);
         aluState.clear();
         return;
      }

      if(!(statement instanceof StatementPhiBlock)) {
         if(statement instanceof StatementAssignment) {
            StatementAssignment assignment = (StatementAssignment) statement;
            LValue lValue = assignment.getlValue();
            boolean isAlu = false;
            if(lValue instanceof VariableRef) {
               VariableRef lValueRef = (VariableRef) lValue;
               Registers.Register lValRegister = program.getSymbolInfos().getVariable(lValueRef).getAllocation();
               if(lValRegister.getType().equals(Registers.RegisterType.REG_ALU)) {
                  //asm.addComment(statement + "  //  ALU");
                  StatementAssignment assignmentAlu = assignment;
                  aluState.setAluAssignment(assignmentAlu);
                  isAlu = true;
               }
            }
            if(!isAlu) {
               if(assignment.getOperator() == null && assignment.getrValue1() == null && isRegisterCopy(lValue, assignment.getrValue2())) {
                  //asm.addComment(lValue.toString(program) + " = " + assignment.getrValue2().toString(program) + "  // register copy " + getRegister(lValue));
               } else {
                  AsmFragmentInstanceSpecFactory asmFragmentInstanceSpecFactory = new AsmFragmentInstanceSpecFactory(assignment, program);
                  ensureEncoding(asm, asmFragmentInstanceSpecFactory);
                  generateAsm(asm, asmFragmentInstanceSpecFactory);
               }
            }
         } else if(statement instanceof StatementConditionalJump) {
            AsmFragmentInstanceSpecFactory asmFragmentInstanceSpecFactory = new AsmFragmentInstanceSpecFactory((StatementConditionalJump) statement, block, program, getGraph());
            ensureEncoding(asm, asmFragmentInstanceSpecFactory);
            generateAsm(asm, asmFragmentInstanceSpecFactory);
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            if(genCallPhiEntry) {
               ControlFlowBlock callSuccessor = getGraph().getCallSuccessor(block);
               if(callSuccessor != null && callSuccessor.hasPhiBlock()) {
                  PhiTransitions.PhiTransition transition = getTransitions(callSuccessor).getTransition(block);
                  if(transitionIsGenerated(transition)) {
                     throw new InternalError("Error! JSR transition already generated. Must modify PhiTransitions code to ensure this does not happen.");
                  }
                  genBlockPhiTransition(asm, block, callSuccessor, block.getScope());
               }
            }
            asm.addInstruction("jsr", AsmAddressingMode.ABS, call.getProcedure().getFullName(), false);
         } else if(statement instanceof StatementReturn) {
            Procedure.InterruptType interruptType = null;
            ScopeRef scope = block.getScope();
            if(!scope.equals(ScopeRef.ROOT)) {
               Procedure procedure = getScope().getProcedure(scope.getFullName());
               if(procedure != null) {
                  interruptType = procedure.getInterruptType();
               }
            }
            if(interruptType == null) {
               asm.addInstruction("rts", AsmAddressingMode.NON, null, false);
            } else {
               generateInterruptExit(asm, statement, interruptType);
            }
         } else if(statement instanceof StatementAsm) {
            StatementAsm statementAsm = (StatementAsm) statement;
            HashMap<String, Value> bindings = new HashMap<>();
            AsmFragmentInstance asmFragmentInstance = new AsmFragmentInstance(program, "inline", block.getScope(), new AsmFragmentTemplate(statementAsm.getAsmLines()), bindings);
            asmFragmentInstance.generate(asm);
            AsmChunk currentChunk = asm.getCurrentChunk();

            if(statementAsm.getDeclaredClobber() != null) {
               currentChunk.setClobberOverwrite(statementAsm.getDeclaredClobber());
            } else {
               for(AsmLine asmLine : currentChunk.getLines()) {
                  if(asmLine instanceof AsmInstruction) {
                     AsmInstruction asmInstruction = (AsmInstruction) asmLine;
                     if(asmInstruction.getType().getMnemnonic().equals("jsr")) {
                        currentChunk.setClobberOverwrite(AsmClobber.CLOBBER_ALL);
                     }
                  }
               }
            }
         } else if(statement instanceof StatementKickAsm) {
            StatementKickAsm statementKasm = (StatementKickAsm) statement;
            if(statementKasm.getLocation() == null) {
               addKickAsm(asm, statementKasm);
            }
            if(statementKasm.getDeclaredClobber() != null) {
               asm.getCurrentChunk().setClobberOverwrite(statementKasm.getDeclaredClobber());
            }
         } else if(statement instanceof StatementCallPointer) {
            StatementCallPointer callPointer = (StatementCallPointer) statement;
            RValue procedure = callPointer.getProcedure();
            boolean supported = false;
            if(procedure instanceof PointerDereferenceSimple) {
               RValue pointer = ((PointerDereferenceSimple) procedure).getPointer();
               if(pointer instanceof ConstantValue) {
                  ensureEncoding(asm, pointer);
                  asm.addInstruction("jsr", AsmAddressingMode.ABS, AsmFormat.getAsmConstant(program, (ConstantValue) pointer, 99, block.getScope()), false);
                  supported = true;
               } else if(pointer instanceof VariableRef) {
                  Variable variable = getScope().getVariable((VariableRef) pointer);
                  generateIndirectCall(asm, variable, block.getScope());
                  supported = true;
               } else if(pointer instanceof CastValue && ((CastValue) pointer).getValue() instanceof VariableRef) {
                  Variable variable = getScope().getVariable((VariableRef) ((CastValue) pointer).getValue());
                  generateIndirectCall(asm, variable, block.getScope());
                  supported = true;
               }
            } else if(procedure instanceof VariableRef) {
               Variable procedureVariable = getScope().getVariable((VariableRef) procedure);
               SymbolType procedureVariableType = procedureVariable.getType();
               if(procedureVariableType instanceof SymbolTypePointer) {
                  if(((SymbolTypePointer) procedureVariableType).getElementType() instanceof SymbolTypeProcedure) {
                     generateIndirectCall(asm, procedureVariable, block.getScope());
                     supported = true;
                  }
               }
            } else if(procedure instanceof ConstantRef) {
               ConstantVar procedureVariable = getScope().getConstant((ConstantRef) procedure);
               SymbolType procedureVariableType = procedureVariable.getType();
               if(procedureVariableType instanceof SymbolTypePointer) {
                  if(((SymbolTypePointer) procedureVariableType).getElementType() instanceof SymbolTypeProcedure) {
                     String varAsmName = AsmFormat.getAsmParamName(procedureVariable, block.getScope());
                     asm.addInstruction("jsr", AsmAddressingMode.ABS, varAsmName, false);
                     supported = true;
                  }
               }
            }
            if(supported) {
               asm.getCurrentChunk().setClobberOverwrite(AsmClobber.CLOBBER_ALL);
            }
            if(!supported) {
               throw new InternalError("Call Pointer not supported " + statement);
            }
         } else {
            throw new InternalError("Statement not supported " + statement);
         }
      }
   }

   /**
    * Generate ASM code for an ASM fragment instance
    *
    * @param asm The ASM program to generate into
    * @param asmFragmentInstanceSpecFactory The ASM fragment instance specification factory
    */
   private void generateAsm(AsmProgram asm, AsmFragmentInstanceSpecFactory asmFragmentInstanceSpecFactory) {
      String initialSignature = asmFragmentInstanceSpecFactory.getAsmFragmentInstanceSpec().getSignature();
      AsmFragmentInstanceSpec asmFragmentInstanceSpec = asmFragmentInstanceSpecFactory.getAsmFragmentInstanceSpec();
      AsmFragmentInstance asmFragmentInstance = null;
      StringBuffer fragmentVariationsTried = new StringBuffer();
      while(asmFragmentInstance == null) {
         try {
            asmFragmentInstance = AsmFragmentTemplateSynthesizer.getFragmentInstance(asmFragmentInstanceSpec, program.getLog());
         } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
            // Unknown fragment - keep looking through alternative ASM fragment instance specs until we have tried them all
            String signature = asmFragmentInstanceSpec.getSignature();
            fragmentVariationsTried.append(signature).append(" ");
            if(asmFragmentInstanceSpec.hasNextVariation()) {
               asmFragmentInstanceSpec.nextVariation();
               if(program.getLog().isVerboseFragmentLog()) {
                  program.getLog().append("Fragment not found " + signature + ". Attempting another variation " + asmFragmentInstanceSpec.getSignature());
               }
            } else {
               // No more variations available - fail with an error
               throw new AsmFragmentTemplateSynthesizer.UnknownFragmentException("Fragment not found " + initialSignature + ". Attempted variations " + fragmentVariationsTried);
            }
         }
      }
      asm.getCurrentChunk().setFragment(asmFragmentInstance.getFragmentName());
      asmFragmentInstance.generate(asm);
   }

   /**
    * Generate exit-code for entering an interrupt procedure based on the interrupt type
    *
    * @param asm The assembler to generate code into
    * @param procedure The interrupt procedure
    */
   private void generateInterruptEntry(AsmProgram asm, Procedure procedure) {
      Procedure.InterruptType interruptType = procedure.getInterruptType();
      asm.startChunk(procedure.getRef(), null, "entry interrupt(" + interruptType.name() + ")");
      if(Procedure.InterruptType.KERNEL_MIN.equals(interruptType)) {
         // No entry ASM needed
      } else if(Procedure.InterruptType.KERNEL_KEYBOARD.equals(interruptType)) {
         // No entry ASM needed
      } else if(Procedure.InterruptType.HARDWARE_ALL.equals(interruptType)) {
         asm.addInstruction("sta", AsmAddressingMode.ABS, "rega+1", false).setDontOptimize(true);
         asm.addInstruction("stx", AsmAddressingMode.ABS, "regx+1", false).setDontOptimize(true);
         asm.addInstruction("sty", AsmAddressingMode.ABS, "regy+1", false).setDontOptimize(true);
      } else if(Procedure.InterruptType.HARDWARE_STACK.equals(interruptType)) {
         asm.addInstruction("pha", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("txa", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("pha", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("tya", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("pha", AsmAddressingMode.NON, null, false).setDontOptimize(true);
      } else if(Procedure.InterruptType.HARDWARE_NONE.equals(interruptType)) {
         // No entry ASM needed
      } else if(Procedure.InterruptType.HARDWARE_CLOBBER.equals(interruptType)) {
         asm.addInstruction("sta", AsmAddressingMode.ABS, "rega+1", false).setDontOptimize(true);
         asm.addInstruction("stx", AsmAddressingMode.ABS, "regx+1", false).setDontOptimize(true);
         asm.addInstruction("sty", AsmAddressingMode.ABS, "regy+1", false).setDontOptimize(true);
      } else {
         throw new RuntimeException("Interrupt Type not supported " + interruptType.name());
      }
   }

   /**
    * Generate exit-code for ending an interrupt procedure based on the interrupt type
    *
    * @param asm The assembler to generate code into
    * @param statement The return statement
    * @param interruptType The type of interrupt to generate
    */
   private void generateInterruptExit(AsmProgram asm, Statement statement, Procedure.InterruptType interruptType) {
      asm.getCurrentChunk().setSource(asm.getCurrentChunk().getSource() + " - exit interrupt(" + interruptType.name() + ")");
      if(Procedure.InterruptType.KERNEL_MIN.equals(interruptType)) {
         asm.addInstruction("jmp", AsmAddressingMode.ABS, "$ea81", false);
      } else if(Procedure.InterruptType.KERNEL_KEYBOARD.equals(interruptType)) {
         asm.addInstruction("jmp", AsmAddressingMode.ABS, "$ea31", false);
      } else if(Procedure.InterruptType.HARDWARE_ALL.equals(interruptType)) {
         asm.addLabel("rega").setDontOptimize(true);
         asm.addInstruction("lda", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addLabel("regx").setDontOptimize(true);
         asm.addInstruction("ldx", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addLabel("regy").setDontOptimize(true);
         asm.addInstruction("ldy", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addInstruction("rti", AsmAddressingMode.NON, null, false);
      } else if(Procedure.InterruptType.HARDWARE_STACK.equals(interruptType)) {
         asm.addInstruction("pla", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("tay", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("pla", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("tax", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("pla", AsmAddressingMode.NON, null, false).setDontOptimize(true);
         asm.addInstruction("rti", AsmAddressingMode.NON, null, false);
      } else if(Procedure.InterruptType.HARDWARE_NONE.equals(interruptType)) {
         asm.addInstruction("rti", AsmAddressingMode.NON, null, false);
      } else if(Procedure.InterruptType.HARDWARE_CLOBBER.equals(interruptType)) {
         asm.addLabel("rega").setDontOptimize(true);
         asm.addInstruction("lda", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addLabel("regx").setDontOptimize(true);
         asm.addInstruction("ldx", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addLabel("regy").setDontOptimize(true);
         asm.addInstruction("ldy", AsmAddressingMode.IMM, "00", false).setDontOptimize(true);
         asm.addInstruction("rti", AsmAddressingMode.NON, null, false);
      } else {
         throw new RuntimeException("Interrupt Type not supported " + statement);
      }
   }

   private void addKickAsm(AsmProgram asm, StatementKickAsm statementKasm) {
      Long asmBytes = null;
      if(statementKasm.getBytes() != null) {
         ConstantValue kasmBytes = (ConstantValue) statementKasm.getBytes();
         ConstantLiteral kasmBytesLiteral = kasmBytes.calculateLiteral(getScope());
         asmBytes = ((ConstantInteger) kasmBytesLiteral).getInteger();
      }
      Long asmCycles = null;
      if(statementKasm.getCycles() != null) {
         ConstantValue kasmCycles = (ConstantValue) statementKasm.getCycles();
         ConstantLiteral kasmCyclesLiteral = kasmCycles.calculateLiteral(getScope());
         asmCycles = ((ConstantInteger) kasmCyclesLiteral).getInteger();
      }
      asm.addInlinedKickAsm(statementKasm.getKickAsmCode(), asmBytes, asmCycles);
   }

   /**
    * Generate all block entry points (phi transitions) which have not already been generated.
    *
    * @param asm The ASM program to generate into
    * @param toBlock The block to generate remaining entry points for.
    */
   private void genBlockEntryPoints(AsmProgram asm, ControlFlowBlock toBlock) {
      PhiTransitions transitions = getTransitions(toBlock);
      for(ControlFlowBlock fromBlock : transitions.getFromBlocks()) {
         PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
         if(!transitionIsGenerated(transition) && toBlock.getLabel().equals(fromBlock.getConditionalSuccessor())) {
            genBlockPhiTransition(asm, fromBlock, toBlock, toBlock.getScope());
            asm.addInstruction("JMP", AsmAddressingMode.ABS, AsmFormat.asmFix(toBlock.getLabel().getLocalName()), false);
         }
      }
   }

   /**
    * Generate a phi block transition. The transition performs all necessary assignment operations when moving from one block to another.
    * The transition can be inserted either at the start of the to-block (used for conditional jumps)
    * or at the end of the from-block ( used at default block transitions and before JMP/JSR)
    *
    * @param asm The ASP program to generate the transition into.
    * @param fromBlock The from-block
    * @param toBlock The to-block
    * @param scope The scope where the ASM code is being inserted. Used to ensure that labels inserted in the code reference the right variables.
    * If the transition code is inserted in the to-block, this is the scope of the to-block.
    * If the transition code is inserted in the from-block this is the scope of the from-block.
    */
   private void genBlockPhiTransition(AsmProgram asm, ControlFlowBlock fromBlock, ControlFlowBlock toBlock, ScopeRef
         scope) {
      PhiTransitions transitions = getTransitions(toBlock);
      PhiTransitions.PhiTransition transition = transitions.getTransition(fromBlock);
      if(!transitionIsGenerated(transition)) {
         Statement toFirstStatement = toBlock.getStatements().get(0);
         String chunkSrc = "[" + toFirstStatement.getIndex() + "] phi from ";
         for(ControlFlowBlock fBlock : transition.getFromBlocks()) {
            chunkSrc += fBlock.getLabel().getFullName() + " ";
         }
         chunkSrc += "to " + toBlock.getLabel().getFullName();
         asm.startChunk(scope, toFirstStatement.getIndex(), chunkSrc);
         asm.getCurrentChunk().setPhiTransitionId(transition.getTransitionId());
         for(ControlFlowBlock fBlock : transition.getFromBlocks()) {
            asm.addLabel(AsmFormat.asmFix(toBlock.getLabel().getLocalName() + "_from_" + fBlock.getLabel().getLocalName()));
         }
         List<PhiTransitions.PhiTransition.PhiAssignment> assignments = transition.getAssignments();
         for(PhiTransitions.PhiTransition.PhiAssignment assignment : assignments) {
            LValue lValue = assignment.getVariable();
            RValue rValue = assignment.getrValue();
            Statement statement = assignment.getPhiBlock();
            // Generate an ASM move fragment
            asm.startChunk(scope, statement.getIndex(), "[" + statement.getIndex() + "] phi " + lValue.toString(program) + " = " + rValue.toString(program));
            asm.getCurrentChunk().setPhiTransitionId(transition.getTransitionId());
            asm.getCurrentChunk().setPhiTransitionAssignmentIdx(assignment.getAssignmentIdx());
            if(isRegisterCopy(lValue, rValue)) {
               asm.getCurrentChunk().setFragment("register_copy");
            } else {
               AsmFragmentInstanceSpecFactory asmFragmentInstanceSpecFactory = new AsmFragmentInstanceSpecFactory(lValue, rValue, program, scope);
               ensureEncoding(asm, asmFragmentInstanceSpecFactory);
               generateAsm(asm, asmFragmentInstanceSpecFactory);
            }
         }
         transitionSetGenerated(transition);
      } else {
         program.getLog().append("Already generated transition from " + fromBlock.getLabel() + " to " + toBlock.getLabel() + " - not generating it again!");
      }
   }


   /**
    * Ensure that the current encoding in the ASM matches any encoding in the data to be emitted
    *
    * @param asm The ASM program (where any .encoding directive will be emitted)
    * @param asmFragmentInstance The ASM fragment to be emitted
    */
   private void ensureEncoding(AsmProgram asm, AsmFragmentInstanceSpecFactory asmFragmentInstance) {
      ensureEncoding(asm, getEncoding(asmFragmentInstance));
   }

   private void ensureEncoding(AsmProgram asm, Value value) {
      ensureEncoding(asm, getEncoding(value));
   }

   /**
    * Ensure that the current encoding in the ASM matches any encoding in the data to be emitted
    *
    * @param asm The ASM program (where any .encoding directive will be emitted)
    * @param encodings The encodings to ensure
    */
   private void ensureEncoding(AsmProgram asm, Collection<ConstantString.Encoding> encodings) {
      if(encodings == null || encodings.size() == 0) return;
      if(encodings.size() > 1) {
         throw new CompileError("Different character encodings in one ASM statement not supported!");
      }
      // Size is 1 - grab it!
      ConstantString.Encoding encoding = encodings.iterator().next();
      if(!currentEncoding.equals(encoding)) {
         asm.addLine(new AsmSetEncoding(encoding));
         currentEncoding = encoding;
      }
   }

   /**
    * Examine a constantvalue to see if any string encoding information is present
    *
    * @param value The constant to examine
    * @return Any encoding found inside the constant
    */
   private Set<ConstantString.Encoding> getEncoding(Value value) {
      LinkedHashSet<ConstantString.Encoding> encodings = new LinkedHashSet<>();
      ProgramValue programValue = new ProgramValue.GenericValue(value);
      ProgramValueHandler handler = (ProgramValue pVal, Statement currentStmt, ListIterator<Statement> stmtIt, ControlFlowBlock currentBlock) -> {
         Value val = pVal.get();
         if(val instanceof ConstantChar) {
            encodings.add(((ConstantChar) val).getEncoding());
         } else if(val instanceof ConstantString) {
            encodings.add(((ConstantString) val).getEncoding());
         }
      };
      ProgramValueIterator.execute(programValue, handler, null, null, null);
      return encodings;
   }


   /**
    * Examine an ASM fragment to see if any string encoding information is present
    *
    * @param asmFragmentInstance The asm fragment instance to examine
    * @return Any encoding found inside the constant
    */
   private Set<ConstantString.Encoding> getEncoding(AsmFragmentInstanceSpecFactory asmFragmentInstance) {
      LinkedHashSet<ConstantString.Encoding> encodings = new LinkedHashSet<>();
      Map<String, Value> bindings = asmFragmentInstance.getBindings();
      for(Value boundValue : bindings.values()) {
         encodings.addAll(getEncoding(boundValue));
      }
      return encodings;
   }


   /**
    * Get phi transitions for a specific to-block.
    *
    * @param toBlock The block
    * @return The transitions into the block
    */
   private PhiTransitions getTransitions(ControlFlowBlock toBlock) {
      return program.getPhiTransitions().get(toBlock.getLabel());
   }

   private Registers.Register getRegister(RValue rValue) {
      if(rValue instanceof VariableRef) {
         VariableRef rValueRef = (VariableRef) rValue;
         return program.getSymbolInfos().getVariable(rValueRef).getAllocation();
      } else if(rValue instanceof CastValue) {
         return getRegister(((CastValue) rValue).getValue());
      } else {
         return null;
      }
   }

   private boolean isRegisterCopy(LValue lValue, RValue rValue) {
      return
            getRegister(lValue) != null &&
                  getRegister(rValue) != null &&
                  getRegister(lValue).equals(getRegister(rValue));
   }

   /**
    * Contains previous assignment added to the ALU register between calls to generateStatementAsm
    */
   public static class AsmCodegenAluState {

      private StatementAssignment aluAssignment;

      public StatementAssignment getAluAssignment() {
         return aluAssignment;
      }

      public void setAluAssignment(StatementAssignment aluAssignment) {
         this.aluAssignment = aluAssignment;
      }

      public boolean hasAluAssignment() {
         return aluAssignment != null;
      }

      public void clear() {
         aluAssignment = null;
      }
   }

}
