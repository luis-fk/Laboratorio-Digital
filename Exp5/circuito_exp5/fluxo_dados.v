/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp3_ativ2-PARCIAL.v
 *  Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 * ------------------------------------------------------------------
 *  Descricao : Circuito PARCIAL do fluxo de dados da Atividade 2
 * 
 *     1) COMPLETAR DESCRICAO
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------
 */

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

    wire ALBo, AGBo;
    wire [3:0] s_endereco;  // sinal interno para interligacao dos componentes
    wire [3:0] s_chaves;
    wire [3:0] s_dado;
    wire tem_jogada;
    
    assign db_contagem = s_endereco;
    assign db_jogada = s_chaves;
    assign db_memoria = s_dado;
    assign db_tem_jogada = tem_jogada;
    
    or (tem_jogada, chaves[3], chaves[2], chaves[1], chaves[0]);


    edge_detector edge_detector(
      .clock ( clock ),
      .reset (  ),
      .sinal ( tem_jogada ),
      .pulso ( jogada_feita )
    );


    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zeraC ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaC ),
      .D    ( 4'b0000 ),
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

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

    // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ALBo ),
      .AGBo( AGBo ),
      .AEBo( igual )
    );

 endmodule
