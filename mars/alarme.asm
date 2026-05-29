.data # RAM
#--------- Strings de Entrada ---------
	texto_porta: .asciiz " A porta esta aberta? 0 = nao 1 = sim "
	texto_movimento: .asciiz "\nFoi detectado algum movimento? 0 = nao 1 = sim "
	texto_chave: .asciiz "\nO sistema está ligado? 0 = nao 1 = sim "

#--------- Strings de IF ---------
	texto_Alarme_Acionado: .asciiz "\nAlarme foi acionado"
	texto_Alarme_Desacionado: .asciiz "\nAlarme NÃO foi acionado"

.text # INSTRUÇÕES
#======================================
# PORTA
#======================================
#--- Imprimir texto da porta ---
	li $v0, 4 # parametro para que seja impresso uma string
	la $a0, texto_porta # string foi movida para a0 , procedimento padrão/obrigatorio 
	syscall # chamada de sistema , faça isso 
	
#--- Ler Inteiro PORTA ---
	li $v0, 5 # parametro para que seja LIDO/ler um inteiro 	
	syscall # faça isso
	
# --- Converter qualquer valor != 0 em 1 ---
	move $t1, $v0
	sltu $t1, $zero, $t1 # qualquer != 0 vira 1
	
	
#--- DEBUG (remover em produção ou comentar) ---
	move $a0, $t1 #Move o resultado final para $a0, que é o argumento para a syscall
	li $v0, 1 #define o codigo da syscall para imprimir inteiro
	syscall 

#======================================
# MOVIMENTO
#======================================
#--- Imprimir texto do movimento ---
	li $v0, 4 #codigo para imprimir string 
	la $a0, texto_movimento #string foi movida para a0, para que seja impressa pelo syscall
	syscall
	
#--- Ler inteiro do movimento ---
	li $v0, 5 #codigo para ler/lido um inteiro / capturar
	syscall 
	
# --- Converter qualquer valor != 0 em 1 ---
	move $t2, $v0
	sltu $t2, $zero, $t2 # qualquer != 0 vira 1
	
#--- DEBUG (remover em produção ou comentar)
	move $a0, $t2 #Move o resultado final para $a0, que é o argumento para a syscall
	li $v0, 1 #define o codigo da syscall para imprimir inteiro
	syscall

#======================================
# CHAVE / SISTEMA
#======================================
#--- Imprimir texto da chave ---
	li $v0, 4 #codigo para imprimir string
	la $a0, texto_chave #string foi movida para a0, para que seja impressa pela syscall
	syscall

#--- Ler inteiro do movimento ---
	li $v0, 5 #codigo para ler/lido um inteiro/ capturar do teclado
	syscall
	
# --- Converter qualquer valor != 0 em 1 ---
	move $t3, $v0
	sltu $t3, $zero, $t3 # qualquer != 0 vira 1

#--- DEBUG () ---
	move $a0, $t3 #Move o resultado final para $a0, que é o argumento para a syscall
	li $v0, 1 #define o codigo da syscall para imprimir inteiro
	syscall

#======================================
# RESULTADO / LÓGICA
#======================================
# (A+B)*C = S
# --- CIRCUITO ---
# $t1 = PORTA (0/1)
# $t2 = MOVIMENTO (0/1)
# $t3 = CHAVE (0/1)

# --- CLAUSULAS ---
# $s0 = A+B
# $s1 = S = *C

# --- Clausula 1 (A+B) ---
	or $s0,$t1,$t2 # $s0 = A+B

# --- Clausula 2 (A+B) * C
	and $s1,$s0,$t3

#======================================
# ENCERRAMENTO
#======================================
# 	em C:
#
# 	if (S != 0){
# 		printf("ACIONADO");
# 	} else {
# 		printf("DESACIONADO");
#	}
#

# se alarme=0 , PULA para label senao pro if
beq $s1, $zero, Negativo 
	
	#IF (Alarme Ligado)
	li $v0, 4 # codigo para imprimir string
	la $a0, texto_Alarme_Acionado  # string do IF ACIONADO
	syscall 
		j fimIF # Pula o bloco do fimIF PARA NAO EXECUTAR OS DOIS
	
	#Else/label (Alarme Desligado)
	Negativo:
		li $v0, 4 # codigo para imprimir string
		la $a0, texto_Alarme_Desacionado  # string do IF ACIONADO
		syscall

	#Equivalente a chave de fechamento em C } -> acabou o if e else
	fimIF:	# --- Return 0 (saída do programa) ---
		li $v0, 10
		syscall
#======================================
# EXTRA
#======================================
# sltu = Set if less than , Unsigned
# Sintaxe:
#  sltu $rd, $rs, $rt
# -> se rS for menor que rT , colocar 1 em rD
