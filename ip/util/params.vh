//--- Branch Comparator flags ---//
`define BC_FLAG_EQ         0    // reg_acc == reg_a
`define BC_FLAG_GT         1    // reg_a > reg_acc
`define BC_FLAG_COUNT      2

//--- ALU mode ---//
`define ALU_MODE_ADD       0
`define ALU_MODE_SHIFT     1
`define ALU_MODE_NOT       2
`define ALU_MODE_AND       3
`define ALU_MODE_OR        4
`define ALU_MODE_BYPASS_A  5       
`define ALU_MODE_BYPASS_B  6       
`define ALU_MODE_COUNT     7      

//--- utility ---//
`define LINE_COUNT           10               // change this to match line count of benchmark file
`define MEM_PATH             "benchmark.txt"  // name of benchmark file
