module cpu_tb;
  reg [31:0] imem [0:1023];
  reg [31:0] pc;
  wire [31:0] instruction;

  initial begin
    $readmemh("build/simple.hex", imem);
    pc = 0;
  end

  assign instruction = imem[pc[11:2]];

endmodule
