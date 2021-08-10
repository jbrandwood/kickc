package dk.camelot64.kickc.passes;

import dk.camelot64.cpufamily6502.CpuAddressingMode;
import dk.camelot64.cpufamily6502.CpuClobber;
import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.fragment.*;
import dk.camelot64.kickc.model.InternalError;
import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueHandler;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.operators.Operators;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.*;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.calcs.PassNCalcVariableReferenceInfos;
import dk.camelot64.kickc.passes.utils.SizeOfConstants;

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
   private final Program program;

   /**
    * Keeps track of the phi transitions into blocks during code generation.
    * Used to ensure that duplicate transitions are only code generated once.
    * Maps to-blocks to the transition information for the block
    */
   private final Map<PhiTransitions.PhiTransition, Boolean> transitionsGenerated = new LinkedHashMap<>();

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
      AsmProgram asm = new AsmProgram(program.getTargetCpu());
      ScopeRef currentScope = ScopeRef.ROOT;

      // Add file level comments
      asm.startChunk(currentScope, null, "File Comments");
      generateComments(asm, program.getMainFileComments());
      asm.startChunk(currentScope, null, "Upstart");
      final TargetPlatform targetPlatform = program.getTargetPlatform();

      // Add Target CPU - if it is not the default
      final TargetCpu targetCpu = program.getTargetCpu();
      if(!targetCpu.equals(TargetCpu.DEFAULT))
         asm.addLine(new AsmSetCpu(targetCpu));

      String linkScriptBody = targetPlatform.getLinkScriptBody();
      String outputFileName = program.getOutputFileManager().getBinaryOutputFile().getFileName().toString();
      linkScriptBody = linkScriptBody.replace("%O", outputFileName);
      linkScriptBody = linkScriptBody.replace("%_O", outputFileName.toLowerCase());
      linkScriptBody = linkScriptBody.replace("%^O", outputFileName.toUpperCase());
      String entryName = program.getStartProcedure().getFullName();
      linkScriptBody = linkScriptBody.replace("%E", entryName);
      Number startAddress = program.getTargetPlatform().getStartAddress();
      if(startAddress != null)
         linkScriptBody = linkScriptBody.replace("%P", AsmFormat.getAsmNumber(startAddress));
      asm.addLine(new AsmInlineKickAsm(linkScriptBody, 0L, 0L));

      // Generate global ZP labels
      asm.startChunk(currentScope, null, "Global Constants & labels");
      addConstantsAndLabels(asm, currentScope);
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
            addConstantsAndLabels(asm, currentScope);
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
                  asm.addInstruction("JMP", CpuAddressingMode.ABS, label, false);
               } else {
                  String label = AsmFormat.asmFix(defaultSuccessor.getLabel().getLocalName() + "_from_" + block.getLabel().getLocalName());
                  asm.addInstruction("JMP", CpuAddressingMode.ABS, label, false);
               }
            } else {
               String label = AsmFormat.asmFix(defaultSuccessor.getLabel().getLocalName());
               asm.addInstruction("JMP", CpuAddressingMode.ABS, label, false);
            }
         }
      }
      generateScopeEnding(asm, currentScope);

      currentScope = ScopeRef.ROOT;
      asm.startChunk(currentScope, null, "File Data");
      addData(asm, ScopeRef.ROOT);
      addAbsoluteAddressData(asm, ScopeRef.ROOT);
      program.setAsm(asm);
   }

   // Name of the current data segment
   private String currentCodeSegmentName = Scope.SEGMENT_CODE_DEFAULT;
   // Name of the current code segment
   private final String currentDataSegmentName = Scope.SEGMENT_DATA_DEFAULT;
   // Name of the current active segment
   private String currentSegmentName = "";

   /**
    * Set the current ASM segment - if needed
    *
    * @param segmentName The segment name we want
    * @param asm The ASM program (where a .segment line is added if needed)
    */
   private void setCurrentSegment(String segmentName, AsmProgram asm) {
      if(!currentSegmentName.equals(segmentName)) {
         asm.addLine(new AsmSegment(segmentName));
         currentSegmentName = segmentName;
      }
   }

   /** Counter used to separate indirect calls */
   private int indirectCallCount = 1;

   /**
    * Generate the end of a scope
    *
    * @param asm The assembler program being generated
    * @param currentScope The current scope, which is ending here
    */
   private void generateScopeEnding(AsmProgram asm, ScopeRef currentScope) {
      if(!ScopeRef.ROOT.equals(currentScope)) {
         if(asm.hasStash())
            asm.startChunk(currentScope, null, "Outside Flow");
         // Generate all stashed ASM lines
         asm.addStash();
         addData(asm, currentScope);
         asm.addScopeEnd();
      }
   }

   /**
    * Generate a comment that describes the procedure signature and parameter transfer
    *
    * @param asm The assembler program being generated
    * @param procedure The procedure
    */
   private void generateSignatureComments(AsmProgram asm, Procedure procedure) {
      StringBuilder signature = new StringBuilder();
      signature.append(" ");
      generateSignatureVar(procedure.getLocalVar("return"), procedure, signature);
      signature.append(procedure.getReturnType().toCDecl());
      signature.append(" ").append(procedure.getLocalName()).append("(");
      int i = 0;
      for(Variable parameter : procedure.getParameters()) {
         if(i++ > 0) signature.append(", ");
         Variable param = generateSignatureVar(parameter, procedure, signature);
         signature.append(param.getType().toCDecl(parameter.getLocalName()));
      }
      signature.append(")");
      if(i > 0) {
         asm.addComment(signature.toString(), false);
      }
   }

   /**
    * Generate part of a comment that describes a returnvalue/parameter
    * @param param The variable to describe
    * @param scope The scope (procedure)
    * @param signature The signature to append to
    * @return The version of the variable chosen
    */
   Variable generateSignatureVar(Variable param, Scope scope, StringBuilder signature) {
      if(param==null) return param;
      if(param.isKindPhiMaster()) {
         List<Variable> versions = new ArrayList<>(scope.getVersions(param));
         if(versions.size() > 0)
            if(param.getLocalName().equals("return")) {
               // Choose the last version for return values
               param = versions.get(versions.size()-1);
            } else {
               // Choose the first version for parameters
               param = versions.get(0);
            }
         else
            // Parameter optimized away to a constant or unused
            return param;
      }

      Registers.Register allocation = param.getAllocation();
      if(allocation instanceof Registers.RegisterZpMem) {
         Registers.RegisterZpMem registerZp = (Registers.RegisterZpMem) allocation;
         signature.append("__zp(").append(AsmFormat.getAsmNumber(registerZp.getZp())).append(") ");
      } else if(allocation instanceof Registers.RegisterMainMem) {
         Registers.RegisterMainMem registerMainMem = (Registers.RegisterMainMem) allocation;
         signature.append("__mem(").append(registerMainMem.getAddress() == null ? "" : AsmFormat.getAsmNumber(registerMainMem.getAddress())).append(") ");
      } else if(allocation instanceof Registers.RegisterAByte) {
         signature.append("__register(A) ");
      } else if(allocation instanceof Registers.RegisterXByte) {
         signature.append("__register(X) ");
      } else if(allocation instanceof Registers.RegisterYByte) {
         signature.append("__register(Y) ");
      } else if(allocation instanceof Registers.RegisterZByte) {
         signature.append("__register(Z) ");
      }
      return param;
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

   private boolean hasData(Variable constantVar) {
      ConstantValue constantValue = constantVar.getInitValue();
      if(constantValue instanceof ConstantArray)
         return true;
      else if(constantValue instanceof ConstantStructValue)
         return true;
      else if(constantValue instanceof ConstantString)
         return true;
      else
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
   private boolean useLabelForConst(ScopeRef scopeRef, Variable constantVar) {
      boolean useLabel = false;
      Collection<Integer> constRefStatements = program.getVariableReferenceInfos().getConstRefStatements(constantVar.getConstantRef());
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
      Collection<SymbolVariableRef> symbolRefConsts = program.getVariableReferenceInfos().getConstRefSymbols(constantVar.getConstantRef());
      if(symbolRefConsts != null) {
         for(SymbolVariableRef symbolRefConst : symbolRefConsts) {
            Variable symbolRefVar = (Variable) program.getScope().getSymbol(symbolRefConst);
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
    * Add constant declarations for constants without data and labels for memory variables without data.
    * Added before the the code of the scope.
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addConstantsAndLabels(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Set<String> added = new LinkedHashSet<>();
      Collection<Variable> scopeConstants = scope.getAllConstants(false);

      // First add all constants without data that can become constants in KickAsm
      for(Variable constantVar : scopeConstants) {
         if(!hasData(constantVar)) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               if(SymbolType.isInteger(constantVar.getType()) && constantVar.getRef().getScopeDepth() > 0) {
                  // Use label for integers referenced in other scope - to allow cross-scope referencing
                  if(!useLabelForConst(scopeRef, constantVar)) {
                     // Use constant for constant integers not referenced outside scope
                     added.add(asmName);
                     // Find the constant value calculation
                     String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getInitValue(), 99, scopeRef);
                     addConstant(asmName, constantVar, asmConstant, asm);
                  }
               } else if(!(constantVar.getType() instanceof SymbolTypePointer)) {
                  // Use constant otherwise
                  added.add(asmName);
                  // Find the constant value calculation
                  String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getInitValue(), 99, scopeRef);
                  addConstant(asmName, constantVar, asmConstant, asm);
               }
            }
         }
      }

      // Add constants without data that must be labels in KickAsm
      for(Variable constantVar : scopeConstants) {
         if(!hasData(constantVar)) {
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(asmName != null && !added.contains(asmName)) {
               if(constantVar.getType() instanceof SymbolTypePointer) {
                  // Must use a label for pointers
                  added.add(asmName);
                  String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getInitValue(), 99, scopeRef);
                  addConstantLabelDecl(asmName, constantVar, asmConstant, asm);
               } else if(SymbolType.isInteger(constantVar.getType()) && constantVar.getRef().getScopeDepth() > 0) {
                  // Use label for integers referenced in other scope - to allow cross-scope referencing
                  if(useLabelForConst(scopeRef, constantVar)) {
                     // Use label for integers referenced in other scope - to allow cross-scope referencing
                     added.add(asmName);
                     // Add any comments
                     String asmConstant = AsmFormat.getAsmConstant(program, constantVar.getInitValue(), 99, scopeRef);
                     addConstantLabelDecl(asmName, constantVar, asmConstant, asm);
                  }
               }
            }
         }
      }

      // Add labels for memory variables without data
      Collection<Variable> scopeVars = scope.getAllVariables(false);
      for(Variable scopeVar : scopeVars) {
         Registers.Register register = scopeVar.getAllocation();
         if(register != null) {
            if(Registers.RegisterType.ZP_MEM.equals(register.getType())) {
               Registers.RegisterZpMem registerZp = (Registers.RegisterZpMem) register;
               String asmName = scopeVar.getAsmName();
               if(asmName != null && !added.contains(asmName)) {
                  added.add(asmName);
                  addConstantLabelDecl(asmName, scopeVar, AsmFormat.getAsmNumber(registerZp.getZp()), asm);
               }
            } else if(Registers.RegisterType.MAIN_MEM.equals(register.getType()) && ((Registers.RegisterMainMem) register).getAddress() != null) {
               String asmName = scopeVar.getAsmName();
               if(asmName != null && !added.contains(asmName)) {
                  added.add(asmName);
                  // Add the label declaration
                  Long address = ((Registers.RegisterMainMem) register).getAddress();
                  addConstantLabelDecl(asmName, scopeVar, AsmFormat.getAsmNumber(address), asm);
               }
            }
         }
      }

   }

   private void addConstant(String asmName, Variable constantVar, String asmConstant, AsmProgram asm) {
      // Add any comments
      generateComments(asm, constantVar.getComments());
      // Ensure encoding is good
      ensureEncoding(asm, constantVar.getInitValue());
      asm.addConstant(AsmFormat.asmFix(asmName), asmConstant);
   }

   private void addConstantLabelDecl(String asmName, Variable variable, String asmConstant, AsmProgram asm) {
      // Add any comments
      generateComments(asm, variable.getComments());
      // Ensure encoding is good
      ensureEncoding(asm, variable.getInitValue());
      // Find the constant value calculation
      asm.addLabelDecl(AsmFormat.asmFix(asmName), asmConstant);
   }

   /**
    * Add all constants with data that must be placed at an absolute address
    * Added at the end of the file
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addAbsoluteAddressData(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<Variable> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      // Add all constants arrays incl. strings with data
      for(Variable constantVar : scopeConstants) {
         if(hasData(constantVar)) {
            // Skip if already added
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(added.contains(asmName)) {
               continue;
            }
            // Skip if address is not absolute
            if(constantVar.getMemoryAddress() == null)
               continue;
            // Set segment
            setCurrentSegment(constantVar.getDataSegment(), asm);
            // Set absolute address
            asm.addLine(new AsmSetPc(asmName, AsmFormat.getAsmConstant(program, constantVar.getMemoryAddress(), 99, scopeRef)));
            // Add any comments
            generateComments(asm, constantVar.getComments());
            // Add any alignment
            Integer declaredAlignment = constantVar.getMemoryAlignment();
            if(declaredAlignment != null) {
               String alignment = AsmFormat.getAsmNumber(declaredAlignment);
               asm.addDataAlignment(alignment);
            }
            ConstantValue constantValue = constantVar.getInitValue();
            if(constantValue instanceof ConstantArray || constantValue instanceof ConstantString || constantValue instanceof ConstantStructValue) {
               AsmDataChunk asmDataChunk = new AsmDataChunk();
               addChunkData(asmDataChunk, constantValue, constantVar.getType(), constantVar.getArraySpec(), scopeRef);
               asmDataChunk.addToAsm(AsmFormat.asmFix(asmName), asm);
            } else {
               throw new InternalError("Constant Variable not handled " + constantVar.toString(program));
            }
            added.add(asmName);
         }
      }

   }

   /**
    * Add constants with data and memory variables with data for a scope.
    * Added after the the code of the scope.
    *
    * @param asm The ASM program
    * @param scopeRef The scope
    */
   private void addData(AsmProgram asm, ScopeRef scopeRef) {
      Scope scope = program.getScope().getScope(scopeRef);
      Collection<Variable> scopeConstants = scope.getAllConstants(false);
      Set<String> added = new LinkedHashSet<>();
      // Add all constants arrays incl. strings with data
      for(Variable constantVar : scopeConstants) {
         if(hasData(constantVar)) {
            // Skip if already added
            String asmName = constantVar.getAsmName() == null ? constantVar.getLocalName() : constantVar.getAsmName();
            if(added.contains(asmName)) {
               continue;
            }
            // Skip if address is absolute
            if(constantVar.getMemoryAddress() != null)
               continue;
            // Set segment
            setCurrentSegment(constantVar.getDataSegment(), asm);
            // Add any comments
            generateComments(asm, constantVar.getComments());
            // Add any alignment
            Integer declaredAlignment = constantVar.getMemoryAlignment();
            if(declaredAlignment != null) {
               String alignment = AsmFormat.getAsmNumber(declaredAlignment);
               asm.addDataAlignment(alignment);
            }
            ConstantValue constantValue = constantVar.getInitValue();
            if(constantValue instanceof ConstantArray || constantValue instanceof ConstantString || constantValue instanceof ConstantStructValue) {
               AsmDataChunk asmDataChunk = new AsmDataChunk();
               addChunkData(asmDataChunk, constantValue, constantVar.getType(), constantVar.getArraySpec(), scopeRef);
               asmDataChunk.addToAsm(AsmFormat.asmFix(asmName), asm);
            } else {
               throw new InternalError("Constant Variable not handled " + constantVar.toString(program));
            }
            added.add(asmName);
         }
      }
      // Add all memory variables
      Collection<Variable> scopeVariables = scope.getAllVariables(false);
      for(Variable variable : scopeVariables) {
         if(variable.isMemoryAreaMain()) {
            // Skip PHI masters
            if(variable.isKindPhiMaster())
               continue;
            // Skip if already added
            if(added.contains(variable.getAsmName())) {
               continue;
            }
            if(variable.isKindLoadStore() || variable.isKindPhiVersion() || variable.isKindIntermediate()) {
               Registers.Register allocation = variable.getAllocation();
               if(allocation instanceof Registers.RegisterCpuByte)
                  continue;
               if(!(allocation instanceof Registers.RegisterMainMem)) {
                  throw new InternalError("Expected main memory allocation " + variable.toString(program));
               }
               Registers.RegisterMainMem registerMainMem = (Registers.RegisterMainMem) allocation;
               final Variable mainVar = program.getScope().getVariable(registerMainMem.getVariableRef());
               if(registerMainMem.getAddress() == null) {
                  // Generate into the data segment
                  // Set segment
                  setCurrentSegment(variable.getDataSegment(), asm);
                  // Add any comments
                  generateComments(asm, variable.getComments());
                  final String mainAsmName = AsmFormat.getAsmConstant(program, new ConstantSymbolPointer(mainVar.getRef()), 99, scopeRef);
                  final String asmSymbolName = AsmFormat.getAsmSymbolName(program, variable, scopeRef);
                  if(!mainAsmName.equals(asmSymbolName)) {
                     asm.addLabelDecl(asmSymbolName, mainAsmName);
                  } else {
                     // Add any alignment
                     Integer declaredAlignment = variable.getMemoryAlignment();
                     if(declaredAlignment != null) {
                        String alignment = AsmFormat.getAsmNumber(declaredAlignment);
                        asm.addDataAlignment(alignment);
                     }
                     if(variable.getInitValue() != null) {
                        // Variable has a constant init Value
                        ConstantValue constantValue = variable.getInitValue();
                        AsmDataChunk asmDataChunk = new AsmDataChunk();
                        addChunkData(asmDataChunk, constantValue, variable.getType(), variable.getArraySpec(), scopeRef);
                        asmDataChunk.addToAsm(AsmFormat.asmFix(variable.getAsmName()), asm);
                     } else {
                        // Zero-fill variable
                        AsmDataChunk asmDataChunk = new AsmDataChunk();
                        ConstantValue zeroValue = Initializers.createZeroValue(new Initializers.ValueTypeSpec(variable.getType()), null);
                        addChunkData(asmDataChunk, zeroValue, variable.getType(), variable.getArraySpec(), scopeRef);
                        asmDataChunk.addToAsm(AsmFormat.asmFix(variable.getAsmName()), asm);
                     }
                  }
                  added.add(variable.getAsmName());
               }
            } else {
               throw new InternalError("Not handled variable storage " + variable.toString());
            }
         }
      }
   }

   /**
    * Get the declared size of an array type as an integer
    *
    * @param declaredSize The declared size
    * @return The integer size. Null if it can't be determined
    */
   private Integer getArrayDeclaredSize(ConstantValue declaredSize) {
      if(declaredSize != null) {
         ConstantLiteral declaredSizeVal = declaredSize.calculateLiteral(getScope());
         if(!(declaredSizeVal instanceof ConstantInteger)) {
            throw new CompileError("Error! Array declared size is not integer " + declaredSize.toString());
         }
         return ((ConstantInteger) declaredSizeVal).getInteger().intValue();
      }
      return null;
   }


   /**
    * Fill the data of a constant value into a data chunk
    *
    * @param dataChunk The data chunk
    * @param value The constant value
    * @param valueType The declared type of the value
    * @param valueArraySpec The array properties of the value
    * @param scopeRef The scope containing the data chunk
    */
   private void addChunkData(AsmDataChunk dataChunk, ConstantValue value, SymbolType valueType, ArraySpec valueArraySpec, ScopeRef scopeRef) {
      if(valueType instanceof SymbolTypeStruct) {
         if(value instanceof ConstantStructValue) {
            // Add each struct member recursively
            ConstantStructValue structValue = (ConstantStructValue) value;
            int size = 0;
            for(SymbolVariableRef memberRef : structValue.getMembers()) {
               ConstantValue memberValue = structValue.getValue(memberRef);
               Variable memberVariable = getScope().getVar(memberRef);
               addChunkData(dataChunk, memberValue, memberVariable.getType(), memberVariable.getArraySpec(), scopeRef);
               size += SymbolTypeStruct.getMemberSizeBytes(memberVariable.getType(), memberVariable.getArraySize(), getScope());
            }
            // Add padding if this is a union and the first member does not use all bytes
            final int declaredSize = structValue.getStructType().getSizeBytes();
            if(size < declaredSize) {
               long paddingSize = declaredSize - size;
               // TODO: Use SIZEOF constant
               ConstantValue paddingSizeVal = new ConstantInteger(paddingSize);
               String paddingBytesAsm = AsmFormat.getAsmConstant(program, paddingSizeVal, 99, scopeRef);
               ConstantValue zeroValue = new ConstantInteger(0l, SymbolType.BYTE);
               dataChunk.addDataZeroFilled(AsmDataNumeric.Type.BYTE, paddingBytesAsm, (int) paddingSize, getEncoding(zeroValue));
            }
         } else if(value instanceof StructZero) {
            final SymbolTypeStruct typeStruct = ((StructZero) value).getTypeStruct();
            final ConstantRef structSize = SizeOfConstants.getSizeOfConstantVar(getScope(), typeStruct);
            String totalSizeBytesAsm = AsmFormat.getAsmConstant(program, structSize, 99, scopeRef);
            int totalSizeBytes = typeStruct.getSizeBytes();
            dataChunk.addDataZeroFilled(AsmDataNumeric.Type.BYTE, totalSizeBytesAsm, totalSizeBytes, null);
         }
      } else if(valueType instanceof SymbolTypePointer && valueArraySpec != null) {
         SymbolTypePointer constTypeArray = (SymbolTypePointer) valueType;
         SymbolType elementType = constTypeArray.getElementType();

         SymbolType dataType = value.getType(program.getScope());
         int dataNumElements = 0;
         if(value instanceof ConstantArrayFilled) {
            ConstantArrayFilled constantArrayFilled = (ConstantArrayFilled) value;
            ConstantValue arraySize = constantArrayFilled.getSize();
            ConstantLiteral arraySizeConst = arraySize.calculateLiteral(getScope());
            if(!(arraySizeConst instanceof ConstantInteger)) {
               throw new Pass2SsaAssertion.AssertionFailed("Error! Array size is not constant integer " + arraySize.toString(program));
            }
            dataNumElements = ((ConstantInteger) arraySizeConst).getInteger().intValue();
            int elementSizeBytes = elementType.getSizeBytes();
            String totalSizeBytesAsm;
            if(elementSizeBytes > 1) {
               // TODO: Use a SIZEOF constant for the element size ASM
               totalSizeBytesAsm = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) elementSizeBytes, SymbolType.NUMBER), Operators.MULTIPLY, arraySize), 99, scopeRef);
            } else {
               totalSizeBytesAsm = AsmFormat.getAsmConstant(program, arraySize, 99, scopeRef);
            }
            if(elementType instanceof SymbolTypeIntegerFixed || elementType instanceof SymbolTypePointer) {
               // Use an ASM type in the fill that matches the element type
               dataChunk.addDataZeroFilled(getNumericType(elementType), totalSizeBytesAsm, dataNumElements, null);
            } else {
               // Complex fill type - calculate byte size and use that
               int totalSizeBytes = elementSizeBytes * dataNumElements;
               dataChunk.addDataZeroFilled(AsmDataNumeric.Type.BYTE, totalSizeBytesAsm, totalSizeBytes, null);
            }
         } else if(value instanceof ConstantArrayKickAsm) {
            ConstantArrayKickAsm kickAsm = (ConstantArrayKickAsm) value;
            // default - larger then 256
            int bytes = 1023;
            Integer declaredSize = getArrayDeclaredSize(valueArraySpec.getArraySize());
            if(declaredSize != null) {
               bytes = declaredSize * elementType.getSizeBytes();
            }
            dataChunk.addDataKickAsm(bytes, kickAsm.getKickAsmCode(), getEncoding(value));
            dataNumElements = bytes;
         } else if(value instanceof ConstantString) {
            ConstantString stringValue = (ConstantString) value;
            String asmConstant = AsmFormat.getAsmConstant(program, stringValue, 99, scopeRef);
            dataChunk.addDataString(asmConstant, getEncoding(stringValue));
            if(stringValue.isZeroTerminated()) {
               dataChunk.addDataNumeric(AsmDataNumeric.Type.BYTE, "0", null);
            }
            dataNumElements = stringValue.getStringLength();
         } else {
            // Assume we have a ConstantArrayList
            ConstantArrayList constantArrayList = (ConstantArrayList) value;
            // Output each element to the chunk
            for(ConstantValue element : constantArrayList.getElements()) {
               addChunkData(dataChunk, element, elementType, null, scopeRef);
            }
            dataNumElements = constantArrayList.getElements().size();
         }
         // Pad output to match declared size (if larger than the data list)
         if(!(value instanceof ConstantArrayKickAsm)) {
            Integer declaredSize = getArrayDeclaredSize(valueArraySpec.getArraySize());
            if(declaredSize != null && declaredSize > dataNumElements) {
               long paddingSize = declaredSize - dataNumElements;
               ConstantValue paddingSizeVal = new ConstantInteger(paddingSize);
               int elementSizeBytes = elementType.getSizeBytes();
               String paddingBytesAsm;
               if(elementSizeBytes > 1) {
                  // TODO: Use a SIZEOF constant for the element size ASM - combine this with ConstantArrayFilled above
                  paddingBytesAsm = AsmFormat.getAsmConstant(program, new ConstantBinary(new ConstantInteger((long) elementSizeBytes, SymbolType.NUMBER), Operators.MULTIPLY, paddingSizeVal), 99, scopeRef);
               } else {
                  paddingBytesAsm = AsmFormat.getAsmConstant(program, paddingSizeVal, 99, scopeRef);
               }
               ConstantValue zeroValue = Initializers.createZeroValue(new Initializers.ValueTypeSpec(elementType), null);
               if(zeroValue instanceof ConstantInteger | zeroValue instanceof ConstantPointer) {
                  dataChunk.addDataZeroFilled(getNumericType(elementType), paddingBytesAsm, (int) paddingSize, getEncoding(zeroValue));
               } else {
                  for(int i = 0; i < paddingSize; i++) {
                     addChunkData(dataChunk, zeroValue, elementType, null, scopeRef);
                  }
               }
            }
         }
      } else if(value instanceof ConstantString) {
         ConstantString stringValue = (ConstantString) value;
         // Ensure encoding is good
         String asmConstant = AsmFormat.getAsmConstant(program, stringValue, 99, scopeRef);
         dataChunk.addDataString(asmConstant, getEncoding(stringValue));
         if(stringValue.isZeroTerminated()) {
            dataChunk.addDataNumeric(AsmDataNumeric.Type.BYTE, "0", null);
         }
      } else if(SymbolType.BYTE.equals(valueType) || SymbolType.SBYTE.equals(valueType)) {
         dataChunk.addDataNumeric(AsmDataNumeric.Type.BYTE, AsmFormat.getAsmConstant(program, value, 99, scopeRef), getEncoding(value));
      } else if(SymbolType.WORD.equals(valueType) || SymbolType.SWORD.equals(valueType)) {
         dataChunk.addDataNumeric(AsmDataNumeric.Type.WORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef), getEncoding(value));
      } else if(SymbolType.DWORD.equals(valueType) || SymbolType.SDWORD.equals(valueType)) {
         dataChunk.addDataNumeric(AsmDataNumeric.Type.DWORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef), getEncoding(value));
      } else if(valueType instanceof SymbolTypePointer) {
         dataChunk.addDataNumeric(AsmDataNumeric.Type.WORD, AsmFormat.getAsmConstant(program, value, 99, scopeRef), getEncoding(value));
      } else if(SymbolType.BOOLEAN.equals(valueType)) {
         dataChunk.addDataNumeric(AsmDataNumeric.Type.BYTE, AsmFormat.getAsmConstant(program, value, 99, scopeRef), getEncoding(value));
      } else {
         throw new InternalError("Unhandled array element type " + valueType.toString() + " value " + value.toString(program));
      }
   }

   /**
    * Get the numeric data type to use when outputting a value type to ASM
    *
    * @param valueType The value type
    * @return The numeric data type
    */
   private static AsmDataNumeric.Type getNumericType(SymbolType valueType) {
      if(SymbolType.BYTE.equals(valueType) || SymbolType.SBYTE.equals(valueType)) {
         return AsmDataNumeric.Type.BYTE;
      } else if(SymbolType.WORD.equals(valueType) || SymbolType.SWORD.equals(valueType)) {
         return AsmDataNumeric.Type.WORD;
      } else if(SymbolType.DWORD.equals(valueType) || SymbolType.SDWORD.equals(valueType)) {
         return AsmDataNumeric.Type.DWORD;
      } else if(valueType instanceof SymbolTypePointer) {
         return AsmDataNumeric.Type.WORD;
      } else {
         throw new InternalError("Unhandled type " + valueType.toString());
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
               StatementSource statementSource = statement.getSource();
               if(warnFragmentMissing) {
                  String stmtFormat = "";
                  if(statementSource != null)
                     stmtFormat = statementSource.format();
                  program.getLog().append("Warning! Unknown fragment for statement " + statement.toString(program, false) + "\nMissing ASM fragment " + e.getFragmentSignature() + "\n" + stmtFormat);
                  asm.addLine(new AsmInlineKickAsm(".assert \"Missing ASM fragment " + e.getFragmentSignature() + "\", 0, 1", 0L, 0L));
               } else {
                  throw new CompileError("Unknown fragment for statement " + statement.toString(program, false) + "\nMissing ASM fragment " + e.getFragmentSignature(), statementSource);
               }
            } catch(CompileError e) {
               if(e.getSource() == null) {
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
   void generateStatementAsm(AsmProgram asm, ControlFlowBlock block, Statement statement, AsmCodegenAluState aluState, boolean genCallPhiEntry) {

      asm.startChunk(block.getScope(), statement.getIndex(), statement.toString(program, verboseAliveInfo));
      generateComments(asm, statement.getComments());
      // IF the previous statement was added to the ALU register - generate the composite ASM fragment
      if(aluState.hasAluAssignment()) {
         StatementAssignment assignmentAlu = aluState.getAluAssignment();
         if(!(statement instanceof StatementAssignment)) {
            throw new AsmFragmentInstance.AluNotApplicableException();
         }
         StatementAssignment assignment = (StatementAssignment) statement;
         AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.assignmentAlu(assignment, assignmentAlu, program);
         ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
         generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
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
                  aluState.setAluAssignment(assignment);
                  isAlu = true;
               }
            }
            if(!isAlu) {
               if(assignment.getOperator() == null && assignment.getrValue1() == null && isRegisterCopy(lValue, assignment.getrValue2())) {
                  //asm.addComment(lValue.toString(program) + " = " + assignment.getrValue2().toString(program) + "  // register copy " + getRegister(lValue));
               } else {
                  AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.assignment(assignment, program);
                  ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
                  generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
               }
            }
         } else if(statement instanceof StatementConditionalJump) {
            AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.conditionalJump((StatementConditionalJump) statement, block, program);
            ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
            generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
         } else if(statement instanceof StatementCall) {
            StatementCall call = (StatementCall) statement;
            Procedure procedure = getScope().getProcedure(call.getProcedure());
            if(procedure.isDeclaredIntrinsic()) {
               if(Pass1ByteXIntrinsicRewrite.INTRINSIC_MAKELONG4.equals(procedure.getFullName())) {
                  AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.makelong4(call, program);
                  ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
                  generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
               } else {
                  throw new CompileError("Intrinsic procedure not supported " + procedure.toString(program));
               }
            } else if(Procedure.CallingConvention.PHI_CALL.equals(procedure.getCallingConvention())) {
               // Generate PHI transition
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
               asm.addInstruction("jsr", CpuAddressingMode.ABS, call.getProcedure().getFullName(), false);
            } else if(Procedure.CallingConvention.STACK_CALL.equals(procedure.getCallingConvention())) {
               asm.addInstruction("jsr", CpuAddressingMode.ABS, call.getProcedure().getFullName(), false);
            }
         } else if(statement instanceof StatementCallExecute) {
            StatementCallExecute call = (StatementCallExecute) statement;
            RValue procedureRVal = call.getProcedureRVal();
            // Generate ASM for a call
            AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.call(call, indirectCallCount++,  program);
            ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
            generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
            if(!(procedureRVal instanceof ProcedureRef)) {
               asm.getCurrentChunk().setClobberOverwrite(CpuClobber.CLOBBER_ALL);
            }
         } else if(statement instanceof StatementExprSideEffect) {
            AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.exprSideEffect((StatementExprSideEffect) statement, program);
            ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
            generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
         } else if(statement instanceof StatementReturn) {
            Procedure procedure = null;
            ScopeRef scope = block.getScope();
            if(!scope.equals(ScopeRef.ROOT)) {
               procedure = getScope().getProcedure((ProcedureRef) scope);
            }
            if(procedure == null || procedure.getInterruptType() == null) {
               asm.addInstruction("rts", CpuAddressingMode.NON, null, false);
            } else {
               generateInterruptExit(asm, procedure);
            }
         } else if(statement instanceof StatementAsm) {
            StatementAsm statementAsm = (StatementAsm) statement;
            HashMap<String, Value> bindings = new HashMap<>();
            AsmFragmentInstance asmFragmentInstance = new AsmFragmentInstance(program, "inline", block.getScope(), new AsmFragmentTemplate(statementAsm.getAsmLines(), program.getTargetCpu()), bindings);
            asmFragmentInstance.generate(asm);
            AsmChunk currentChunk = asm.getCurrentChunk();

            if(statementAsm.getDeclaredClobber() != null) {
               currentChunk.setClobberOverwrite(statementAsm.getDeclaredClobber());
            } else {
               for(AsmLine asmLine : currentChunk.getLines()) {
                  if(asmLine instanceof AsmInstruction) {
                     AsmInstruction asmInstruction = (AsmInstruction) asmLine;
                     if(asmInstruction.getCpuOpcode().getMnemonic().equals("jsr")) {
                        currentChunk.setClobberOverwrite(CpuClobber.CLOBBER_ALL);
                     }
                  }
               }
            }
         } else if(statement instanceof StatementKickAsm) {
            StatementKickAsm statementKasm = (StatementKickAsm) statement;
            addKickAsm(asm, statementKasm);
            if(statementKasm.getDeclaredClobber() != null) {
               asm.getCurrentChunk().setClobberOverwrite(statementKasm.getDeclaredClobber());
            }
         } else if(statement instanceof StatementCallPointer) {
            throw new InternalError("Statement not supported " + statement);
         }
      }
   }

   /**
    * Generate ASM code for an ASM fragment instance
    *
    * @param asm The ASM program to generate into
    * @param fragmentInstanceSpec The ASM fragment instance specification
    */
   private void generateAsm(AsmProgram asm, AsmFragmentInstanceSpec fragmentInstanceSpec) {
      String initialSignature = fragmentInstanceSpec.getSignature();
      AsmFragmentInstance fragmentInstance = null;
      StringBuilder fragmentVariationsTried = new StringBuilder();
      while(fragmentInstance == null) {
         try {
            final AsmFragmentTemplateSynthesizer cpuSynthesizer = program.getAsmFragmentMasterSynthesizer().getSynthesizer(program.getTargetCpu());
            fragmentInstance = cpuSynthesizer.getFragmentInstance(fragmentInstanceSpec, program.getLog());
         } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
            // Unknown fragment - keep looking through alternative ASM fragment instance specs until we have tried them all
            String signature = fragmentInstanceSpec.getSignature();
            fragmentVariationsTried.append(signature).append(" ");
            if(fragmentInstanceSpec.hasNextVariation()) {
               fragmentInstanceSpec.nextVariation();
               if(program.getLog().isVerboseFragmentLog()) {
                  program.getLog().append("Fragment not found " + signature + ". Attempting another variation " + fragmentInstanceSpec.getSignature());
               }
            } else {
               // No more variations available - fail with an error
               throw new AsmFragmentTemplateSynthesizer.UnknownFragmentException("Fragment not found " + initialSignature + ". Attempted variations " + fragmentVariationsTried);
            }
         }
      }
      asm.getCurrentChunk().setFragment(fragmentInstance.getFragmentName());
      fragmentInstance.generate(asm);
   }

   /**
    * Generate exit-code for entering an interrupt procedure based on the interrupt type
    *
    * @param asm The assembler to generate code into
    * @param procedure The interrupt procedure
    */
   private void generateInterruptEntry(AsmProgram asm, Procedure procedure) {
      final String interruptType = procedure.getInterruptType().toLowerCase();
      AsmFragmentInstanceSpecBuilder entryFragment;
      String entryName;
      if(interruptType.contains("clobber")) {
         entryFragment = AsmFragmentInstanceSpecBuilder.interruptEntry(interruptType.replace("clobber", "all"), program);
         entryName = entryFragment.getAsmFragmentInstanceSpec().getSignature().replace("all", "clobber");
      } else {
         entryFragment = AsmFragmentInstanceSpecBuilder.interruptEntry(interruptType, program);
         entryName = entryFragment.getAsmFragmentInstanceSpec().getSignature();
      }
      try {
         asm.startChunk(procedure.getRef(), null, "interrupt(" + entryName + ")");
         generateAsm(asm, entryFragment.getAsmFragmentInstanceSpec());
      } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
         throw new CompileError("Interrupt type not supported " + procedure.getInterruptType() + " int " + procedure.toString() + "\n" + e.getMessage());
      }
   }

   /**
    * Generate exit-code for ending an interrupt procedure based on the interrupt type
    *
    * @param asm The assembler to generate code into
    * @param procedure The procedure
    */
   private void generateInterruptExit(AsmProgram asm, Procedure procedure) {
      final String interruptType = procedure.getInterruptType().toLowerCase();
      AsmFragmentInstanceSpecBuilder entryFragment;
      String entryName;
      if(interruptType.contains("clobber")) {
         entryFragment = AsmFragmentInstanceSpecBuilder.interruptExit(interruptType.replace("clobber", "all"), program);
         entryName = entryFragment.getAsmFragmentInstanceSpec().getSignature().replace("all", "clobber");
      } else {
         entryFragment = AsmFragmentInstanceSpecBuilder.interruptExit(interruptType, program);
         entryName = entryFragment.getAsmFragmentInstanceSpec().getSignature();
      }
      asm.startChunk(procedure.getRef(), null, "interrupt(" + entryName + ")");
      try {
         generateAsm(asm, entryFragment.getAsmFragmentInstanceSpec());
      } catch(AsmFragmentTemplateSynthesizer.UnknownFragmentException e) {
         throw new CompileError("Interrupt type not supported " + procedure.getInterruptType() + " int " + procedure.toString() + "\n" + e.getMessage());
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
            asm.addInstruction("JMP", CpuAddressingMode.ABS, AsmFormat.asmFix(toBlock.getLabel().getLocalName()), false);
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
         asm.getCurrentChunk().setSubStatementId(transition.getTransitionId());
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
            asm.getCurrentChunk().setSubStatementId(transition.getTransitionId());
            asm.getCurrentChunk().setSubStatementIdx(assignment.getAssignmentIdx());
            if(isRegisterCopy(lValue, rValue)) {
               asm.getCurrentChunk().setFragment("register_copy");
            } else {
               AsmFragmentInstanceSpecBuilder asmFragmentInstanceSpecBuilder = AsmFragmentInstanceSpecBuilder.assignment(lValue, rValue, program, scope);
               ensureEncoding(asm, asmFragmentInstanceSpecBuilder);
               generateAsm(asm, asmFragmentInstanceSpecBuilder.getAsmFragmentInstanceSpec());
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
   private static void ensureEncoding(AsmProgram asm, AsmFragmentInstanceSpecBuilder asmFragmentInstance) {
      asm.ensureEncoding(getEncoding(asmFragmentInstance));
   }

   private static void ensureEncoding(AsmProgram asm, Value value) {
      asm.ensureEncoding(getEncoding(value));
   }

   /**
    * Examine a constantvalue to see if any string encoding information is present
    *
    * @param value The constant to examine
    * @return Any encoding found inside the constant
    */
   private static Set<StringEncoding> getEncoding(Value value) {
      LinkedHashSet<StringEncoding> encodings = new LinkedHashSet<>();
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
   private static Set<StringEncoding> getEncoding(AsmFragmentInstanceSpecBuilder asmFragmentInstance) {
      LinkedHashSet<StringEncoding> encodings = new LinkedHashSet<>();
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
