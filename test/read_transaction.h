#ifndef TEST_CASE_H
#define TEST_CASE_H // guard

#include <memory>
#include <verilated.h>
#include "Vtop.h"

int tick(const std::unique_ptr<VerilatedContext> & contextp, const std::unique_ptr<Vtop> & top, int num);

int single_read_transaction(const std::unique_ptr<VerilatedContext> & contextp, const std::unique_ptr<Vtop> & top);

#endif // guard
