module circuito_exp5 (
    input        clock,
    input        reset,
    input        iniciar,
    input  [3:0] chaves,
    output       acertou,
    output       errou,

    output       pronto,
    output [3:0] leds,
    output       db_igual,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_estado,

    output [6:0] db_jogadafeita,
    output db_clock,
    output db_iniciar,
    output db_tem_jogada,








    output       db_zeraC,
    output       db_contaC,
    output       db_fimC,
    output       db_zeraR,
    output       db_registraR,


    output [6:0] db_chaves,

);


wire [3:0] s_chaves;
wire [3:0] s_contagem;
wire [3:0] s_memoria;
wire [3:0] s_estado;
wire wireFimC; 
wire wireIniciar;
wire wireContaC;
wire wireZeraC;
wire wireZeraR;
wire wireRegistraR;
wire wireIgual;
wire [3:0] wire_db_jogada;

assign db_iniciar = wireIniciar;
assign wireIniciar = iniciar;
assign db_zeraC = wireZeraC;
assign db_contaC = wireContaC;
assign db_fimC = wireFimC;
assign db_zeraR = wireZeraR;
assign db_registraR = wireRegistraR;
assign db_igual = wireIgual;

fluxo_dados fluxo (
    .clock          ( clock ),
    .zeraC          ( wireZeraC ),
    .contaC         ( wireContaC ),
    .zeraR          ( wireZeraR ),
    .registraR      ( wireRegistraR ),
    .chaves         ( chaves ),
    .igual          ( wireIgual ),
    .fimC           ( wireFimC ),
    .jogada_feita   ( jogada_feita ), 
    .db_tem_jogada  ( db_tem_jogada ),
    .db_contagem    ( s_contagem ),
    .db_memoria     ( s_memoria ),
    .db_jogada      ( wire_db_jogada )
);

unidade_controle uc (
    .clock ( clock ),
    .reset ( reset ),
    .iniciar ( wireIniciar ),
    .fim ( wireFimC ),
    .jogada ( wireJogada),
    .igual ( wireIgual ),
    .zeraC ( wireZeraC ),
    .contaC ( wireContaC ),
    .zeraR ( wireZeraR ),
    .registraR ( wireRegistraR ),
    .acertou ( acertou ),
    .errou ( errou ),
    .pronto ( pronto ),
    .db_estado ( s_estado )
);

hexa7seg HEX2 (
    .hexa ( s_chaves ),
    .display ( db_chaves )
);

hexa7seg HEX0 (
    .hexa ( s_contagem ),
    .display ( db_contagem )
);

hexa7seg HEX1 (
    .hexa ( s_memoria ),
    .display ( db_memoria )
);

hexa7seg HEX5 (
    .hexa ( s_estado ),
    .display ( db_estado )
);


endmodule