// sync_ram_16x4_tb.v

`timescale 1ns/1ns

module sync_ram_16x4_file_tb;
    reg        clk_in;
    reg        we_in;
    reg  [3:0] data_in;
    reg  [3:0] addr_in;
    wire [3:0] q_out;

    // Instancia modulo sync_ram_16x4
    sync_ram_16x4_file #(
        .BINFILE("ram_init.txt")
    ) dut (
        .clk  ( clk_in  ), 
        .we   ( we_in   ), 
        .data ( data_in ), 
        .addr ( addr_in ), 
        .q    ( q_out   )
    );

    // Geracao do clock (20ns)
    always begin
        #10 clk_in = ~clk_in;
    end

    integer caso;

    initial begin
        // Inicializa sinais
        clk_in  = 0;
        we_in   = 0;
        data_in = 4'b0000;
        addr_in = 4'b0000;

        // 1. Mostra conteudo da memoria
        caso = 1;
        $display("Antes da escrita");
        repeat(16) begin
            #20 addr_in = addr_in+1;
        end

        // Escreve 1111 no endereco 3
        caso = 2;
        $display("Escreve 1111 no endereco 3");
        #20
        @(negedge clk_in) 
        we_in   = 1;
        addr_in = 4'b0011;
        data_in = 4'b1111;
        #20 
        we_in   = 0;

        // Mostra conteudo
        caso = 3;
        $display("Depois da escrita");
        addr_in = 4'b0000;
        repeat(16) begin
            #20 addr_in = addr_in+1;
        end

        // Final do testbench
        caso = 99;
        $display("Final do testbench");
        #10 $stop;
    end
endmodule
