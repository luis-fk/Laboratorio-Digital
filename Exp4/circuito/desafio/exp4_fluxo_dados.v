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

module exp4_fluxo_dados (
                        input        clock,
                        input  [3:0] chaves,
                        input        zeraR,
                        input        registraR,
                        input        contaC,
                        input        zeraC,

                        output       chavesIgualMemoria,
                        output       fimC,
                        output [3:0] db_contagem,
                        output [3:0] db_chaves, 
                        output [3:0] db_memoria
);
    
    wire ALBo, AGBo;
    wire [3:0] s_endereco;  // sinal interno para interligacao dos componentes
    wire [3:0] s_chaves;
    wire [3:0] s_dado;

    assign db_contagem = s_endereco;
    assign db_chaves = s_chaves;
    assign db_memoria = s_dado;

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
      .AEBo( chavesIgualMemoria )
    );

 endmodule
