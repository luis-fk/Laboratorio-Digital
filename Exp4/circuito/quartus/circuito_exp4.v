module circuito_exp4 (
    input        clock,
    input        reset,
    input        iniciar,
    input  [3:0] chaves,
    output pronto,
    output       db_igual,
    output db_iniciar,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_chaves,
    output [6:0] db_estado
);

wire [3:0] s_chaves;
wire [3:0] s_contagem;
wire [3:0] s_memoria;
wire [3:0] s_estado;
wire wireFim;
wire wireIniciar;
wire wireContaC;
wire wireZeraC;
wire wireZeraR;
wire wireRegistraR;

assign db_iniciar = wireIniciar;
assign wireIniciar = iniciar;

exp4_fluxo_dados fluxo (
    .clock ( clock ),
    .chaves ( chaves ),
    .zeraR ( wireZeraR ),
    .registraR ( wireRegistraR ),
    .contaC ( wireContaC ),
    .zeraC ( wireZeraC ),
    .chavesIgualMemoria ( db_igual ),
    .fimC ( wireFim ),
    .db_contagem ( s_contagem ),
    .db_chaves ( s_chaves ),
    .db_memoria ( s_memoria )
);

exp4_unidade_controle uc (
    .clock ( clock ),
    .reset ( reset ),
    .iniciar ( wireIniciar ),
    .fimC ( wireFim ),
    .zeraC ( wireZeraC ),
    .contaC ( wireContaC ),
    .zeraR ( wireZeraR ),
    .registraR ( wireRegistraR ),
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