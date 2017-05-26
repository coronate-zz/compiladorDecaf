
#ifndef _H_codegen
#define _H_codegen

#include <cstdlib>
#include <list>
#include "tac.h"

typedef enum { Alloc, ReadLine, ReadInteger, StringEqual,
               PrintInt, PrintString, PrintBool, Halt, NumBuiltIns } BuiltIn;

class CodeGenerator {
  private:
    std::list<Instruction*> code;
    int local_loc;
    int param_loc;
    int globl_loc;

  public:

    static const int OffsetToFirstLocal = -8,
                     OffsetToFirstParam = 4,
                     OffsetToFirstGlobal = 0;
    static const int VarSize = 4;

    // Location interfaces.
    int GetNextLocalLoc();
    int GetNextParamLoc();
    int GetNextGlobalLoc();
    int GetFrameSize();
    void ResetFrameSize();

    static Location* ThisPtr;

    CodeGenerator();


    char *NewLabel();

    Location *GenTempVar();

    Location *GenLoadConstant(int value);
    Location *GenLoadConstant(const char *str);
    Location *GenLoadLabel(const char *label);

    void GenAssign(Location *dst, Location *src);

    // Generates Tac instructions to dereference addr and store value
    // into that memory location. addr should hold a valid memory address
    // (most likely computed from an array or field offset calculation).
    // The optional offset argument can be used to offset the addr by a
    // positive/negative number of bytes. If not given, 0 is assumed.
    void GenStore(Location *addr, Location *val, int offset = 0);

    // Generates Tac instructions to dereference addr and load contents
    // from a memory location into a new temp var. addr should hold a
    // valid memory address (most likely computed from an array or
    // field offset calculation). Returns the Location for the new
    // temporary variable where the result was stored. The optional
    // offset argument can be used to offset the addr by a positive or
    // negative number of bytes. If not given, 0 is assumed.
    Location *GenLoad(Location *addr, int offset = 0);

    // Generates Tac instructions to perform one of the binary ops
    // identified by string name, such as "+" or "==".  Returns a
    // Location object for the new temporary where the result
    // was stored.
    Location *GenBinaryOp(const char *opName, Location *op1, Location *op2);

    // Generates the Tac instruction for pushing a single
    // parameter. Used to set up for ACall and LCall instructions.
    // The Decaf convention is that parameters are pushed right
    // to left (so the first argument is pushed last)
    void GenPushParam(Location *param);

    // Generates the Tac instruction for popping parameters to
    // clean up after an ACall or LCall instruction. All parameters
    // are removed with one adjustment of the stack pointer.
    void GenPopParams(int numBytesOfParams);

    // Generates the Tac instructions for a LCall, a jump to
    // a compile-time label. The params to the target routine
    // should already have been pushed. If hasReturnValue is
    // true,  a new temp var is created, the fn result is stored
    // there and that Location is returned. If false, no temp is
    // created and NULL is returned
    Location *GenLCall(const char *label, bool fnHasReturnValue);

    // Generates the Tac instructions for ACall, a jump to an
    // address computed at runtime. Works similarly to LCall,
    // described above, in terms of return type.
    // The fnAddr Location is expected to hold the address of
    // the code to jump to (typically it was read from the vtable)
    Location *GenACall(Location *fnAddr, bool fnHasReturnValue);

    // Generates the Tac instructions to call one of
    // the built-in functions (Read, Print, Alloc, etc.) Although
    // you could just make a call to GenLCall above, this cover
    // is a little more convenient to use.  The arguments to the
    // builtin should be given as arg1 and arg2, NULL is used if
    // fewer than 2 args to pass. The method returns a Location
    // for the new temp var holding the result.  For those
    // built-ins with no return value (Print/Halt), no temporary
    // is created and NULL is returned.
    Location *GenBuiltInCall(BuiltIn b, Location *arg1 = NULL,
            Location *arg2 = NULL);

    // These methods generate the Tac instructions for various
    // control flow (branches, jumps, returns, labels)
    // One minor detail to mention is that you can pass NULL
    // (or omit arg) to GenReturn for a return that does not
    // return a value
    void GenIfZ(Location *test, const char *label);
    void GenGoto(const char *label);
    void GenReturn(Location *val = NULL);
    void GenLabel(const char *label);

    // These methods generate the Tac instructions that mark the start
    // and end of a function/method definition.
    BeginFunc *GenBeginFunc();
    void GenEndFunc();

    // Generates the Tac instructions for defining vtable for a
    // The methods parameter is expected to contain the vtable
    // methods in the order they should be laid out.  The vtable
    // is tagged with a label of the class name, so when you later
    // need access to the vtable, you use LoadLabel of class name.
    void GenVTable(const char *className, List<const char*> *methodLabels);

    // Emits the final "object code" for the program by
    // translating the sequence of Tac instructions into their mips
    // equivalent and printing them out to stdout. If the debug
    // flag tac is on (-d tac), it will not translate to MIPS,
    // but instead just print the untranslated Tac. It may be
    // useful in debugging to first make sure your Tac is correct.
    void DoFinalCodeGen();
};

#endif

