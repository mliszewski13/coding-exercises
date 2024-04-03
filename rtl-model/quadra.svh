// quadra.svh

`ifndef QUADRA_SVH
`define QUADRA_SVH

typedef logic ck_t; // clock
typedef logic rs_t; // reset
typedef logic dv_t; // data valid

// --------------------------------------------------------------------------------
// I/O precision
// --------------------------------------------------------------------------------

// x in [0,2) -> u1.23
localparam int  X_I =  1;          //         =  1
localparam int  X_F = 23;          //         = 23
localparam int  X_W = X_I + X_F;   //  1 + 23 = 24 (u1.23)

typedef logic [X_W-1:0] x_t;

// y [-2,2) -> s2.23
localparam int  Y_I =  2;          //         =  2
localparam int  Y_F = 23;          //         = 23
localparam int  Y_W = Y_I + Y_F;   //  2 + 23 = 25 (s2.23)

typedef logic signed [Y_W-1:0] y_t;

// --------------------------------------------------------------------------------
// Internal precision:
// --------------------------------------------------------------------------------

// <challenge!>

// x1 -> u1.6
localparam int  X1_I = 1;                   //          =  1
localparam int  X1_F = 6;                   //          =  6
localparam int  X1_W = X1_I + X1_F;         //   1 + 6  =  7
typedef logic [X1_W-1:0] x1_t;

// x2 -> u0.23 (6 MSBs of the fractional part are cut off)
localparam int  X2_I = 0;                   //          =  0
localparam int  X2_F = X_F;                 //          = 23
localparam int  X2_W = X_F - X1_F;          //  23 -  6 = 17
typedef logic [X2_W-1:0] x2_t;

localparam int A_I =  4;                    //          =  4
localparam int A_F = 28;                    //          = 28
localparam int A_W = A_I + A_F;             //   4 + 28 = 32
typedef logic signed [A_W-1:0] a_t;

localparam int B_I =  4;                    //          =  4
localparam int B_F = 28;                    //          = 28
localparam int B_W = B_I + B_F;             //   4 + 28 = 32
typedef logic signed [B_W-1:0] b_t;

localparam int C_I =  4;                    //          =  4
localparam int C_F = 28;                    //          = 28
localparam int C_W = C_I + C_F;             //   4 + 28 = 32
typedef logic signed [C_W-1:0] c_t;

localparam int SQ_I = X2_I + X2_I;          //   0 +  0 =  0 
localparam int SQ_F = X2_F + X2_F;          //  23 + 23 = 46
localparam int SQ_W = SQ_I + X2_W + X2_W;   //   0 + 34 = 34
typedef logic [SQ_W-1:0] sq_t;

localparam int T0_I = A_I;                  //          =  4
localparam int T0_F = A_F;                  //          = 28
localparam int T0_W = T0_I + T0_F;          //   4 + 28 = 32
typedef logic signed [T0_W-1:0] t0_t;

localparam int T1_I = B_I  + X2_I;          //   4 +  0 =  4
localparam int T1_F = B_F  + X2_F;          //  28 + 23 = 51
localparam int T1_W = T1_I + T1_F;          //   4 + 51 = 55
typedef logic signed [T1_W-1:0] t1_t;

localparam int T2_I = C_I  + SQ_I;          //   4 +  0 =  4
localparam int T2_F = C_F  + SQ_F;          //  28 + 46 = 74
localparam int T2_W = T2_I + T2_F;          //   4 + 74 = 78
typedef logic signed [T2_W-1:0] t2_t;

// T2 is the largest of T0, T1 and T2
localparam int Y_FULL_I = T2_I + 1;             //   4 +  1 =  5
localparam int Y_FULL_F = T2_F;                 //          = 74
localparam int Y_FULL_W = Y_FULL_I + Y_FULL_F;  //   5 + 74 = 79
typedef logic signed [Y_FULL_W-1:0] y_full_t;

`endif
