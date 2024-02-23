/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp6_ativ1.v
 *  Projeto   : Experiencia 6 - Projeto Base do Jogo do Desafio da Memória
 * ------------------------------------------------------------------
 *  Descricao : Circuito da atividade 1 da experiência 6. 
 * 
 */

module fluxo_dados (
   input  clock             ,
   input  zera_jogada       ,
   input  conta_jogada      ,
   input  zera_rodada       ,
   input  conta_rodada      ,
   input  zeraR             ,
   input  registraR         ,
   input  [3:0] botoes      ,
   input  zeraInativo       ,
   input  contaInativo      ,
	input  ramWE         ,
   output inativo           ,
   output jogada_igual      ,
   output fim_jogada        ,
   output fim_rodada        ,
   output fim_jogo          ,
   output jogada_feita      ,
   output db_tem_jogada     ,
   output db_timeout        ,
   output [3:0] db_contagem ,
   output [3:0] db_memoria  ,
   output [3:0] db_jogada   ,
   output [3:0] db_rodada   ,
   output [15:0] db_contagem_inativo
   );

    // sinais internos para interligacao dos componentes
   wire ALBo, AGBo      ;
   wire [3:0] s_endereco; 
   wire [3:0] s_rodada  ;
   wire [3:0] s_chaves  ;
   wire [3:0] s_dado    ;
   wire tem_jogada      ;
   wire wireJogadaIgual ;
    
    /* redirecionamento dos wires para as saídas desse módulo */
    assign db_contagem = s_endereco      ;
    assign db_jogada = s_chaves          ;
    assign db_memoria = s_dado           ;
    assign db_tem_jogada = tem_jogada    ;
    assign jogada_igual = wireJogadaIgual;
	 assign db_rodada = s_rodada          ;
	 assign db_timeout = inativo          ;
	 
   /* or responsável pelo sinal que será mandado para o
      edge_detector e para o sinal de depuração tem_jogada */
   or (tem_jogada, botoes[3], botoes[2], botoes[1], botoes[0]);

   /* detector de jogada, que por escolha do grupo fica 
      sempre resetado e é reponsável pelo sinal para quando
      o jogador faz uma nova jogada */
   edge_detector edge_detector(
      .clock (     clock    ),
      .reset (     1'b0     ),
      .sinal (  tem_jogada  ),
      .pulso ( jogada_feita )
   );

   /* contador não sensível a toda borade de subida de clock. Esse
      contador so acrescenta seu valor quando conta é ativo */
   contador_m contador_jogada (
      .clock   (      clock    ),
      .zera_as (   zera_jogada ),
      .zera_s  (      1'b0     ),
      .conta   (  conta_jogada ),
      .Q       ( s_endereco    ),
      .fim     (    fim_jogada ),
      .meio    (               )
   );
   /* contador responsável por contar as rodadas */
   contador_m contador_rodada (
      .clock   (     clock    ),
      .zera_as (  zera_rodada ),
      .zera_s  (    1'b0      ),
      .conta   ( conta_rodada ),
      .Q       (   s_rodada   ),
      .fim     (   fim_jogo   ),
      .meio    (              )
   );
	/*contador responsável por mensurar o tempo de inatividade do jogador */
	contador_163 contador_inativo (
      .clock   (  ~clock               ),
      .clr     (  ~zeraInativo         ),
      .ld      (  1'b1                 ),
      .ent     (  contaInativo         ),
      .enp     (  1'b1                 ),
      .D       (  4'b0000              ),
      .Q       (  db_contagem_inativo  ),
      .rco     (  inativo              )
   );
    
   /* memoria pre carregada com 16 valores para teste */
   sync_ram_16x4_file mem (
      .clk     (   clock    ),
		.we      ( ramWE  ),
		.data    ( s_chaves   ),
      .addr    ( s_endereco ),
      .q       (   s_dado   )
   );
	
	
   /* registrador utilizado para salvar a jogada feita pelo usuario */
   registrador_4 reg1 (
      .clock (   clock   ),
      .clear (   zeraR   ),
      .enable( registraR ),
      .D     (   botoes  ),
      .Q     ( s_chaves  )
   );

   /* responsável por comparar os valores da saída
      da memória com os da chave enviados pelo usuário */
   comparador_85 comparador_jogada (
      .A   (  s_dado   ),
      .B   ( s_chaves  ),
      .ALBi(   1'b0    ),
      .AGBi(   1'b0    ),
      .AEBi(   1'b1    ),
      .ALBo(   ALBo    ),
      .AGBo(   AGBo    ),
      .AEBo( wireJogadaIgual )
   );
   
   /* responsável por comparar a rodada atual com a jogada atual*/
   comparador_85 comparador_rodada (
   .A   (  s_rodada   ),
   .B   (  s_endereco ),
   .ALBi(  1'b0       ),
   .AGBi(  1'b0       ),
   .AEBi(  1'b1       ),
   .ALBo(             ),
   .AGBo(             ),   
   .AEBo( fim_rodada  )
   );
    
 endmodule