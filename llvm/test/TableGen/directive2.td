// RUN: llvm-tblgen -gen-directive-decl -I %p/../../include %s | FileCheck -match-full-lines %s
// RUN: llvm-tblgen -gen-directive-impl -I %p/../../include %s | FileCheck -match-full-lines %s -check-prefix=IMPL

include "llvm/Frontend/Directive/DirectiveBase.td"

def TestDirectiveLanguage : DirectiveLanguage {
  let name = "Tdl";

  let cppNamespace = "tdl";
  let directivePrefix = "TDLD_";
  let clausePrefix = "TDLC_";
}

def TDLC_ClauseA : Clause<"clausea"> {
  let isImplicit = 1;
}
def TDLC_ClauseB : Clause<"clauseb"> {
  let isDefault = 1;
}

def TDL_DirA : Directive<"dira"> {
  let allowedClauses = [TDLC_ClauseA, TDLC_ClauseB];
  let isDefault = 1;
}

// CHECK:       #ifndef LLVM_Tdl_INC
// CHECK-NEXT:  #define LLVM_Tdl_INC
// CHECK-EMPTY:
// CHECK-NEXT:  namespace llvm {
// CHECK-NEXT:  class StringRef;
// CHECK-NEXT:  namespace tdl {
// CHECK-EMPTY:
// CHECK-NEXT:  enum class Directive {
// CHECK-NEXT:    TDLD_dira,
// CHECK-NEXT:  };
// CHECK-EMPTY:
// CHECK-NEXT:  static constexpr std::size_t Directive_enumSize = 1;
// CHECK-EMPTY:
// CHECK-NEXT:  enum class Clause {
// CHECK-NEXT:    TDLC_clausea,
// CHECK-NEXT:    TDLC_clauseb,
// CHECK-NEXT:  };
// CHECK-EMPTY:
// CHECK-NEXT:  static constexpr std::size_t Clause_enumSize = 2;
// CHECK-EMPTY:
// CHECK-NEXT:  // Enumeration helper functions
// CHECK-NEXT:  Directive getTdlDirectiveKind(llvm::StringRef Str);
// CHECK-EMPTY:
// CHECK-NEXT:  llvm::StringRef getTdlDirectiveName(Directive D);
// CHECK-EMPTY:
// CHECK-NEXT:  Clause getTdlClauseKind(llvm::StringRef Str);
// CHECK-EMPTY:
// CHECK-NEXT:  llvm::StringRef getTdlClauseName(Clause C);
// CHECK-EMPTY:
// CHECK-NEXT:  } // namespace tdl
// CHECK-NEXT:  } // namespace llvm
// CHECK-NEXT:  #endif // LLVM_Tdl_INC


// IMPL:       Directive llvm::tdl::getTdlDirectiveKind(llvm::StringRef Str) {
// IMPL-NEXT:    return llvm::StringSwitch<Directive>(Str)
// IMPL-NEXT:      .Case("dira",TDLD_dira)
// IMPL-NEXT:      .Default(TDLD_dira);
// IMPL-NEXT:  }
// IMPL-EMPTY:
// IMPL-NEXT:  llvm::StringRef llvm::tdl::getTdlDirectiveName(Directive Kind) {
// IMPL-NEXT:    switch (Kind) {
// IMPL-NEXT:      case TDLD_dira:
// IMPL-NEXT:        return "dira";
// IMPL-NEXT:    }
// IMPL-NEXT:    llvm_unreachable("Invalid Tdl Directive kind");
// IMPL-NEXT:  }
// IMPL-EMPTY:
// IMPL-NEXT:  Clause llvm::tdl::getTdlClauseKind(llvm::StringRef Str) {
// IMPL-NEXT:    return llvm::StringSwitch<Clause>(Str)
// IMPL-NEXT:      .Case("clausea",TDLC_clauseb)
// IMPL-NEXT:      .Case("clauseb",TDLC_clauseb)
// IMPL-NEXT:      .Default(TDLC_clauseb);
// IMPL-NEXT:  }
// IMPL-EMPTY:
// IMPL-NEXT:  llvm::StringRef llvm::tdl::getTdlClauseName(Clause Kind) {
// IMPL-NEXT:    switch (Kind) {
// IMPL-NEXT:      case TDLC_clausea:
// IMPL-NEXT:        return "clausea";
// IMPL-NEXT:      case TDLC_clauseb:
// IMPL-NEXT:        return "clauseb";
// IMPL-NEXT:    }
// IMPL-NEXT:    llvm_unreachable("Invalid Tdl Clause kind");
// IMPL-NEXT:  }