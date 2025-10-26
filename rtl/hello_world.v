module hello_world (
  input clk,
  input rst,
  output uart_tx
);

localparam IDLE = 0;
localparam WAIT = 1;
localparam SEND = 2;

localparam MESSAGE_SIZE = 13;
localparam DATA_SIZE = MESSAGE_SIZE + 2;

reg [8*DATA_SIZE-1:0] data = {"Hello, world!", 16'h0a0d};
reg [3:0] byte_counter;
reg [24:0] idle_counter;
reg [1:0] state;
reg [7:0] tx_data;
wire tx_valid;
wire tx_ready;

assign tx_valid = state == SEND;

always @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
    byte_counter <= 4'b0;
    idle_counter <= 25'b0;
  end
  else begin 
    case(state)
      IDLE: begin
        idle_counter <= idle_counter + 1;
        if (idle_counter > 25'd27_000_000) state <= SEND;
      end
      SEND: begin
        byte_counter <= byte_counter + 1;
        tx_data <= data[8*(DATA_SIZE - byte_counter)-1 -: 8];
        state <= WAIT;
        idle_counter <= 25'b0;
      end
      WAIT: begin
        if (byte_counter == DATA_SIZE) state <= IDLE;
        else if (tx_ready) state <= SEND;
      end
    endcase
  end
end

uart u (
  .clk(clk), 
  .rst(rst),
  .tx_data(tx_data),
  .tx_valid(tx_valid),
  .tx_ready(tx_ready),
  .tx(uart_tx)
);

endmodule
