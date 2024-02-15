module circuito_jogo_base (
    input  [3:0] botoes,
    input        jogar,
    input        reset,
    input        clock,
    
    output       ganhou,
    output       perdeu,
    output       pronto,

    /* Sinais de depuração */
    output       db_clock, /* acho que pode tirar */
    output       db_iniciar, /* esse também */
    output       db_igual,
    output       db_tem_jogada, 
	output       db_timeout,
    output [3:0] leds, 
    output [3:0] db_jogadafeita,
	output [3:0] db_contagem_inativo,
    output [3:0] db_rodada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_estado
    
    

);

    /* diversos wires usados para conexão entre os módulos abaixo */
    wire [3:0] s_chaves;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
	wire [3:0] s_contagem_inativo;
    wire fim_jogada; 
    wire wireConta_jogada;
    wire wireZera_jogada;
    wire wireZeraR;
    wire wireRegistraR;
    wire wireIgual;
    wire wureJogada;
    wire [3:0] wire_db_jogada;
    wire [3:0] wire_db_rodada;
	wire wireZeraInativo;
	wire wireContaInativo;
	wire wireInativo;
    wire wireFim_rodada;
    wire wireFim_jogo;
    wire wireZera_rodada;
    wire wireConta_rodada;

    /* assigns usados para contctar as saídas dos módulos abaixo
       com a saída desse circuito */
    assign db_iniciar = jogar;
    assign db_igual = wireIgual;
    assign leds = s_memoria;
    assign s_chaves = botoes;
    assign db_clock = clock;
    assign db_rodada = wire_db_rodada;


    /* fluxo de dados responsável pelo funcionamento do circuito 
       quando se trata de mudança de valores internos do sistema */
    fluxo_dados fluxo (
        .clock               (     clock      ),
        .zera_jogada         ( wireZera_jogada  ),
        .conta_jogada        ( wireConta_jogada ),
        .zera_rodada         ( wireZera_rodada),
        .conta_rodada        ( wireConta_rodada),
        .zeraR               (    wireZeraR   ),
        .registraR           (  wireRegistraR ),
        .botoes              (     botoes     ),
		.zeraInativo         ( wireZeraInativo),
		.contaInativo        ( wireContaInativo),
		.inativo             (  wireInativo   ),
        .jogada_igual        (   wireIgual    ),
        .fim_jogada          ( wireFim_jogada ),
        .fim_rodada          ( wireFim_rodada ),
        .fim_jogo            (  wireFim_jogo  ),
        .jogada_feita        (   wireJogada   ), 
        .db_tem_jogada       (  db_tem_jogada ),
		.db_timeout          (   db_timeout   ),
        .db_contagem         (   s_contagem   ),
        .db_memoria          ( s_memoria      ),
        .db_jogada           ( wire_db_jogada ),
        .db_rodada           ( wire_db_rodada ),
		.db_contagem_inativo (  )
    );

	 

    /* responsável pela mudança de estados do sistema e envio
       de sinais para o mesmo */
    unidade_controle uc (
        .clock         ( clock         ),
        .reset         ( reset         ),
        .iniciar       ( jogar ),
        .fim_jogada    ( wireFim_jogada ), //abaixo são as saídas
        .fim_rodada    ( wireFim_rodada ),
        .fim_jogo      ( wireFim_jogo ),
        .jogada        ( wireJogada ), 
        .jogada_igual  ( wireIgual ),
		.inativo       ( wireInativo ),
        .zera_jogada   ( wireZera_jogada ),
        .conta_jogada  ( wireConta_jogada ),
        .zera_rodada   ( wireZera_rodada ),
        .conta_rodada  ( wireConta_rodada ),
		.contaInativo  ( wireContaInativo ),
        .zeraR         ( wireZeraR ),
		.zeraInativo   ( wireZeraInativo ),
        .registraR     ( wireRegistraR ),
        .ganhou        ( ganhou ),
        .perdeu        ( perdeu ),
        .pronto        ( pronto ),
        .db_estado     ( s_estado )
    );
	 

/* -------------------------------------------------------- */
/* abaixo estão displays para 4 saídas diferentes de 4 bits */
/* -------------------------------------------------------- */

// Mostra a posição da memória
hexa7seg HEX0 (
    .hexa    ( s_contagem  ),
    .display ( db_contagem )
);

// Mostra o valor da memória
hexa7seg HEX1 (
    .hexa    ( s_memoria  ),
    .display ( db_memoria )
);

// Mostra a jogada feita
hexa7seg HEX2 (
    .hexa    ( wire_db_jogada ),
    .display ( db_jogadafeita )
);

// Mostra a contagem pro periodo inativo
hexa7seg HEX3 (
    .hexa    ( db_rodada  ),
    .display ( db_contagem_inativo )
);

// Mostra a rodada atual
hexa7seg HEX4 (
    .hexa    ( s_estado  ),
    .display ( db_estado )
);

// Mostra o estado atual
hexa7seg HEX5 (
    .hexa    ( s_estado  ),
    .display ( db_estado )
);

endmodule


module fluxo_dados (
   input  clock       ,
   input  zera_jogada ,
   input  conta_jogada,
   input  zera_rodada ,
   input  conta_rodada,
   input  zeraR       ,
   input  registraR   ,
   input  [3:0] botoes,
   input  zeraInativo ,
   input  contaInativo,
   output inativo      ,
   output jogada_igual      ,
   output fim_jogada        ,
   output fim_rodada        ,
   output fim_jogo          ,
   output jogada_feita      ,
   output db_tem_jogada     ,
   output db_timeout        ,
   output [3:0] db_contagem ,
   output [3:0] db_memoria  ,
   output [3:0] db_jogada   ,
   output [3:0] db_rodada   ,
   output [3:0] db_contagem_inativo
   );

    // sinais internos para interligacao dos componentes
   wire ALBo, AGBo;
   wire [3:0] s_endereco; 
   wire [3:0] s_rodada;
   wire [3:0] s_chaves;
   wire [3:0] s_dado;
   wire tem_jogada;
   wire wireJogadaIgual;
    
    /* redirecionamento dos wires para as saídas desse módulo */
    assign db_contagem = s_endereco;
    assign db_jogada = s_chaves;
    assign db_memoria = s_dado;
    assign db_tem_jogada = tem_jogada;
    assign jogada_igual = wireJogadaIgual;
	 assign db_rodada = s_rodada;
	 assign db_timeout = inativo;

   /* or responsável pelo sinal que será mandado para o
      edge_detector e para o sinal de depuração tem_jogada */
   or (tem_jogada, botoes[3], botoes[2], botoes[1], botoes[0]);

   /* detector de jogada, que por escolha do grupo fica 
      sempre resetado e é reponsável pelo sinal para quando
      o jogador faz uma nova jogada */
   edge_detector edge_detector(
      .clock ( clock )     ,
      .reset ( 1'b0 )      ,
      .sinal ( tem_jogada ),
      .pulso ( jogada_feita )
   );

   /* contador não sensível a toda borade de subida de clock. Esse
      contador so acrescenta seu valor quando conta é ativo */
   contador_m contador_jogada (
      .clock   (   clock    ),
      .zera_as (   zera_jogada    ),
      .zera_s  (    1'b0    ),
      .conta   (   conta_jogada   ),
      .Q       ( s_endereco ),
      .fim     (    fim_jogada    ),
      .meio    (            )
   );

   contador_m contador_rodada (
      .clock   (   clock    ),
      .zera_as (   zera_rodada  ),
      .zera_s  (    1'b0    ),
      .conta   ( conta_rodada  ),
      .Q       ( s_rodada ),
      .fim     (   fim_jogo    ),
      .meio    (            )
   );
		
	contador_163 contador_inativo (
      .clock   (  ~clock               ),
      .clr     (  ~zeraInativo         ),
      .ld      (  1'b1                 ),
      .ent     (  contaInativo         ),
      .enp     (  1'b1                 ),
      .D       (  4'b0000              ),
      .Q       (    ),
      .rco     (  inativo              )
   );
    
   /* memoria pre carregada com 16 valores para teste */
   sync_rom_16x4 mem (
      .clock   (   clock    ),
      .address ( s_endereco ),
      .data_out(   s_dado   )
   );

   registrador_4 reg1 (
      .clock (   clock   ),
      .clear (   zeraR   ),
      .enable( registraR ),
      .D     (   botoes  ),
      .Q     ( s_chaves  )
   );

   /* unidade responsável por comparar os valores da saída
      da memória com os da chave enviados pelo usuário */
   comparador_85 comparador_jogada (
      .A   (  s_dado   ),
      .B   ( s_chaves  ),
      .ALBi(   1'b0    ),
      .AGBi(   1'b0    ),
      .AEBi(   1'b1    ),
      .ALBo(   ALBo    ),
      .AGBo(   AGBo    ),
      .AEBo( wireJogadaIgual )
   );
   
      comparador_85 comparador_rodada (
      .A   (   s_rodada  ),
      .B   (  s_endereco ),
      .ALBi(   1'b0    ),
      .AGBi(   1'b0    ),
      .AEBi(   1'b1    ),
      .ALBo(       ),
      .AGBo(       ),
      .AEBo( fim_rodada )
   );
    
 endmodule


module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      fim_jogada,
    input      fim_rodada, //saida do comparador (comparador do contador de jogada com o contador de rodada)
    input      fim_jogo, //RCO do contador de rodada
    input      jogada, 
    input      jogada_igual,
	input      inativo,
    output reg zera_jogada,
    output reg conta_jogada,
    output reg zera_rodada,
    output reg conta_rodada,
	output reg contaInativo,
	output reg zeraInativo,
    output reg zeraR,
    output reg registraR,
    output reg ganhou,
    output reg perdeu,
    output reg pronto,
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
    parameter final_com_acertos    = 4'b1010; // A
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

    /* -------------------------------------------------------------------------------------- */
                                        /* DESATUALIZADO */
    /* -------------------------------------------------------------------------------------- */
    /* O funcionamento dessa unidade de controle começa no estado 0 quando o circuito 
       é acionado, tendo inicio somente quando o sinal iniciar for ativado, passado 
       pelo estado 1 que inicializa os elementos e vai logo para o estado 2 onde o circuito
       espera por uma jogada. Uma vez feita a jogada o circuito vai para o estado 3, onde ele 
       registra a jogada, indo imediatamente para o estado 4 onde ele faz a comparação, e então
       prossege para a próxima jogada se estiver tudo certo. Caso o usuário erre a tentativa, o
       circuito vai para o estado 7. Caso o usuário acerte todas as tentativas, o circuito vai 
       para o estado 6 */
    /* -------------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------------- */
    
    always @* begin
        case (Eatual)
            inicial:              Eprox = iniciar ? inicializa_elementos : inicial;
            inicializa_elementos: Eprox = inicio_da_rodada;
            inicio_da_rodada:     Eprox = espera_jogada;
            espera_jogada:        Eprox = (jogada && ~inativo) ? registra_jogada : inativo ? final_com_timeout : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = ~jogada_igual ? final_com_erro : (jogada_igual && fim_rodada) ? ultima_rodada : proxima_jogada ;
            ultima_rodada:        Eprox = fim_jogo ? final_com_acertos : proxima_rodada;
            proxima_rodada:       Eprox = inicio_da_rodada;
            proxima_jogada:       Eprox = espera_jogada;
            final_com_acertos:    Eprox = reset ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = reset ? inicializa_elementos : final_com_erro;
			final_com_timeout:    Eprox = reset ? inicializa_elementos : final_com_timeout;
            default:              Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        zera_jogada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == inicio_da_rodada) ? 1'b1 : 1'b0;

        conta_rodada   = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;   

        zera_rodada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == final_com_acertos    || 
                          Eatual == final_com_erro       || 
                          Eatual == final_com_timeout) ? 1'b1 : 1'b0;
                         
        conta_jogada   = (Eatual == proxima_jogada) ? 1'b1 : 1'b0; 

        pronto         = (Eatual == final_com_acertos || 
                          Eatual == final_com_erro    || 
                          Eatual == final_com_timeout) ? 1'b1 : 1'b0; 
                         
        zeraR          = (Eatual == inicial || 
                          Eatual == inicializa_elementos) ? 1'b1 : 1'b0;

        registraR      = (Eatual == registra_jogada) ? 1'b1 : 1'b0;

        ganhou        = (Eatual == final_com_acertos) ? 1'b1 : 1'b0; 

        perdeu          = (Eatual == final_com_erro) ? 1'b1 : 1'b0;

		zeraInativo    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == registra_jogada) ? 1'b1 : 1'b0;
                         
		contaInativo   = (Eatual == espera_jogada) ? 1'b1 : 1'b0;

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
            final_com_acertos:    db_estado = 4'b1010; // A
            final_com_erro:       db_estado = 4'b1110; // E
	        final_com_timeout:    db_estado = 4'b1111; // F
            default:              db_estado = 4'b1101; // D
        endcase
    end

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

endmodule /* comparador_85 */

module contador_163 ( clock, clr, ld, ent, enp, D, Q, rco );
    input clock, clr, ld, ent, enp;
    input [3:0] D;
    output reg [15:0] Q;
    output reg rco;

	 initial begin
		Q = 16'd0;
    end
	 
    always @ (posedge clock)
        if (~clr)               Q <= 4'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 16'd5000))   rco = 1;
        else                       rco = 0;
endmodule


module contador_m #(parameter M=16, N=4)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
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


module registrador_4 (
    input        clock,
    input        clear,
    input        enable,
    input  [3:0] D,
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



module sync_rom_16x4 (clock, address, data_out);
    input            clock;
    input      [3:0] address;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001;
            4'b0001: data_out = 4'b0010;
            4'b0010: data_out = 4'b0100;
            4'b0011: data_out = 4'b1000;
            4'b0100: data_out = 4'b0100;
            4'b0101: data_out = 4'b0010;
            4'b0110: data_out = 4'b0001;
            4'b0111: data_out = 4'b0001;
            4'b1000: data_out = 4'b0010;
            4'b1001: data_out = 4'b0010;
            4'b1010: data_out = 4'b0100;
            4'b1011: data_out = 4'b0100;
            4'b1100: data_out = 4'b1000;
            4'b1101: data_out = 4'b1000;
            4'b1110: data_out = 4'b0001;
            4'b1111: data_out = 4'b0100;
        endcase
    end
endmodule

