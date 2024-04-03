//
// Quadratic polynomial:  f(x) = a + b*x2 + c*(x2^2)
//

`include "quadra.svh"

module quadra
(
    // <challenge>
    input  ck_t clk_i,    // clock
    input  rs_t rst_i,    // reset
    input  dv_t dv_p0_i,  // data valid P0
    input  dv_t dv_p1_i,  // data valid P1
    input  dv_t dv_p2_i,  // data valid P2
    input  x_t  x_p0_i,   // input value
    output y_t  y_p2_o    // quadratic polynomial result
);

    // <challenge>
    x1_t      x1_p0;
    x2_t      x2_p0;
    x2_t      x2_p1;
    
    a_t       a_p0;
    a_t       a_p1;
    b_t       b_p0;
    b_t       b_p1;
    c_t       c_p0;
    c_t       c_p1;
    
    sq_t      sq_p0;
    sq_t      sq_p1;

    t0_t      t0_p1;
    t0_t      t0_p2;
    t1_t      t1_p1;
    t1_t      t1_p2;
    t2_t      t2_p1;
    t2_t      t2_p2;
    
    y_full_t  y_full_p2;

    //-------------
    // Stage P0
    //-------------

    // Split x into x1 and x2
    // x1 - used to pick coefficients from LUT
    // x2 - used to calculate the polynomial
    assign x1_p0 = x_p0_i[X_W-1:X2_W];
    assign x2_p0 = x_p0_i[X2_W-1:0];

    // LUT - coefficients
    lut u_lut ( .x1 (x1_p0),
                .a  (a_p0),
                .b  (b_p0),
                .c  (c_p0));

    // Squarer
    square u_square ( .x2 (x2_p0),
                      .sq (sq_p0));


    always_ff @(posedge clk_i)
    if (!rst_i) begin
        a_p1  <= '0;
        b_p1  <= '0;
        c_p1  <= '0;
        sq_p1 <= '0;
        x2_p1 <= '0;
    end
    else if (dv_p0_i) begin
        a_p1  <= a_p0;
        b_p1  <= b_p0;
        c_p1  <= c_p0;
        sq_p1 <= sq_p0;
        x2_p1 <= x2_p0;
    end


    //-------------
    // Stage P1
    //-------------

    // a coefficient used only in P2
    assign t0_p1 = a_p1;

    // Mult#1
    assign t1_p1 = b_p1 * $signed({1'b0, x2_p1});

    // Mult#2
    assign t2_p1 = c_p1 * $signed({1'b0, sq_p1});

    always_ff @(posedge clk_i)
    if (!rst_i) begin
        t0_p2 <= '0;
        t1_p2 <= '0;
        t2_p2 <= '0;
    end
    else if (dv_p1_i) begin
        t0_p2 <= t0_p1;
        t1_p2 <= t1_p1;
        t2_p2 <= t2_p1;
    end


    //-------------
    // Stage P2
    //-------------
 
    // Multi-operand adder
    assign y_full_p2 = {t0_p2, {T2_F-T0_F{1'b0}}} + {t1_p2, {T2_F-T1_F{1'b0}}} + t2_p2;

    assign y_p2_o = {
                      // Integer part truncated to Y_I, remove MSBs of integer part
                      y_full_p2[Y_FULL_W-Y_FULL_I+Y_I-1 : Y_FULL_F],
                      // Fractional part truncated to Y_F, remove LSBs of fractional part
                      y_full_p2[Y_FULL_W-Y_FULL_I-1     : Y_FULL_F-Y_F]
                    }; 

endmodule
