/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp4_tb.vhd
 * Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para circuito da Experiencia 4 
 *
 *             1) plano de teste: 16 casos de teste
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     16/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp5_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;
    wire       pronto_out;
    wire       acertou_out;
    wire       errou_out;
    wire       db_igual_out;
    wire       db_iniciar_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_chaves_out;
    wire [6:0] db_estado_out;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp4_desafio dut (
      .clock      (clock_in),
      .reset      (reset_in),
      .iniciar    (iniciar_in),
      .chaves     (chaves_in),
      .pronto     (pronto_out),
      .acertou    (acertou_out),
      .errou      (errou_out),
      .db_igual   (db_igual_out),
      .db_iniciar (db_iniciar_out),
      .db_contagem(db_contagem_out),
      .db_memoria (db_memoria_out),
      .db_chaves  (db_chaves_out),
      .db_estado  (db_estado_out)
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      //CASO EM QUE NÃO OCORRE ERRO
      // Teste 1 (resetar circuito)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // Teste 2 (ajustar chaves para 0100, acionar iniciar por 1 periodo de clock)
      caso = 2;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      // pulso em iniciar
      iniciar_in = 1;
      #(clockPeriod);
      iniciar_in = 0;

      // Teste 3 (acerta a 1 tentativa)
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(2*clockPeriod);


      // Teste 4 (acerta a 2 tentativa)
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      
      // Teste 5 (acerta a 3 tentativa)
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      
      // Teste 6 (acerta na 4 tentativa)
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(3*clockPeriod);

      // Teste 7 (acerta na 5 tentativa)
      caso = 7;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      
      // Teste 8 (acerta na 6 tentativa)
      caso = 8;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      
      // Teste 9 (acerta na 7 tentativa)
      caso = 9;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(3*clockPeriod);
      
      // Teste 10 (acerta na 8 tentativa)
      caso = 10;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(3*clockPeriod);
      
      // Teste 11 (acerta na 9 tentativa)
      caso = 11;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      
      // Teste 12 (acerta na 10 tentativa)
      caso = 12;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);

      // Teste 13 (acerta na 11 tentativa)
      caso = 13;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);

      // Teste 14 (acerta na 12 tentativa)
      caso = 14;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      
      // Teste 15 (acerta na 13 tentativa)
      caso = 15;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(3*clockPeriod);
      
      // Teste 16 (acerta na 14 tentativa)
      caso = 16;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(3*clockPeriod);
      
      // Teste 17 (acerta na 15 tentativa)
      caso = 17;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(3*clockPeriod);
      
      // Teste 18 (acerta na 16 tentativa)
      caso = 18;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      

      //CASO EM QUE OCORRE O ERRO NA 4° TENTATIVA
      // condicoes iniciais
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      // Teste 19 (resetar circuito)
      caso = 19;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;

      // Teste 20 (ajustar chaves para 0100, acionar iniciar por 1 periodo de clock)
      caso = 20;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      // pulso em iniciar
      iniciar_in = 1;
      #(clockPeriod);
      iniciar_in = 0;

      // Teste 21 (acerta a 1 tentativa)
      caso = 21;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(2*clockPeriod);
      

      // Teste 22 (acerta a 2 tentativa)
      caso = 22;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      

      // Teste 23 (acerta a 3 tentativa)
      caso = 23;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(3*clockPeriod);
      

      // Teste 24 (acerta na 4 tentativa)
      caso = 24;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(3*clockPeriod);
      

      // Teste 25 (erra na 5 tentativa (contador 4))
      caso = 25;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(3*clockPeriod);
      

      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end
  endmodule
