module mux2to1 (
    input   wire    [127:0]     in0,
    input   wire    [127:0]     in1,
    input   wire                ctrl, 
    output  wire    [127:0]     out
) ;

assign out = (ctrl) ? in1 : in0;

endmodule

