onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Entradas -color Blue -height 30 -label clock /exp4_fluxo_dados_tb/clock_in
add wave -noupdate -expand -group Entradas -color Gold -height 30 -label zeraC /exp4_fluxo_dados_tb/zeraC_in
add wave -noupdate -expand -group Entradas -color Gold -height 30 -label zeraR /exp4_fluxo_dados_tb/zeraR_in
add wave -noupdate -expand -group Entradas -color Gold -height 30 -label contaC /exp4_fluxo_dados_tb/contaC_in
add wave -noupdate -expand -group Entradas -color Gold -height 30 -label registraR /exp4_fluxo_dados_tb/registraR_in
add wave -noupdate -expand -group Entradas -color Gold -height 30 -label chaves -expand -subitemconfig {{/exp4_fluxo_dados_tb/chaves_in[3]} {-color Gold} {/exp4_fluxo_dados_tb/chaves_in[2]} {-color Gold} {/exp4_fluxo_dados_tb/chaves_in[1]} {-color Gold} {/exp4_fluxo_dados_tb/chaves_in[0]} {-color Gold}} /exp4_fluxo_dados_tb/chaves_in
add wave -noupdate -expand -group Resultado -height 30 -label chavesIgualMemoria /exp4_fluxo_dados_tb/chavesIgualMemoria_out
add wave -noupdate -expand -group Resultado -height 30 -label fimC /exp4_fluxo_dados_tb/fimC_out
add wave -noupdate -expand -group Resultado -height 30 -label db_contagem /exp4_fluxo_dados_tb/contagem_out
add wave -noupdate -expand -group Resultado -height 30 -label db_memoria /exp4_fluxo_dados_tb/memoria_out
add wave -noupdate -expand -group Resultado -height 30 -label db_chaves /exp4_fluxo_dados_tb/chaves_out
add wave -noupdate -height 30 /exp4_fluxo_dados_tb/clockPeriod
add wave -noupdate -height 30 /exp4_fluxo_dados_tb/notZeraC_out
add wave -noupdate -height 30 /exp4_fluxo_dados_tb/notZeraR_out
add wave -noupdate -height 30 /exp4_fluxo_dados_tb/caso
add wave -noupdate /exp4_fluxo_dados_tb/dut/s_chaves
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {160 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 265
configure wave -valuecolwidth 85
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {468 ns}
