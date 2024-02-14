//------------------------------------------------------------------
// Arquivo   : exp4_unidade_controle.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module unidade_controle (
                    input      clock    ,
                    input      reset    ,
                    input      iniciar  ,
                    input      fim      ,
                    input      jogada   ,
                    input      igual    ,
                    output reg zeraC    ,
                    output reg contaC   ,
                    output reg zeraR    ,
                    output reg registraR,
                    output reg acertou  ,
                    output reg errou    ,
                    output reg pronto   ,
                    output reg [3:0] db_estado
);
    
    /* declaração dos estados dessa UC */
    parameter inicial              = 4'b0000; // 0
    parameter inicializa_elementos = 4'b0001; // 1
    parameter espera_jogada        = 4'b0010; // 2
    parameter registra_jogada      = 4'b0011; // 3
    parameter compara_jogada       = 4'b0100; // 4
    parameter passa_prox_jogada    = 4'b0101; // 5
    parameter final_com_acertos    = 4'b0110; // 6
    parameter final_com_erro       = 4'b0111; // 7

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
            inicializa_elementos: Eprox = espera_jogada;
            espera_jogada:        Eprox = jogada ? registra_jogada : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = ~igual ? final_com_erro : (fim ? final_com_acertos : passa_prox_jogada);
            passa_prox_jogada:    Eprox = espera_jogada;
            final_com_acertos:    Eprox = iniciar ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = iniciar ? inicializa_elementos : final_com_erro;
            default:              Eprox = inicial;            
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == inicializa_elementos) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == inicializa_elementos) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra_jogada) ? 1'b1 : 1'b0;
        contaC    = (Eatual == passa_prox_jogada) ? 1'b1 : 1'b0;
        pronto    = (Eatual == final_com_acertos || Eatual == final_com_erro) ? 1'b1 : 1'b0; 
        acertou   = (Eatual == final_com_acertos) ? 1'b1 : 1'b0; 
        errou     = (Eatual == final_com_erro) ? 1'b1 : 1'b0;                                              

        // Saída de depuração (estado)
        case (Eatual)
            inicial:              db_estado = 4'b0000; // 0
            inicializa_elementos: db_estado = 4'b0001; // 1
            espera_jogada:        db_estado = 4'b0010; // 2
            registra_jogada:      db_estado = 4'b0011; // 3
            compara_jogada:       db_estado = 4'b0100; // 4
            passa_prox_jogada:    db_estado = 4'b0101; // 5
            final_com_acertos:    db_estado = 4'b0110; // 6
            final_com_erro:       db_estado = 4'b0111; // 7
            default:              db_estado = 4'b1000; // 8
        endcase
    end

endmodule