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

module circuito_exp3_ativ2 (clock, zera, carrega, conta, chaves, 
                            menor, maior, igual, fim, db_contagem);
    input        clock;
    input        zera;
    input        carrega;
    input        conta;
    input  [3:0] chaves;
    output       menor;
    output       maior;
    output       igual;
    output       fim;
    output [3:0] db_contagem;

    wire   [3:0] s_contagem;  // sinal interno para interligacao dos componentes

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( COMPLETAR ),
      .ld   ( ~carrega ),
      .ent  ( 1'b1 ),
      .enp  ( conta ),
      .D    ( COMPLETAR ),
      .Q    ( s_contagem ),
      .rco  ( COMPLETAR )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( COMPLETAR ),
      .B   ( COMPLETAR ),
      .ALBi( COMPLETAR ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( COMPLETAR ),
      .AGBo( COMPLETAR ),
      .AEBo( COMPLETAR )
    );

    // saida de depuracao
    assign db_contagem = s_contagem;

 endmodule
