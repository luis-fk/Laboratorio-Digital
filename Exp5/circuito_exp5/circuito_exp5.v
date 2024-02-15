module circuito_exp5 (
    input        clock         ,
    input        reset         ,
    input        iniciar       ,
    input  [3:0] chaves        ,
    output       acertou       ,
    output       errou         ,
    output       pronto        ,
    output       db_igual      ,
    output [3:0] leds          , 
    output [6:0] db_contagem   ,
    output [6:0] db_memoria    ,
    output [6:0] db_estado     ,
    output [6:0] db_jogadafeita,
    output       db_clock      ,
    output       db_iniciar    ,
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
        .clock          (     clock      ),
        .zeraC          (   wireZeraC    ),
        .contaC         (   wireContaC   ),
        .zeraR          (    wireZeraR   ),
        .registraR      (  wireRegistraR ),
        .chaves         (     chaves     ),
        .igual          (   wireIgual    ),
        .fimC           (    wireFimC    ),
        .jogada_feita   (   wireJogada   ), 
        .db_tem_jogada  (  db_tem_jogada ),
        .db_contagem    (   s_contagem   ),
        .db_memoria     ( s_memoria      ),
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