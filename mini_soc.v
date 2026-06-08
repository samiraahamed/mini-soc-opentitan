module mini_soc (
    input clk,
    input reset,
    output reg [7:0] peripheral_out,
    output [3:0] pc_out,
    output reg peripheral_strobe
);
    reg [7:0] rom [0:15];
    reg [7:0] ram [0:15];
    reg [7:0] acc;
    reg [3:0] pc;
    reg [3:0] mar;
    
    wire [3:0] opcode = rom[pc][7:4];
    wire [3:0] operand = rom[pc][3:0];
    
    assign pc_out = pc;
    
    initial begin
        ram[0]=0; ram[1]=0; ram[2]=8; ram[3]=7;
        ram[4]=0; ram[5]=0; ram[6]=0; ram[7]=0;
        ram[8]=0; ram[9]=0; ram[10]=0; ram[11]=0;
        ram[12]=0; ram[13]=0; ram[14]=0; ram[15]=0;
        
        rom[0] = 8'b0001_0010;
        rom[1] = 8'b0010_0010;
        rom[2] = 8'b0011_1111;
        rom[3] = 8'b0100_0000;
        rom[4]=0; rom[5]=0; rom[6]=0; rom[7]=0;
        rom[8]=0; rom[9]=0; rom[10]=0; rom[11]=0;
        rom[12]=0; rom[13]=0; rom[14]=0; rom[15]=0;
        
        peripheral_out = 0;
        peripheral_strobe = 0;
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 0;
            pc <= 0;
            mar <= 0;
            peripheral_strobe <= 0;
        end else begin
            peripheral_strobe <= 0;
            
            case (opcode)
                4'b0001: begin
                    mar <= operand;
                    acc <= ram[operand];
                    pc <= pc + 1;
                end
                4'b0010: begin
                    mar <= operand;
                    acc <= acc + ram[operand];
                    pc <= pc + 1;
                end
                4'b0011: begin
                    if (operand == 8'b1111) begin
                        peripheral_strobe <= 1;
                        peripheral_out <= acc;
                    end else begin
                        ram[operand] <= acc;
                    end
                    pc <= pc + 1;
                end
                4'b0100: ;
                default: pc <= pc + 1;
            endcase
        end
    end
endmodule

module testbench;
    reg clk, reset;
    wire [7:0] peripheral_out;
    wire [3:0] pc_out;
    wire peripheral_strobe;
    
    mini_soc uut (
        .clk(clk),
        .reset(reset),
        .peripheral_out(peripheral_out),
        .pc_out(pc_out),
        .peripheral_strobe(peripheral_strobe)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $display("\n");
        $display("╔══════════════════════════════════════════════════════════╗");
        $display("║                    WAVEFORM TABLE                        ║");
        $display("╠══════════════════════════════════════════════════════════╣");
        $display("║ Time │ CLK │ PC │ ACC │ OUT │ STROBE │ Operation        ║");
        $display("╠══════╪═════╪════╪═════╪═════╪════════╪══════════════════╣");
        
        reset = 1;
        #10 reset = 0;
        
        #10;  $display("║ %3t  │  %b  │  %d  │  %d  │  %d  │   %b    │ LDA RAM[2]=8   ║", $time, clk, pc_out, uut.acc, peripheral_out, peripheral_strobe);
        #10;  $display("║ %3t  │  %b  │  %d  │  %d  │  %d  │   %b    │ ADD RAM[2]=16  ║", $time, clk, pc_out, uut.acc, peripheral_out, peripheral_strobe);
        #10;  $display("║ %3t  │  %b  │  %d  │  %d  │  %d  │   %b    │ OUT → 16       ║", $time, clk, pc_out, uut.acc, peripheral_out, peripheral_strobe);
        #10;  $display("║ %3t  │  %b  │  %d  │  %d  │  %d  │   %b    │ HLT            ║", $time, clk, pc_out, uut.acc, peripheral_out, peripheral_strobe);
        
        $display("╚══════╧═════╧════╧═════╧═════╧════════╧══════════════════╝");
        $display("\n                    FINAL VALUE: %0d", peripheral_out);
        $display("\n✓ WAVEFORM CAPTURED - PROJECT COMPLETE ✓");
        $finish;
    end
endmodule
