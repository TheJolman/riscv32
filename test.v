reg [31.0] instruction_memory [0:1023];

initial begin
  $readmemh("build/test.hex", instruction_memory);
end
