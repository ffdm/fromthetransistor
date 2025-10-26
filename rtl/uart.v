module uart (
  input clk,
  input rst, 
  input [7:0] tx_data,
  input tx_valid,
  output reg tx_ready,
  output reg tx
);

localparam IDLE = 0;
localparam START = 1;
localparam DATA = 2;
localparam STOP = 3;

reg [1:0] state;
reg [2:0] bit_counter;
reg [7:0] tx_data_reg;
reg [11:0] baud_counter;

always @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
    bit_counter <= 3'b0;
    baud_counter <= 12'b0;
  end else begin
    case (state)
      IDLE: begin
        tx <= 1'b1;
        bit_counter <= 3'b0;
        if (tx_valid) begin
          state <= START; 
          tx_data_reg <= tx_data;
          tx_ready <= 1'b0;
        end else tx_ready <= 1'b1;
      end
      START: begin
        tx_ready <= 1'b0;
        tx <= 1'b0;
        if (baud_counter == 12'd2812) begin
          state <= DATA;
          baud_counter <= 12'b0;
        end else baud_counter <= baud_counter + 1;
      end
      DATA: begin
        tx <= tx_data_reg[bit_counter]; 
        if (baud_counter == 12'd2812) begin
          bit_counter <= bit_counter + 1;
          baud_counter <= 12'b0;
        end else baud_counter <= baud_counter + 1;
        if (bit_counter == 3'd7 && baud_counter == 12'd2812) begin
          state <= STOP;
        end
      end
      STOP: begin
        tx <= 1'b1;
        if (baud_counter == 12'd2812) begin
          state <= IDLE;
          baud_counter <= 12'b0;
        end else baud_counter <= baud_counter + 1;
      end
    endcase
  end
end

endmodule
