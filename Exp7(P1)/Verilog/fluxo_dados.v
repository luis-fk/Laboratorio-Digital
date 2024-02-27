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
   input  zera_mostra_led   ,
   input  conta_mostra_led  ,
	input  ramWE             ,
   output [3:0] leds        , // adicionado
   output inativo           ,
   output jogada_igual      ,
   output fim_jogada        ,
   output fim_rodada        ,
   output fim_jogo          ,
   output fim_mostra_led    ,
   output jogada_feita      ,
   output db_tem_jogada     ,
   output db_timeout        ,
   output [3:0] db_contagem ,
   output [3:0] db_memoria  ,
   output [3:0] db_jogada   ,
   output [3:0] db_rodada   
   );

    // sinais internos para interligacao dos componentes
   wire ALBo, AGBo      ;
   wire [3:0] s_endereco; 
   wire [3:0] s_rodada  ;
   wire [3:0] s_chaves  ;
   wire [3:0] s_dado    ;
   wire tem_jogada      ;
   wire wireJogadaIgual ;
   wire wireConta_mostra_led;
    
   /* redirecionamento dos wires para as saídas desse módulo */
   assign db_contagem   = s_endereco     ;
   assign db_jogada     = s_chaves       ;
   assign db_memoria    = s_dado         ;
   assign db_tem_jogada = tem_jogada     ;
   assign jogada_igual  = wireJogadaIgual;
	assign db_rodada     = s_rodada       ;
	assign db_timeout    = inativo        ;
   assign wireConta_mostra_led = conta_mostra_led;
	 
   /* or responsável pelo sinal que será mandado para o
      edge_detector e para o sinal de depuração tem_jogada */
   or (tem_jogada, botoes[3], botoes[2], botoes[1], botoes[0]);

   /* detector de jogada, que por escolha do grupo fica 
      sempre resetado e é reponsável pelo sinal para quando
      o jogador faz uma nova jogada */
   edge_detector edge_detector(
      .clock (  clock        ),
      .reset (  1'b0         ),
      .sinal (  tem_jogada   ),
      .pulso (  jogada_feita )
   );

   /* mux utilizado para mostrar a primeira jogada da memoria e a partir desse ponto
      mostrar os botões selecionados */
   mux2x1_n mux_leds(
      .D0 ( botoes ), 
      .D1 ( s_dado ), 
      .SEL( wireConta_mostra_led ), // é um no estado mostra_led
      .OUT( leds )
   );

   /* contador não sensível a toda borda de de subida de clock. Esse
      contador so acrescenta seu valor quando conta é ativo */
   contador_m contador_jogada (
      .clock   (  clock         ),
      .zera_as (  zera_jogada   ),
      .zera_s  (  1'b0          ),
      .conta   (  conta_jogada  ),
      .Q       (  s_endereco    ),
      .fim     (  fim_jogada    ),
      .meio    (                )
   );
   
   /* contador responsável por contar as rodadas */
   contador_m contador_rodada (
      .clock   (  clock         ),
      .zera_as (  zera_rodada   ),
      .zera_s  (  1'b0          ),
      .conta   (  conta_rodada  ),
      .Q       (  s_rodada      ),
      .fim     (  fim_jogo      ),
      .meio    (                )
   );

	/*contador responsável por mensurar o tempo de inatividade do jogador */
	contador_163_5k contador_inativo (
      .clock (  ~clock               ),
      .clr   (  ~zeraInativo         ),
      .ld    (  1'b1                 ),
      .ent   (  contaInativo         ),
      .enp   (  1'b1                 ),
      .D     (  4'b0000              ),
      .Q     (                       ),
      .rco   (  inativo              )
   );

   /*contador responsável por determinar o tempo de mostrar led */
	contador_163_2k contador_mostra_led (
      .clock (  ~clock            ),
      .clr   (  ~zera_mostra_led  ),
      .ld    (  1'b1              ),
      .ent   (wireConta_mostra_led),
      .enp   (  1'b1              ),
      .D     (  4'b0000           ),
      .Q     (                    ),
      .rco   (  fim_mostra_led    )
   );
    
   /* memoria pre carregada com 16 valores para teste */
   sync_ram_16x4_file mem (
      .clk     (  clock       ),
		.we      (  ramWE       ),
		.data    (  s_chaves    ),
      .addr    (  s_endereco  ),
      .q       (  s_dado      )
   );
	
	
   /* registrador utilizado para salvar a jogada feita pelo usuario */
   registrador_4 reg1 (
      .clock  (  clock      ),
      .clear  (  zeraR      ),
      .enable (  registraR  ),
      .D      (  botoes     ),
      .Q      (  s_chaves   )
   );

   /* responsável por comparar os valores da saída
      da memória com os da chave enviados pelo usuário */
   comparador_85 comparador_jogada (
      .A    (  s_dado           ),
      .B    (  s_chaves         ),
      .ALBi (  1'b0             ),
      .AGBi (  1'b0             ),
      .AEBi (  1'b1             ),
      .ALBo (  ALBo             ),
      .AGBo (  AGBo             ),
      .AEBo (  wireJogadaIgual  )
   );
   
   /* responsável por comparar a rodada atual com a jogada atual*/
   comparador_85 comparador_rodada (
   .A    (  s_rodada    ),
   .B    (  s_endereco  ),
   .ALBi (  1'b0        ),
   .AGBi (  1'b0        ),
   .AEBi (  1'b1        ),
   .ALBo (              ),
   .AGBo (              ),   
   .AEBo (  fim_rodada  )
   );
    
 endmodule