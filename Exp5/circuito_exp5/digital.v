module circuito_exp5 (
    input        clock,
    input        reset,
    input        iniciar,
    input  [3:0] chaves,
    output       acertou,
    output       errou,
    output       pronto,
    output [3:0] leds, // chaves
    output       db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,
    output [6:0] db_jogadafeita,
    output       db_clock,
    output       db_iniciar,
    output       db_tem_jogada
);

    /* diversos wires usados para conexão entre os módulos abaixo */
    wire [3:0] s_chaves;
    wire [3:0] s_contagem;
    wire [3:0] s_memoria;
    wire [3:0] s_estado;
    wire wireFimC; 
    wire wireContaC;
    wire wireZeraC;
    wire wireZeraR;
    wire wireRegistraR;
    wire wireIgual;
    wire wureJogada;
    wire [3:0] wire_db_jogada;

    /* assigns usados para contctar as saídas dos módulos abaixo
       com a saída desse circuito */
    assign db_iniciar = iniciar;
    assign db_igual = wireIgual;
    assign leds = chaves;
    assign s_chaves = chaves;
    assign db_clock = clock;

    /* fluxo de dados responsável pelo funcionamento do circuito 
       quando se trata de mudança de valores internos do sistema */
    fluxo_dados fluxo (
        .clock          ( clock ),
        .zeraC          ( wireZeraC ),
        .contaC         ( wireContaC ),
        .zeraR          ( wireZeraR ),
        .registraR      ( wireRegistraR ),
        .chaves         ( chaves ),
        .igual          ( wireIgual ),
        .fimC           ( wireFimC ),
        .jogada_feita   ( wireJogada ), 
        .db_tem_jogada  ( db_tem_jogada ),
        .db_contagem    ( s_contagem ),
        .db_memoria     ( s_memoria ),
        .db_jogada      ( wire_db_jogada )
    );

    /* responsável pela mudança de estados do sistema e envio
       de sinais para o mesmo */
    unidade_controle uc (
        .clock     ( clock ),
        .reset     ( reset ),
        .iniciar   ( iniciar ),
        .fim       ( wireFimC ), //abaixo são as saídas
        .jogada    ( wireJogada), 
        .igual     ( wireIgual ),
        .zeraC     ( wireZeraC ),
        .contaC    ( wireContaC ),
        .zeraR     ( wireZeraR ),
        .registraR ( wireRegistraR ),
        .acertou   ( acertou ),
        .errou     ( errou ),
        .pronto    ( pronto ),
        .db_estado ( s_estado )
    );

/* -------------------------------------------------------- */
/* abaixo estão displays para 4 saídas diferentes de 4 bits */
/* -------------------------------------------------------- */

hexa7seg HEX0 (
    .hexa ( s_contagem ),
    .display ( db_contagem )
);

hexa7seg HEX1 (
    .hexa ( s_memoria ),
    .display ( db_memoria )
);

hexa7seg HEX2 (
    .hexa ( wire_db_jogada ),
    .display ( db_jogadafeita )
);

hexa7seg HEX5 (
    .hexa ( s_estado ),
    .display ( db_estado )
);

endmodule



module fluxo_dados (
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
    input [3:0] chaves,
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada
);
    // sinais internos para interligacao dos componentes
    wire ALBo, AGBo;
    wire [3:0] s_endereco;  
    wire [3:0] s_chaves;
    wire [3:0] s_dado;
    wire tem_jogada;
    wire WireIgual;
    
    /* redirecionamento dos wires para as saídas desse módulo */
    assign db_contagem = s_endereco;
    assign db_jogada = s_chaves;
    assign db_memoria = s_dado;
    assign db_tem_jogada = tem_jogada;
    assign igual = WireIgual;

    /* or responsável pelo sinal que será mandado para o
       edge_detector e para o sinal de depuração tem_jogada */
    or (tem_jogada, chaves[3], chaves[2], chaves[1], chaves[0]);

    /* detector de jogada, que por escolha do grupo fica 
       sempre resetado e é reponsável pelo sinal para quando
       o jogador faz uma nova jogada */
    edge_detector edge_detector(
      .clock ( clock ),
      .reset ( 1'b0 ),
      .sinal ( tem_jogada ),
      .pulso ( jogada_feita )
    );

    /* contador não sensível a toda borade de subida de clock. Esse
       contador so acrescenta seu valor quando conta é ativo */
    contador_m contador_m (
      .clock   ( clock ),
      .zera_as ( zeraC ),
      .zera_s  ( 1'b0 ),
      .conta   ( contaC ),
      .Q       ( s_endereco ),
      .fim     ( fimC ),
      .meio    (   )
      );
    
     /* memoria pre carregada com 16 valores para teste */
     sync_rom_16x4 mem (
      .clock   ( clock ),
      .address ( s_endereco ),
      .data_out( s_dado )
     );

     registrador_4 reg1 (
      .clock ( clock ),
      .clear ( zeraR ),
      .enable( registraR ),
      .D     ( chaves ),
      .Q     ( s_chaves )
     );

    /* unidade responsável por comparar os valores da saída
       da memória com os da chave enviados pelo usuário */
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ALBo ),
      .AGBo( AGBo ),
      .AEBo( WireIgual )
    );

 endmodule

module unidade_controle (
                    input clock,
                    input reset,
                    input iniciar,
                    input fim,
                    input jogada,
                    input igual,
                    output reg zeraC,
                    output reg contaC,
                    output reg zeraR,
                    output reg registraR,
                    output reg acertou,
                    output reg errou,
                    output reg pronto,
                    output reg [3:0] db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicial              = 4'b0000; // 0
    parameter inicializa_elementos = 4'b0001; // 1
    parameter espera_jogada        = 4'b0010; // 2
    parameter registra_jogada      = 4'b0011; // 3
    parameter compara_jogada       = 4'b0100; // 4
    parameter passa_prox_jogada    = 4'b0101; // 5
    parameter final_com_acertos    = 4'b0110; // 6
    parameter final_com_erro       = 4'b0111; // 7

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
            inicializa_elementos: Eprox = espera_jogada;
            espera_jogada:        Eprox = jogada ? registra_jogada : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = ~igual ? final_com_erro : (fim ? final_com_acertos : passa_prox_jogada);
            passa_prox_jogada:    Eprox = espera_jogada;
            final_com_acertos:    Eprox = iniciar ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = iniciar ? inicializa_elementos : final_com_erro;
            default:              Eprox = inicial;            
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == inicializa_elementos) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == inicializa_elementos) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra_jogada) ? 1'b1 : 1'b0;
        contaC    = (Eatual == passa_prox_jogada) ? 1'b1 : 1'b0;
        pronto    = (Eatual == final_com_acertos || Eatual == final_com_erro) ? 1'b1 : 1'b0; 
        acertou   = (Eatual == final_com_acertos) ? 1'b1 : 1'b0; 
        errou     = (Eatual == final_com_erro) ? 1'b1 : 1'b0;                                              

        // Saída de depuração (estado)
        case (Eatual)
            inicial:              db_estado = 4'b0000; // 0
            inicializa_elementos: db_estado = 4'b0001; // 1
            espera_jogada:        db_estado = 4'b0010; // 2
            registra_jogada:      db_estado = 4'b0011; // 3
            compara_jogada:       db_estado = 4'b0100; // 4
            passa_prox_jogada:    db_estado = 4'b0101; // 5
            final_com_acertos:    db_estado = 4'b0110; // 6
            final_com_erro:       db_estado = 4'b0111; // 7
            default:              db_estado = 4'b1000; // 8
        endcase
    end

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