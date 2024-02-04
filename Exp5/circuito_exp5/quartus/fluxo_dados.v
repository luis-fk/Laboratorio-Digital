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
    input clock             ,
    input zeraC             ,
    input contaC            ,
    input zeraR             ,
    input registraR         ,
    input [3:0] chaves      , 
    output igual            ,
    output fimC             ,
    output jogada_feita     ,
    output db_tem_jogada    ,
    output [3:0] db_contagem,
    output [3:0] db_memoria ,
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
      .clock ( clock )     ,
      .reset ( 1'b0 )      ,
      .sinal ( tem_jogada ),
      .pulso ( jogada_feita )
    );

    /* contador não sensível a toda borade de subida de clock. Esse
       contador so acrescenta seu valor quando conta é ativo */
    contador_m contador_m (
      .clock   (   clock    ),
      .zera_as (   zeraC    ),
      .zera_s  (    1'b0    ),
      .conta   (   contaC   ),
      .Q       ( s_endereco ),
      .fim     (    fimC    ),
      .meio    (            )
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
      .D     (   chaves  ),
      .Q     ( s_chaves  )
     );

    /* unidade responsável por comparar os valores da saída
       da memória com os da chave enviados pelo usuário */
    comparador_85 comparador (
      .A   (  s_dado  ),
      .B   ( s_chaves ),
      .ALBi(   1'b0   ),
      .AGBi(   1'b0   ),
      .AEBi(   1'b1   ),
      .ALBo(   ALBo   ),
      .AGBo(   AGBo   ),
      .AEBo( WireIgual)
    );
    
 endmodule

