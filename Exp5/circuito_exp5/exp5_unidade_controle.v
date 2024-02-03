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
    input      clock,
    input      reset,
    input      iniciar,
    input      fim,
    input      igual,
    input      jogada,

    output reg zeraC,
    output reg contaC,
    output reg zeraR,
    output reg registraR,
    output reg pronto,
    output reg [3:0] db_estado,
    output reg acertou,
    output reg errou
);

    // Define estados
    // parameter inicial    = 4'b0000;  // 0
    // parameter preparacao = 4'b0001;  // 1
    // parameter registra   = 4'b0100;  // 4
    // parameter comparacao = 4'b0101;  // 5
    // parameter proximo    = 4'b0110;  // 6
    // parameter fim        = 4'b1100;  // C
	// parameter errouState = 4'b1101;  // D

    wire fez_jogada;

    
    parameter inicial              = 4'b0000 // 0
    parameter inicializa_elementos = 4'b0001 // 1
    parameter espera_jogada        = 4'b0010 // 2
    parameter registra_jogada      = 4'b0011 // 3
    parameter compara_jogada       = 4'b0100 // 4
    parameter passa_prox_jogada    = 4'b0101 // 5
    parameter final_com_acertos    = 4'b0110 // 6
    parameter final_com_erro       = 4'b0111 // 7
    

    // Variáveis de estado
    reg [3:0] Eatual, Eprox;

    // Memória de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Lógica de próximo estado
    always @* begin
        case (Eatual)
            inicial:              Eprox = iniciar ? inicializa_elementos : inicial;
            inicializa_elementos: Eprox = espera_jogada;
            espera_jogada:        Eprox = fez_jogada ? registra_jogada : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = errou ? final_com_erro : (fim ? final_com_acertos : passa_prox_jogada);
            passa_prox_jogada:    Eprox = espera_jogada;
            final_com_acertos:    Eprox = iniciar ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = iniciar ? inicializa_elementos : final_com_erro;
            

            preparacao:  Eprox = registra;
            registra:    Eprox = comparacao;
            comparacao:  Eprox = fim && igual ? fim : ~igual ? errouState : proximo; //
            proximo:     Eprox = registra;
            fim:         Eprox = inicial;
			errouState:  Eprox = inicial;
            default:     Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
        zeraC     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC    = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto    = (Eatual == fim || Eatual == errouState) ? 1'b1 : 1'b0; 
        acertou   = (Eatual == fim) ? 1'b1 : 1'b0; 
        errou     = (Eatual == errouState) ? 1'b1 : 1'b0;               
                                                      

        // Saída de depuração (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
            fim:         db_estado = 4'b1100;  // C
            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule


