/* --------------------------------------------------------------------
 * Arquivo   : circuito_jogo_base_c2_tb.v
 * Projeto   : Experiencia 6
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para circuito da Experiencia 7
 *
 *             1) Plano de teste Timeout de 1ª Jogada inédita da 2ª rodada 
 *
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_jogo_base_c2_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire       ganhou_out ;
    wire       perdeu_out ;
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    // Sinais de depuração
    wire       db_timeout_out         ;
    wire       db_igual_out           ;
    wire [6:0] db_contagem_out        ;
    wire [6:0] db_memoria_out         ;
    wire [6:0] db_estado_out          ;
    wire [6:0] db_jogadafeita_out     ;
    wire [6:0] db_rodada_out          ;
    wire       db_iniciar_out         ;
    wire       db_tem_jogada_out      ;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=1KHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_jogo_base dut(
    .botoes             (botoes_in) ,
    .jogar              (iniciar_in),
    .reset              (reset_in)  ,
    .clock              (clock_in)  ,
    .leds               (leds_out)  , 
    .ganhou             (ganhou_out),
    .perdeu             (perdeu_out),
    .pronto             (pronto_out),

      /* Sinais de depuração */
    .db_iniciar         (db_iniciar_out)    ,
    .db_igual           (db_igual_out)      ,
    .db_tem_jogada      (db_tem_jogada_out) , 
	  .db_timeout         (db_timeout_out)    ,
    .db_contagem        (db_contagem_out)   ,
    .db_memoria         (db_memoria_out)    ,
    .db_estado          (db_estado_out)     ,
    .db_jogadafeita     (db_jogadafeita_out),
    .db_rodada          (db_rodada_out)
);
    
    // geração dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      botoes_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste 1 - Timeout de 1ª Jogada inédita da 2ª rodada
       */

      // resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // iniciar=1 por 10 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(10*clockPeriod);
      iniciar_in = 0;
      // espera
      #(5000*clockPeriod);


      // RODADA 0
      caso = 3;
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre rodadas
      #(10*clockPeriod);


      // Salva Jogada
      caso = 4;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre rodadas
      #(100*clockPeriod);
      











      // RODADA 1
      caso = 5;
      @(negedge clock_in);
      botoes_in = 4'b0001;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      caso = 6;
      @(negedge clock_in);
      botoes_in = 4'b0010;
      #(10*clockPeriod);
      botoes_in = 4'b0000;
      // espera entre rodadas
      #(10*clockPeriod);


      // espera
      #(10000*clockPeriod);
      caso = 139;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
