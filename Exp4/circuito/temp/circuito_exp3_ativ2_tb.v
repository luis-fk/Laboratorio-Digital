`timescale 1ns/1ns

module circuito_exp3_ativ2_tb ();
    reg        clock;
    reg        zera;
    reg        carrega;
    reg        conta;
    reg  [3:0] chaves;

    wire       menor;
    wire       maior;
    wire       igual;
    wire       fim;
    wire [3:0] db_contagem;

    circuito_exp3_ativ2 UUT(.clock(clock), .zera(zera), .carrega(carrega), .conta(conta), 
                            .chaves(chaves), .menor(menor), .maior(maior), .igual(igual),
                            .fim(fim), .db_contagem(db_contagem));

    integer errors = 0;
    task Check;
        input [15:0] expect;
        if (expect[15:8] !== expect[7:0]) begin
            $display("Got %b, expected %b", expect[15:8], expect[7:0]);
            errors = errors + 1;
        end
    endtask

    initial begin
        $display("Condicoes inicias");
        clock = 1'b1; 
        zera = 1'b0;
        carrega = 1'b0;
        conta = 1'b0;
        chaves = 4'b0000;
        #100
        
        clock = 1'b1;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0000_0_0_0_1});

        $display("Zerar contador e observar a saida da contagem");
        clock = 1'b0;
        zera = 1'b1;
        clock = 1'b1;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0000_0_0_0_1});

        $display("Ajustar chaves para 0001");
        clock = 1'b0;
        zera = 1'b0;
        chaves = 4'b0001;
        clock = 1'b1;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0000_0_0_1_0});

        $display("Incrementar contador e chaves=0001");
        clock = 1'b0;
        conta = 1'b1;
        clock = 1'b1;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0001_0_0_0_1});

        $display("Incrementar contador para 3 e ajustar chaves para 0010");
        conta = 1'b1;
        
        clock = 1'b0; #10 clock = 1'b1; #10
        clock = 1'b0; #10 clock = 1'b1; #10

        chaves = 4'b0010;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0011_0_1_0_0});

        $display("Ajustar chaves para 0110");
        chaves = 4'b0110;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b0011_0_0_1_0});

        $display("Incrementar contador ate 1110");
        clock = 1'b0;
        conta = 1'b1;

        clock = 1'b1; clock = 1'b0; #10 clock = 1'b1; clock = 1'b0; #10
        clock = 1'b1; clock = 1'b0; #10 clock = 1'b1; clock = 1'b0; #10
        clock = 1'b1; clock = 1'b0; #10 clock = 1'b1; clock = 1'b0; #10
        clock = 1'b1; clock = 1'b0; #10 clock = 1'b1; clock = 1'b0; #10
        clock = 1'b1; clock = 1'b0; #10 clock = 1'b1; clock = 1'b0; #10
        clock = 1'b1; clock = 1'b0; 
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b1110_0_1_0_0});

        $display("Incrementar contador");
        clock = 1'b0;
        conta = 1'b1;
        clock = 1'b1;
        #10
        Check({db_contagem, fim, maior, menor, igual, 8'b1111_1_1_0_0});

        $display ("Test ended: %2d errors", errors);
        $finish;
    end
endmodule

