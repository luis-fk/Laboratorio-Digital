module circuito_jogo_base (
    input  [3:0] botoes ,
    input        jogar  ,
    input        reset  ,
    input        clock  ,
    output [3:0] leds   , 
    output       ganhou ,
    output       perdeu ,
    output       pronto ,

    /* Sinais de depuração */
    output       db_clock           , /* acho que pode tirar */
    output       db_iniciar         , /* esse também */
    output       db_igual           ,
    output       db_tem_jogada      , 
	output       db_timeout         ,
	output [6:0] db_contagem_inativo,
    output [6:0] db_contagem        ,
    output [6:0] db_memoria         ,
    output [6:0] db_estado          ,
    output [6:0] db_jogadafeita     ,
    output [6:0] db_rodada
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
        .clock               (     clock          ),
        .zera_jogada         ( wireZera_jogada    ),
        .conta_jogada        ( wireConta_jogada   ),
        .zera_rodada         ( wireZera_rodada    ),
        .conta_rodada        ( wireConta_rodada   ),
        .zeraR               (    wireZeraR       ),
        .registraR           (  wireRegistraR     ),
        .botoes              (     botoes         ),
		.zeraInativo         ( wireZeraInativo    ),
		.contaInativo        ( wireContaInativo   ),
		.inativo             (  wireInativo       ),
        .jogada_igual        (   wireIgual        ),
        .fim_jogada          ( wireFim_jogada     ),
        .fim_rodada          ( wireFim_rodada     ),
        .fim_jogo            (  wireFim_jogo      ),
        .jogada_feita        (   wireJogada       ), 
        .db_tem_jogada       (  db_tem_jogada     ),
		.db_timeout          (   db_timeout       ),
        .db_contagem         (   s_contagem       ),
        .db_memoria          ( s_memoria          ),
        .db_jogada           ( wire_db_jogada     ),
        .db_rodada           ( wire_db_rodada     ),
		.db_contagem_inativo ( s_contagem_inativo )
    );

    /* responsável pela mudança de estados do sistema e envio
       de sinais para o mesmo */
    unidade_controle uc (
        .clock         ( clock            ),
        .reset         ( reset            ),
        .iniciar       ( jogar            ),
        .fim_jogada    ( wireFim_jogada   ), //abaixo são as saídas
        .fim_rodada    ( wireFim_rodada   ),
        .fim_jogo      ( wireFim_jogo     ),
        .jogada        ( wireJogada       ), 
        .jogada_igual  ( wireIgual        ),
		.inativo       ( wireInativo      ),
        .zera_jogada   ( wireZera_jogada  ),
        .conta_jogada  ( wireConta_jogada ),
        .zera_rodada   ( wireZera_rodada  ),
        .conta_rodada  ( wireConta_rodada ),
		.contaInativo  ( wireContaInativo ),
        .zeraR         ( wireZeraR        ),
		.zeraInativo   ( wireZeraInativo  ),
        .registraR     ( wireRegistraR    ),
        .ganhou        ( ganhou           ),
        .perdeu        ( perdeu           ),
        .pronto        ( pronto           ),
        .db_estado     ( s_estado         )
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
    .hexa    ( s_contagem_inativo  ),
    .display ( db_contagem_inativo )
);

// // Mostra a rodada atual
// hexa7seg HEX4 (
//     .hexa    ( s_estado  ),
//     .display ( db_estado )
// );

// Mostra o estado atual
hexa7seg HEX5 (
    .hexa    ( s_estado  ),
    .display ( db_estado )
);

endmodule