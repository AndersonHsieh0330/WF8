#include <memory>
#include <verilated.h>
#include "Vtop.h"
#include <iostream>
#include <cassert>

int tick(const std::unique_ptr<VerilatedContext> & contextp, const std::unique_ptr<Vtop> & top, int num) {
	// note that clk starts advancing on the second time we call timeInc(1)
	for (int i = 0 ; i < num ; i++) {
		contextp->timeInc(1);
		top->clk = !top->clk;
		top->eval();
	}
	return 0;
}

int single_read_transaction(const std::unique_ptr<VerilatedContext> & contextp, const std::unique_ptr<Vtop> & top) {
	// initial setup
	top->RXF_N = 1;
	top->clk   = 0;
	top->rst = 1;
	top->DATA_in=0x0000ef00; // channel 1 ready for read

	// Idle phase, master poll for available FIFO channel
	tick(contextp, top, 4);
	top->rst = 0;

	while (top->WR_N != 0) tick(contextp, top, 2);

	// Command phase
	tick(contextp, top, 1);
	assert((top->DATA & 0x000000ff) == 0x00000001);	// channel 1
	assert(top->BE == 0x00);						// read
	tick(contextp, top, 1);

	// Bus turn around 1
	tick(contextp, top, 4);

 	// Data phase
 	top->RXF_N = 0;
 
 	top->DATA_in = 0x76543210;
 	top->BE=0xf;
 	tick(contextp, top, 2);
 
 	top->DATA_in = 0xfedcba98;
 	top->BE=0xf;
 	tick(contextp, top, 2);
 
 	top->DATA_in = 0x76543210;
 	top->BE=0x3;
 	tick(contextp, top, 2);
 
 	top->RXF_N = 1;
 
 	// Bus turn around 2
	// Master an bus again except for DATA[15:8]
 	tick(contextp, top, 2);

 	// Back to Idle
	top->DATA_in=0x0000ff00; // channel 1 ready for read
 	tick(contextp, top, 2);
	assert(top->DATA == 0xffffffff);
	assert(top->BE == 0xf);

	return 0;
}

