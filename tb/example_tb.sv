module example_tb;

logic a, b, c;

example e (a, b, c);

initial begin
  $display("Testing...");
  repeat(1000) begin
    a = $urandom()[0]; b = $urandom()[0];
    #0.1ns
    assert(c == a&b) else $display("c: %b, a&b: %b", c, a&b);
  end
  $display("\033[0;32mPassed!\033[0m");
end

endmodule
