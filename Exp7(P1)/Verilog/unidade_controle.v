module unidade_controle (
    input      clock           ,
    input      reset           ,
    input      iniciar         ,
    input      fim_jogada      ,
    input      fim_rodada      , 
    input      fim_jogo        , 
    input      fim_mostra_led  ,
    input      jogada          , 
    input      jogada_igual    ,
	input      inativo         ,
    output reg conta_mostra_led, 
    output reg zera_mostra_led , 
    output reg zera_jogada     ,
    output reg conta_jogada    ,
    output reg zera_rodada     ,
    output reg conta_rodada    ,
	output reg contaInativo    ,
	output reg zeraInativo     ,
    output reg zeraR           ,
    output reg registraR       ,
    output reg ganhou          ,
    output reg perdeu          ,
    output reg pronto          ,
    output reg ramWE           ,
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
	parameter espera_nova          = 4'b1001; // 9
    parameter final_com_acertos    = 4'b1010; // A
	parameter registra_nova        = 4'b1011; // B
    parameter mostra_led           = 4'b1100; // C
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

    always @* begin
        case (Eatual)
            inicial:              Eprox = iniciar ? inicializa_elementos : inicial;
            inicializa_elementos: Eprox = mostra_led; 
            mostra_led:           Eprox = fim_mostra_led ? inicio_da_rodada : mostra_led;
            inicio_da_rodada:     Eprox = espera_jogada;
            espera_jogada:        Eprox = (jogada && ~inativo) ? registra_jogada : 
                                           inativo ? final_com_timeout : espera_jogada;
            registra_jogada:      Eprox = compara_jogada;
            compara_jogada:       Eprox = ~jogada_igual ? final_com_erro : 
                                          (jogada_igual && fim_rodada) ? ultima_rodada : proxima_jogada;
            ultima_rodada:        Eprox = fim_jogo ? final_com_acertos : espera_nova;
            espera_nova:		  Eprox = inativo ? final_com_timeout : jogada ? registra_nova : espera_nova;
            registra_nova:		  Eprox = proxima_rodada;
            proxima_rodada:       Eprox = inicio_da_rodada;
            proxima_jogada:       Eprox = espera_jogada;
            final_com_acertos:    Eprox = iniciar ? inicializa_elementos : final_com_acertos;
            final_com_erro:       Eprox = iniciar ? inicializa_elementos : final_com_erro;
			final_com_timeout:    Eprox = iniciar ? inicializa_elementos : final_com_timeout;
            default:              Eprox = inicial;
        endcase
    end

    // Lógica de saída (maquina Moore)
    always @* begin
	 
		ramWE            = (Eatual == proxima_rodada       ) ? 1'b1 : 1'b0;
        zera_mostra_led  = (Eatual == inicial              ||
                            Eatual == inicializa_elementos ) ? 1'b1 : 1'b0;
        conta_mostra_led = (Eatual == mostra_led           ) ? 1'b1 : 1'b0;
        zera_jogada      = (Eatual == inicial              || 
                            Eatual == inicializa_elementos || 
                            Eatual == inicio_da_rodada     ) ? 1'b1 : 1'b0;
        conta_rodada     = (Eatual == proxima_rodada       ) ? 1'b1 : 1'b0;   
        zera_rodada      = (Eatual == inicial              || 
                            Eatual == inicializa_elementos || 
                            Eatual == final_com_acertos    || 
                            Eatual == final_com_erro       || 
                            Eatual == final_com_timeout    ) ? 1'b1 : 1'b0;
        conta_jogada     = (Eatual == proxima_jogada       || 
                            Eatual == registra_nova        ) ? 1'b1 : 1'b0;
        pronto           = (Eatual == final_com_acertos    || 
                            Eatual == final_com_erro       || 
                            Eatual == final_com_timeout    ) ? 1'b1 : 1'b0; 
        zeraR            = (Eatual == inicial              || 
                            Eatual == inicializa_elementos ) ? 1'b1 : 1'b0;
        registraR        = (Eatual == registra_jogada      || 
                            Eatual == registra_nova        ) ? 1'b1 : 1'b0;
        ganhou           = (Eatual == final_com_acertos    ) ? 1'b1 : 1'b0; 
        perdeu           = (Eatual == final_com_erro       || 
                            Eatual == final_com_timeout    ) ? 1'b1 : 1'b0;
		zeraInativo      = (Eatual == inicial              || 
                            Eatual == inicializa_elementos || 
                            Eatual == registra_jogada      ) ? 1'b1 : 1'b0;
		contaInativo     = (Eatual == espera_jogada        || 
                            Eatual == espera_nova          ) ? 1'b1 : 1'b0;

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
			espera_nova:          db_estado = 4'b1001; // 9
            final_com_acertos:    db_estado = 4'b1010; // A
			registra_nova:        db_estado = 4'b1011; // B 
            mostra_led:           db_estado = 4'b1100; // C 
            final_com_erro:       db_estado = 4'b1110; // E
	        final_com_timeout:    db_estado = 4'b1111; // F
            default:              db_estado = 4'b1101; 
        endcase
    end

endmodule