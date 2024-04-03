`include "quadra.svh"

module quadra_top
(
    input  ck_t clk,
    input  rs_t rst_b,
    input  x_t  x,
    input  dv_t x_dv,
    output y_t  y,
    output dv_t y_dv
);
    // Pipeline data valid (3 stages):
    dv_t dv_p0, dv_p1, dv_p2;

	 x_t x_p0;

	 y_t y_p2;

    always_ff @(posedge clk)
    if (!rst_b) begin
        dv_p0 <= '0;
        dv_p1 <= '0;
        dv_p2 <= '0;
    end
    else begin
        dv_p0 <= x_dv;
        dv_p1 <= dv_p0;
        dv_p2 <= dv_p1;
    end
	 
	 always_ff @(posedge clk)
    if (!rst_b) begin
        x_p0 <= '0;
    end
    else if (x_dv) begin
        x_p0 <= x;
    end

    // <challenge!>
	 quadra u_quadra ( .clk_i   (clk),
	                   .rst_i   (rst_b),
							 .dv_p0_i (dv_p0),
							 .dv_p1_i (dv_p1),
							 .dv_p2_i (dv_p2),
							 .x_p0_i  (x_p0),
							 .y_p2_o  (y_p2));

    // Outputs:
    always_comb y_dv = dv_p2;
    always_comb y    = y_p2;

endmodule
