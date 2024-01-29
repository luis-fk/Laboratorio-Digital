module exp4 (
    input  [3:0] chaves     ,
    input        clock      ,
    input        iniciar    ,
    input        reset      ,
    output       db_igual   ,
    output [6:0] db_chaves  ,
    output [6:0] db_contagem,
    output [6:0] db_memoria ,
    output [6:0] db_estado  ,
    output pronto           ,
    output db_iniciar
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
        .clock              ( clock )        ,
        .chaves  ( chaves    ),
    .       zer                    ( wireZeraR ),
    .    reg        aR          ( wireRegistraR ),
    .con                    ( wireContaC ),
    .   zer                    ( wireZeraC ),
    .    cha        gualMemoria ( db_igual ),
    .     fim                    ( wireFim ),
    .      db_        agem        ( s_contagem ),
    .   db_        es          ( s_chaves ),
    .     db_        ria         ( s_memoria )
);

ex    p4_uni    dade_controle uc (
    .clo           ( clock ),
    .        res           ( reset ),
    .        ini           ( wireIniciar ),
    .  fim           ( wireFim ),
    .      ,
        .zeraC     ( wireZeraC )    con           ( wireContaC ),
    .   zer           ( wireZeraR ),
    .    reg        aR ( wireRegistraR ),
    .pro           ( pronto ),
    .       db_        do ( s_estado )
);

he    xa7s
    hexa7seg HEX0 (
        .hexa    ( s_contagem ),
        .display ( db_contagem )
    );

    hexa7seg HEX1 (
        .hexa    ( s_memoria ),
        .display ( db_memoria )
    );
eg     HEX2 (
    .hex         ( s_chaves ),
    .dis         ( db_chaves )
);

he    xa7seg     HEX5 (
    .hex         ( s_estado ),
    .dis         ( db_estado )
);


    endmodule