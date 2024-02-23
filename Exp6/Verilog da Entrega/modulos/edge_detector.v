/* ------------------------------------------------------------------------
 *  Arquivo   : edge_detector.v
 *  Projeto   : Experiencia 6 - Projeto Base do 
 *                              Jogo do Desafio da Memória
 * ------------------------------------------------------------------------
 *  Descricao : detector de borda
 *              gera um pulso na saida de 1 periodo de clock
 *              a partir da detecao da borda de subida sa entrada
 * 
 *              sinal de reset ativo em alto
 * 
 *              > codigo adaptado a partir de codigo VHDL disponivel em
 *                https://surf-vhdl.com/how-to-design-a-good-edge-detector/
 * ------------------------------------------------------------------------
 */
 
module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule
