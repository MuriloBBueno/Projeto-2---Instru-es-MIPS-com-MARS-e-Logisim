# Tabela Verdade - Sistema de Alarme

Entradas:
A = Porta aberta
B = Movimento
C = Sistema ligado

Saída:
S = Alarme

Regra:
S = (A OR B) AND C

A-B-C-S
0-0-0-0
0-0-1-0
0-1-0-0
0-1-1-1
1-0-0-0
1-0-1-1
1-1-0-0
1-1-1-1
