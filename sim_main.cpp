// For std::unique_ptr
#include <memory>

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"
#include "test/read_transaction.h"

int main(int argc, char** argv) {
    // Prevent unused variable warnings
    if (false && argc && argv) {}

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    // Construct a VerilatedContext to hold simulation time, etc.
    // Multiple modules (made later below with Vtop) may share the same
    // context to share time, or modules may have different contexts if
    // they should be independent from each other.

    // Using unique_ptr is similar to
    // "VerilatedContext* contextp = new VerilatedContext" then deleting at end.
    // Do not instead make Vtop as a file-scope static variable, as the
    // "C++ static initialization order fiasco" may cause a crash
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    // Verilator must compute traced signals
    contextp->traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    contextp->commandArgs(argc, argv);

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v".
    // Using unique_ptr is similar to "Vtop* top = new Vtop" then deleting at end.
    // "TOP" will be the hierarchical name of the module.
    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

	// ------ call test functions here ------ //
	single_read_transaction(contextp, top);
	

    top->final(); // Final model cleanup

    // Coverage analysis (calling write only after the test is known to pass)
#if VM_COVERAGE
	Verilated::mkdir("logs");
	contextp->coveragep()->write("logs/coverage.dat");
#endif

    return 0; // don't use exit()
}
