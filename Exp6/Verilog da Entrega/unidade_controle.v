//------------------------------------------------------------------
// Arquivo   : exp4_unidade_controle.v
// Projeto   : Experiência 4 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descrição : Unidade de controle
//
// usar este código como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisões  :
//     Data        Versão  Autor             Descrição
//     14/01/2024  1.0     Edson Midorikawa  versão inicial
//------------------------------------------------------------------
//
module unidade_controle (
    input      clock       ,
    input      reset       ,
    input      iniciar     ,
    input      fim_jogada  ,
    input      fim_rodada  , //saida do comparador (comparador do contador de jogada com o contador de rodada)
    input      fim_jogo    , //RCO do contador de rodada
    input      jogada      , 
    input      jogada_igual,
	input      inativo     ,
    output reg zera_jogada ,
    output reg conta_jogada,
    output reg zera_rodada ,
    output reg conta_rodada,
	output reg contaInativo,
	output reg zeraInativo ,
    output reg zeraR       ,
    output reg registraR   ,
    output reg ganhou      ,
    output reg perdeu      ,
    output reg pronto      ,
    output reg [3:0] db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicial              = 4'b0000; // 0
    parameter inicializa_elementos = 4'b0001; // 1
    parameter inicio_da_rodada     = 4'b0010; // 2
    parameter espera_jogada        = 4'b0011; // 3
    parameter registra_jogada      = 4'b0100; // 4
    parameter compara_jogada       = 4'b0101; // 5
    parameter proxima_jogada       = 4'b0110; // 6
    parameter proxima_rodada       = 4'b0111; // 7
    parameter ultima_rodada        = 4'b1000; // 8
    parameter final_com_acertos    = 4'b1010; // A
    parameter final_com_erro       = 4'b1110; // E
	parameter final_com_timeout    = 4'b1111; // F

    // Variáveis de estado
    reg [3:0] Eatual, Eprox;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    /* -------------------------------------------------------------------------------------- */
                                        //* DESATUALIZADO *//
    /* -------------------------------------------------------------------------------------- */
    /* O funcionamento dessa unidade de controle começa no estado 0 quando o circuito 
       é acionado, tendo inicio somente quando o sinal iniciar for ativado, passado 
       pelo estado 1 que inicializa os elementos e vai logo para o estado 2 onde o circuito
       espera por uma jogada. Uma vez feita a jogada o circuito vai para o estado 3, onde ele 
       registra a jogada, indo imediatamente para o estado 4 onde ele faz a comparação, e então
       prossege para a próxima jogada se estiver tudo certo. Caso o usuário erre a tentativa, o
       circuito vai para o estado 7. Caso o usuário acerte todas as tentativas, o circuito vai 
       para o estado 6 */
    /* -------------------------------------------------------------------------------------- */
    /* -------------------------------------------------------------------------------------- */
    
    always @* begin
        case (Eatual)
            inicial:              Eprox = iniciar ? inicializa_elementos : inicial;
            inicializa_elementos: Eprox = inicio_da_rodada;
            inicio_da_rodada:     Eprox = espera_jogada;
            espera_jogada:        Eprox = (jogada && ~inativo) ? registra_jogada : inativo ? final_com_timeout : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            // compara_jogada:       Eprox = jogada_igual ? ((fim_jogada && fim_jogo) ? ultima_rodada : proxima_jogada) : final_com_erro;
            
            compara_jogada:       Eprox = ~jogada_igual ? final_com_erro : (jogada_igual && fim_rodada) ? ultima_rodada : proxima_jogada ;

            ultima_rodada:        Eprox = fim_jogo ? final_com_acertos : proxima_rodada;
            proxima_rodada:       Eprox = inicio_da_rodada;
            proxima_jogada:       Eprox = espera_jogada;
            final_com_acertos:    Eprox = reset ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = reset ? inicializa_elementos : final_com_erro;
			final_com_timeout:    Eprox = reset ? inicializa_elementos : final_com_timeout;
            default:              Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        zera_jogada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == inicio_da_rodada     ) ? 1'b1 : 1'b0;

        conta_rodada   = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;   

        zera_rodada    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == final_com_acertos    || 
                          Eatual == final_com_erro       || 
                          Eatual == final_com_timeout    ) ? 1'b1 : 1'b0;
                         
        conta_jogada   = (Eatual == proxima_jogada) ? 1'b1 : 1'b0; 

        pronto         = (Eatual == final_com_acertos || 
                          Eatual == final_com_erro    || 
                          Eatual == final_com_timeout ) ? 1'b1 : 1'b0; 
                         
        zeraR          = (Eatual == inicial || 
                          Eatual == inicializa_elementos) ? 1'b1 : 1'b0;

        registraR      = (Eatual == registra_jogada) ? 1'b1 : 1'b0;

        ganhou         = (Eatual == final_com_acertos) ? 1'b1 : 1'b0; 

        perdeu         = (Eatual == final_com_erro || Eatual == final_com_timeout) ? 1'b1 : 1'b0;

		zeraInativo    = (Eatual == inicial              || 
                          Eatual == inicializa_elementos || 
                          Eatual == registra_jogada      ) ? 1'b1 : 1'b0;
                         
		contaInativo   = (Eatual == espera_jogada || Eatual == final_com_timeout) ? 1'b1 : 1'b0;

        // Saída de depuração (estado)
        case (Eatual)
            inicial:              db_estado = 4'b0000; // 0
            inicializa_elementos: db_estado = 4'b0001; // 1
            inicio_da_rodada:     db_estado = 4'b0010; // 2
            espera_jogada:        db_estado = 4'b0011; // 3
            registra_jogada:      db_estado = 4'b0100; // 4
            compara_jogada:       db_estado = 4'b0101; // 5
            proxima_jogada:       db_estado = 4'b0110; // 6
            proxima_rodada:       db_estado = 4'b0111; // 7
            ultima_rodada:        db_estado = 4'b1000; // 8
            final_com_acertos:    db_estado = 4'b1010; // A
            final_com_erro:       db_estado = 4'b1110; // E
	        final_com_timeout:    db_estado = 4'b1111; // F
            default:              db_estado = 4'b1101; // D
        endcase
    end

endmodule