module TrafficLight(
    output reg red,
    output reg yellow,
    output reg green,
    input clk,
    input rst_an
);

  // States
  parameter RED=2'b00, YELLOW=2'b01, GREEN=2'b10;
  
  // Duration (in clock cycles)
  parameter RED_TIME=5, GREEN_TIME=3, YELLOW_TIME=2;
  
  reg [1:0] present, next;
  reg [3:0] counter;   // counter to hold state duration

  // Sequential block
  always @(posedge clk or negedge rst_an) begin
    if(!rst_an) begin
      present <= RED;
      counter <= 0;
    end else begin
      if(counter == 0) begin
        present <= next;   // move to next state
        case(next)
          RED:    counter <= RED_TIME-1;
          GREEN:  counter <= GREEN_TIME-1;
          YELLOW: counter <= YELLOW_TIME-1;
        endcase
      end else begin
        counter <= counter - 1;
      end
    end
  end

  // Next state logic
  always @(*) begin
    next = present;
    case(present)
      RED:    next = GREEN;
      GREEN:  next = YELLOW;
      YELLOW: next = RED;
    endcase
  end

  // Output logic
  always @(*) begin
    red=0; yellow=0; green=0;
    case(present)
      RED:    red=1;
      GREEN:  green=1;
      YELLOW: yellow=1;
    endcase
  end

endmodule


// ===================== TESTBENCH =====================
module trafficlighttb;
  reg clk, rst_an;
  wire red, green, yellow;

  // Instantiate DUT
  TrafficLight dut(red,yellow,green,clk,rst_an);

  initial begin
    $monitor ($time,": RED=%b YELLOW=%b GREEN=%b clk=%b",
              red,yellow,green,clk);

    clk=0; rst_an=0;
    #10 rst_an=1;
    #1000 $finish;   // run long enough to see multiple cycles
  end

  // Clock generation
  always #50 clk = ~clk;  // 100 time units per period
endmodule

