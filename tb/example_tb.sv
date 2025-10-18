module example_tb;

logic a, b, c;

logic passed = 1'b1;

example e (a, b, c);

initial begin
  $display("Testing...");
  repeat(1000) begin
    a = $urandom()[0]; b = $urandom()[0];
    #0.1ns
    assert(c == (a&b)) else begin
      $display("a: %b, b: %b, c: %b, a&b: %b", a, b, c, a&b);
      passed = 1'b0;
      break;
    end
  end
  if (passed) $display("\033[0;32mPassed :)\033[0m");
  else $display("\033[0;31mFailed :(\033[0m");
end

endmodule
