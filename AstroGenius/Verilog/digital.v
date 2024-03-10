module circuito_jogo_base (
    input  [3:0] botoes        ,
    input        jogar         ,
    input        reset         ,
    input        clock         ,
    output [3:0] leds          , 
    output       ganhou        ,
    output       perdeu        ,
    output       pronto        ,

    /* Sinais de depuração */
    output       db_iniciar    , 
    output       db_igual      ,
    output       db_tem_jogada , 
	output       db_timeout    ,
    output [3:0] db_contagem   ,
    output [3:0] db_memoria    ,
    output [3:0] db_estado     ,
    output [3:0] db_jogadafeita,
    output [3:0] db_rodada
);

    /* diversos wires usados para conexão entre os módulos abaixo */
    wire [3:0] s_chaves  ;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria ;
    wire [3:0] s_estado  ;
	wire [15:0] s_contagem_inativo;
    wire fim_jogada          ; 
    wire wireConta_jogada    ;
    wire wireZera_jogada     ;
    wire wireZeraR           ;
    wire wireRegistraR       ;
    wire wireIgual           ;
    wire wureJogada          ;
    wire wire_zera_mostra_led;
    wire wire_conta_mostra_led;
    wire [3:0] wire_db_jogada;
    wire [3:0] wire_db_rodada;
	wire wireZeraInativo     ;
	wire wireContaInativo    ;
	wire wireInativo         ;
    wire wireFim_rodada      ;
    wire wireFim_jogo        ;
    wire wireZera_rodada     ;
    wire wireConta_rodada    ;
	wire wireRamWE           ;

    wire wire_fim_mostra_led ;
    // wire wireLed;
    // and (wireLed, ~wire_fim_mostra_led, wire_conta_mostra_led);

    // se estado = mostra leds, exibir valor de mem[0] = 0001; se não, mostrar botões
    // assign leds = (db_estado == 4'b1100) ? 4'b0001 : botoes;
    // assign leds = botoes | {3'b0, wireLed};
    // or (leds[0], botoes[0], wireLed);


    /* assigns usados para contctar as saídas dos módulos abaixo
       com a saída desse circuito */
    assign db_iniciar = jogar  ;
    assign db_igual = wireIgual;
    assign s_chaves = botoes   ;
	 
    /* fluxo de dados responsável pelo funcionamento do circuito 
       quando se trata de mudança de valores internos do sistema */
    fluxo_dados fluxo (
        .clock               (  clock               ),
        .zera_jogada         (  wireZera_jogada     ),
        .conta_jogada        (  wireConta_jogada    ),
        .zera_rodada         (  wireZera_rodada     ),
        .conta_rodada        (  wireConta_rodada    ),
        .zeraR               (  wireZeraR           ),
        .registraR           (  wireRegistraR       ),
        .botoes              (  botoes              ),
		.zeraInativo         (  wireZeraInativo     ),
		.contaInativo        (  wireContaInativo    ),
        .zera_mostra_led     (  wire_zera_mostra_led),
        .conta_mostra_led    (  wire_conta_mostra_led),
		.ramWE               (  wireRamWE           ),
        .leds                (  leds                ), //adicionado
		.inativo             (  wireInativo         ),
        .jogada_igual        (  wireIgual           ),
        .fim_jogada          (  wireFim_jogada      ),
        .fim_rodada          (  wireFim_rodada      ),
        .fim_jogo            (  wireFim_jogo        ),
        .fim_mostra_led      (  wire_fim_mostra_led ),
        .jogada_feita        (  wireJogada          ), 
        .db_tem_jogada       (  db_tem_jogada       ),
		.db_timeout          (  db_timeout          ),
        .db_contagem         (  s_contagem          ),
        .db_memoria          (  s_memoria           ),
        .db_jogada           (  wire_db_jogada      ),
        .db_rodada           (  wire_db_rodada      )
		// .db_contagem_inativo (  s_contagem_inativo  )
    );

    /* responsável pela mudança de estados do sistema e envio
       de sinais para o mesmo */
    unidade_controle uc (
        .clock            (  clock                ),
        .reset            (  reset                ),
        .iniciar          (  jogar                ),
        .fim_jogada       (  wireFim_jogada       ), 
        .fim_rodada       (  wireFim_rodada       ),
        .fim_jogo         (  wireFim_jogo         ),

        .fim_mostra_led   (  wire_fim_mostra_led  ),

        .jogada           (  wireJogada           ), 
        .jogada_igual     (  wireIgual            ),
		.inativo          (  wireInativo          ),

        .conta_mostra_led ( wire_conta_mostra_led),
        .zera_mostra_led  ( wire_zera_mostra_led),

        .zera_jogada   (  wireZera_jogada   ),
        .conta_jogada  (  wireConta_jogada  ),
        .zera_rodada   (  wireZera_rodada   ),
        .conta_rodada  (  wireConta_rodada  ),
		.contaInativo  (  wireContaInativo  ),
        .zeraR         (  wireZeraR         ),
		.zeraInativo   (  wireZeraInativo   ),
        .registraR     (  wireRegistraR     ),
        .ganhou        (  ganhou            ),
        .perdeu        (  perdeu            ),
        .pronto        (  pronto            ),
        .db_estado     (  s_estado          ),
		.ramWE         (  wireRamWE         )
    );
	 

/* -------------------------------------------------------- */
/* abaixo estão displays para 4 saídas diferentes de 4 bits */
/* -------------------------------------------------------- */

// Mostra o contador da memoria
hexa7seg HEX0 (
    .hexa    (  s_contagem   ),
    .display (  db_contagem  )
);

// Mostra o valor da memória
hexa7seg HEX1 (
    .hexa    (  s_memoria   ),
    .display (  db_memoria  )
);

// Mostra a jogada feita
hexa7seg HEX2 (
    .hexa    (  wire_db_jogada  ),
    .display (  db_jogadafeita  )
);

// Mostra a rodada atual
hexa7seg HEX3 (
    .hexa    (  wire_db_rodada  ),
    .display (  db_rodada       )
);

// Mostra o estado atual
hexa7seg HEX5 (
    .hexa    (  s_estado   ),
    .display (  db_estado  )
);

endmodule



module fluxo_dados (
   input  clock             ,
   input  zera_jogada       ,
   input  conta_jogada      ,
   input  zera_rodada       ,
   input  conta_rodada      ,
   input  zeraR             ,
   input  registraR         ,
   input  [3:0] botoes      ,
   input  zeraInativo       ,
   input  contaInativo      ,

   input  zera_mostra_led   ,
   input  conta_mostra_led  ,

	input  ramWE             ,
   output [3:0] leds        , // adicionado
   output inativo           ,
   output jogada_igual      ,
   output fim_jogada        ,
   output fim_rodada        ,
   output fim_jogo          ,

   output fim_mostra_led    ,

   output jogada_feita      ,
   output db_tem_jogada     ,
   output db_timeout        ,
   output [3:0] db_contagem ,
   output [3:0] db_memoria  ,
   output [3:0] db_jogada   ,
   output [3:0] db_rodada   
   // output [15:0] db_contagem_inativo
   );

    // sinais internos para interligacao dos componentes
   wire ALBo, AGBo      ;
   wire [3:0] s_endereco; 
   wire [3:0] s_rodada  ;
   wire [3:0] s_chaves  ;
   wire [3:0] s_dado    ;
   wire tem_jogada      ;
   wire wireJogadaIgual ;
   wire wireConta_mostra_led;
    
   /* redirecionamento dos wires para as saídas desse módulo */
   assign db_contagem   = s_endereco     ;
   assign db_jogada     = s_chaves       ;
   assign db_memoria    = s_dado         ;
   assign db_tem_jogada = tem_jogada     ;
   assign jogada_igual  = wireJogadaIgual;
	assign db_rodada     = s_rodada       ;
	assign db_timeout    = inativo        ;
   assign wireConta_mostra_led = conta_mostra_led;
	 
   /* or responsável pelo sinal que será mandado para o
      edge_detector e para o sinal de depuração tem_jogada */
   or (tem_jogada, botoes[3], botoes[2], botoes[1], botoes[0]);

   /* detector de jogada, que por escolha do grupo fica 
      sempre resetado e é reponsável pelo sinal para quando
      o jogador faz uma nova jogada */
   edge_detector edge_detector(
      .clock (  clock        ),
      .reset (  1'b0         ),
      .sinal (  tem_jogada   ),
      .pulso (  jogada_feita )
   );


   mux2x1_n mux_leds(
      .D0 ( botoes ), 
      .D1 ( s_dado ), 
      .SEL( wireConta_mostra_led ), // é um no estado mostra_led
      .OUT( leds )
   );

   /* contador não sensível a toda borda de de subida de clock. Esse
      contador so acrescenta seu valor quando conta é ativo */
   contador_m contador_jogada (
      .clock   (  clock         ),
      .zera_as (  zera_jogada   ),
      .zera_s  (  1'b0          ),
      .conta   (  conta_jogada  ),
      .Q       (  s_endereco    ),
      .fim     (  fim_jogada    ),
      .meio    (                )
   );
   /* contador responsável por contar as rodadas */
   contador_m contador_rodada (
      .clock   (  clock         ),
      .zera_as (  zera_rodada   ),
      .zera_s  (  1'b0          ),
      .conta   (  conta_rodada  ),
      .Q       (  s_rodada      ),
      .fim     (  fim_jogo      ),
      .meio    (                )
   );

	/*contador responsável por mensurar o tempo de inatividade do jogador */
	contador_163_5k contador_inativo (
      .clock (  ~clock               ),
      .clr   (  ~zeraInativo         ),
      .ld    (  1'b1                 ),
      .ent   (  contaInativo         ),
      .enp   (  1'b1                 ),
      .D     (  4'b0000              ),
      .Q     (                       ),
      .rco   (  inativo              )
   );

   /*contador responsável por determinar o tempo de mostrar led */
	contador_163_2k contador_mostra_led (
      .clock (  ~clock            ),
      .clr   (  ~zera_mostra_led  ),
      .ld    (  1'b1              ),
      .ent   (wireConta_mostra_led),
      .enp   (  1'b1              ),
      .D     (  4'b0000           ),
      .Q     (                    ),
      .rco   (  fim_mostra_led    )
   );
    
   /* memoria pre carregada com 16 valores para teste */
   sync_ram_16x4_file mem (
      .clk     (  clock       ),
		.we      (  ramWE       ),
		.data    (  s_chaves    ),
      .addr    (  s_endereco  ),
      .q       (  s_dado      )
   );
	
	
   /* registrador utilizado para salvar a jogada feita pelo usuario */
   registrador_4 reg1 (
      .clock  (  clock      ),
      .clear  (  zeraR      ),
      .enable (  registraR  ),
      .D      (  botoes     ),
      .Q      (  s_chaves   )
   );

   /* responsável por comparar os valores da saída
      da memória com os da chave enviados pelo usuário */
   comparador_85 comparador_jogada (
      .A    (  s_dado           ),
      .B    (  s_chaves         ),
      .ALBi (  1'b0             ),
      .AGBi (  1'b0             ),
      .AEBi (  1'b1             ),
      .ALBo (  ALBo             ),
      .AGBo (  AGBo             ),
      .AEBo (  wireJogadaIgual  )
   );
   
   /* responsável por comparar a rodada atual com a jogada atual*/
   comparador_85 comparador_rodada (
   .A    (  s_rodada    ),
   .B    (  s_endereco  ),
   .ALBi (  1'b0        ),
   .AGBi (  1'b0        ),
   .AEBi (  1'b1        ),
   .ALBo (              ),
   .AGBo (              ),   
   .AEBo (  fim_rodada  )
   );
    
 endmodule




//------------------------------------------------------------------
// Arquivo   : exp4_unidade_controle.v
// Projeto   : Experiência 4 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descrição : Unidade de controle
//
// usar este código como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisões  :
//     Data        Versão  Autor             Descrição
//     14/01/2024  1.0     Edson Midorikawa  versão inicial
//------------------------------------------------------------------
//
module unidade_controle (
    input      clock           ,
    input      reset           ,
    input      iniciar         ,
    input      fim_jogada      ,
    input      fim_rodada      , 
    input      fim_jogo        , 
    input      fim_mostra_led  ,
    input      jogada          , 
    input      jogada_igual    ,
	input      inativo         ,
    output reg conta_mostra_led, 
    output reg zera_mostra_led , 
    output reg zera_jogada     ,
    output reg conta_jogada    ,
    output reg zera_rodada     ,
    output reg conta_rodada    ,
	output reg contaInativo    ,
	output reg zeraInativo     ,
    output reg zeraR           ,
    output reg registraR       ,
    output reg ganhou          ,
    output reg perdeu          ,
    output reg pronto          ,
    output reg ramWE           ,
    output reg [3:0] db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicial              = 4'b0000; // 0
    parameter inicializa_elementos = 4'b0001; // 1
    parameter inicio_da_rodada     = 4'b0010; // 2
    parameter espera_jogada        = 4'b0011; // 3
    parameter registra_jogada      = 4'b0100; // 4
    parameter compara_jogada       = 4'b0101; // 5
    parameter proxima_jogada       = 4'b0110; // 6
    parameter proxima_rodada       = 4'b0111; // 7
    parameter ultima_rodada        = 4'b1000; // 8
	parameter espera_nova          = 4'b1001; // 9 //
    parameter final_com_acertos    = 4'b1010; // A
	parameter registra_nova        = 4'b1011; // B //
    parameter mostra_led           = 4'b1100; // C //
    parameter final_com_erro       = 4'b1110; // E
	parameter final_com_timeout    = 4'b1111; // F

    // Variáveis de estado
    reg [3:0] Eatual, Eprox;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end



    always @* begin
        case (Eatual)
            inicial:              Eprox = iniciar ? inicializa_elementos : inicial;
            inicializa_elementos: Eprox = mostra_led; 
            mostra_led:           Eprox = fim_mostra_led ? inicio_da_rodada : mostra_led;

            inicio_da_rodada:     Eprox = espera_jogada;
            espera_jogada:        Eprox = (jogada && ~inativo) ? registra_jogada : 
                                           inativo ? final_com_timeout : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = ~jogada_igual ? final_com_erro : 
                                          (jogada_igual && fim_rodada) ? ultima_rodada : proxima_jogada ;

            ultima_rodada:        Eprox = fim_jogo ? final_com_acertos : espera_nova;

            // espera_nova:		  Eprox = jogada && ~inativo? registra_nova : inativo ? final_com_timeout : espera_nova;
            espera_nova:		  Eprox = inativo ? final_com_timeout : jogada ? registra_nova : espera_nova;

            registra_nova:		  Eprox = proxima_rodada;
				
            proxima_rodada:       Eprox = inicio_da_rodada;
            proxima_jogada:       Eprox = espera_jogada;
            final_com_acertos:    Eprox = iniciar ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = iniciar ? inicializa_elementos : final_com_erro;
			final_com_timeout:    Eprox = iniciar ? inicializa_elementos : final_com_timeout;
            default:              Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
	 
		ramWE          = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        zera_mostra_led  = (Eatual == inicial              ||
                            Eatual == inicializa_elementos ) ? 1'b1 : 1'b0;
        conta_mostra_led = (Eatual == mostra_led) ? 1'b1 : 1'b0;
        zera_jogada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == inicio_da_rodada     ) ? 1'b1 : 1'b0;

        conta_rodada   = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;   
        zera_rodada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == final_com_acertos    || 
                          Eatual == final_com_erro       || 
                          Eatual == final_com_timeout    ) ? 1'b1 : 1'b0;
        conta_jogada   = (Eatual == proxima_jogada || Eatual == registra_nova) ? 1'b1 : 1'b0;
        pronto         = (Eatual == final_com_acertos || 
                          Eatual == final_com_erro    || 
                          Eatual == final_com_timeout ) ? 1'b1 : 1'b0; 
        zeraR          = (Eatual == inicial || 
                          Eatual == inicializa_elementos) ? 1'b1 : 1'b0;
        registraR      = (Eatual == registra_jogada || Eatual == registra_nova) ? 1'b1 : 1'b0;
        ganhou         = (Eatual == final_com_acertos) ? 1'b1 : 1'b0; 
        perdeu         = (Eatual == final_com_erro || Eatual == final_com_timeout) ? 1'b1 : 1'b0;
		zeraInativo    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == registra_jogada      ) ? 1'b1 : 1'b0;
		contaInativo   = (Eatual == espera_jogada || Eatual == espera_nova) ? 1'b1 : 1'b0;


        // Saída de depuração (estado)
        case (Eatual)
            inicial:              db_estado = 4'b0000; // 0
            inicializa_elementos: db_estado = 4'b0001; // 1
            inicio_da_rodada:     db_estado = 4'b0010; // 2
            espera_jogada:        db_estado = 4'b0011; // 3
            registra_jogada:      db_estado = 4'b0100; // 4
            compara_jogada:       db_estado = 4'b0101; // 5
            proxima_jogada:       db_estado = 4'b0110; // 6
            proxima_rodada:       db_estado = 4'b0111; // 7
            ultima_rodada:        db_estado = 4'b1000; // 8
			espera_nova:          db_estado = 4'b1001; // 9
            final_com_acertos:    db_estado = 4'b1010; // A
			registra_nova:        db_estado = 4'b1011; // B 
            mostra_led:           db_estado = 4'b1100; // C 
            final_com_erro:       db_estado = 4'b1110; // E
	        final_com_timeout:    db_estado = 4'b1111; // F
            default:              db_estado = 4'b1101; 
        endcase
    end

endmodule



module sync_ram_16x4_file(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [3:0] q
);

    // Variavel RAM (armazena dados)
    reg [3:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        ram[4'b0] = 4'b0001;
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule



module registrador_4 (
    input        clock ,
    input        clear ,
    input        enable,
    input  [3:0] D     ,
    output [3:0] Q
);

    reg [3:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule



module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [3:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 4'h0;
        4'h1:    display = 4'h1;
        4'h2:    display = 4'h2;
        4'h3:    display = 4'h3;
        4'h4:    display = 4'h4;
        4'h5:    display = 4'h5;
        4'h6:    display = 4'h6;
        4'h7:    display = 4'h7;
        4'h8:    display = 4'h8;
        4'h9:    display = 4'h9;
        4'ha:    display = 4'ha;
        4'hb:    display = 4'hb;
        4'hc:    display = 4'hc;
        4'hd:    display = 4'hd;
        4'he:    display = 4'he;
        4'hf:    display = 4'hf;
        default: display = 4'h0;
    endcase
endmodule



module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule



module contador_m #(parameter M=16, N=4)
  (
   input  wire          clock  ,
   input  wire          zera_as,
   input  wire          zera_s ,
   input  wire          conta  ,
   output reg  [N-1:0]  Q      ,
   output reg           fim    ,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

endmodule



module comparador_85 (ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[3:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[4:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[4];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[4];
    assign AEBo = ((A == B) && AEBi);

endmodule



module contador_163_5k ( input clock       , 
                      input clr         , 
                      input ld          , 
                      input ent         , 
                      input enp         , 
                      input [3:0] D     , 
                      output reg [15:0]Q, 
                      output reg rco
                    );

	 initial begin
		Q = 16'd0;
    end
	 
    always @ (posedge clock)
        if (~clr)               Q <= 16'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 16'd5000))   rco = 1;
        else                          rco = 0;
endmodule



module contador_163_2k ( input clock       , 
                      input clr         , 
                      input ld          , 
                      input ent         , 
                      input enp         , 
                      input [3:0] D     , 
                      output reg [15:0]Q, 
                      output reg rco
                    );

	 initial begin
		Q = 16'd0;
    end
	 
    always @ (posedge clock)
        if (~clr)               Q <= 16'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 16'd2000))   rco = 1;
        else                          rco = 0;
endmodule


/*------------------------------------------------------------------------
 * Arquivo   : mux2x1_n.v
 * Projeto   : Jogo do Desafio da Memoria
 *------------------------------------------------------------------------
 * Descricao : multiplexador 2x1 com entradas de n bits (parametrizado) 
 * 
 * adaptado a partir do codigo my_4t1_mux.vhd do livro "Free Range VHDL"
 * 
 * exemplo de uso: ver testbench mux2x1_n_tb.v
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *------------------------------------------------------------------------
 */

module mux2x1_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input                 SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule