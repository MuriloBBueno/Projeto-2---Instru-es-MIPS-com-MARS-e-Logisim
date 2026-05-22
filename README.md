# Projeto-2---Instru-es-MIPS-com-MARS-e-Logisim

Uma indústria deseja implementar um sistema básico de segurança para monitoramento de acesso e movimentação em uma área restrita.

O sistema possui três sensores:

| Sensor | Descrição |
| :---- | :---- |
| Sensor A | Detecta se a porta está aberta |
| Sensor B | Detecta movimentação no ambiente |
| Sensor C |  Chave de ativação do sistema |

A saída do sistema será o acionamento do alarme.

**Regras do Sistema:**

Os sensores funcionam da seguinte forma:

| Variável | Valor 0 | Valor 1 |
| :---- | :---- | :---- |
| A | Porta fechada | Porta aberta |
| B | Sem movimento | Movimento detectado |
| C | Sistema desligado | Sistema ligado |

A saída do sistema será:

| Saída | Significado |
| :---- | :---- |
| S | Alarme  desligado (0)  ligado (1) |

**Funcionamento Esperado:**  
O alarme deverá ser ativado somente quando:

* o sistema estiver ligado; e  
* houver alguma situação de risco:  
* o porta aberta; ou  
* o movimento detectado.

# PARTE 1: Tabela Verdade

1. construir tabela verdade  
2. identificar todas as combinações possiveis  
3. determinar quando o alarme deve ser acionado

# 

# PARTE 2:  Expressão Booleana

1. encontrar expressao   
2. simplificar  
3. apresentar expressao final

# 

# PARTE 3: Implementação no MARS (Assembly MIPS)

1. Solicitar os valores (A,B,C,D….)  
2. utilizar operaçoes logicas bit a bit  
3. implementar logica do sistema de alarme   
4. exibir resultado final do alarme

**Usar:** 

* and  
* or  
* xori/li  
* syscall

**obrigatorio:**

1. registrador mips  
2. binario simples(0,1)  
3. syscall para entrada e saida de dados,  
4. organizar o codigo de forma legivel e comentada

# 

# PARTE 4: Implementação no Logisim

1. entradas  
2. componentes logicos(and/or/inversos/etc)  
3. saida sendo um led representando o estado do alarme

# 

# PARTE 5: Relatório

1. Introdução  
2. Fundamentação teórica;  
3. Tabela verdade;  
4. Expressão booleana;  
5. Implementação em MIPS;  
6. Implementação no Logisim;  
7. Resultados;  
8. Conclusão;  
9. Referências.

# 

# PARTE 6: Apresentação

1. funcionamento do programa MIPS;  
2.  explicação da lógica utilizada;  
3.  demonstração do circuito no Logisim;  
4.  testes do sistema.

# PARTE 7: ENTREGAS:

.asm (MIPS) \+ .circ (Logisim) \+ pdf (Relatorio padrao)
