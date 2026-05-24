.data # RAM
#--------- Strings de Entrada ---------
	texto_porta: .asciiz " ...A porta esta aberta? 0 = nao 1 = sim "
	texto_movimento: .asciiz " ...Foi detectado algum movimento? 0 = nao 1 = sim "
	texto_chave: .asciiz " ...O sistema está ligado? 0 = nao 1 = sim "

#--------- Strings de IF ---------
	texto_Alarme_Acionado: .asciiz " ...Alarme foi acionado"
	texto_Alarme_Desacionado: .asciiz " ...Alarme NÃO foi acionado"

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
	
#--- Armazenar em $t1 ---
	move $t1, $v0 # O resultado da PORTA , esta em T1
	
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

#--- Armazenar em $t2 ---
	move $t2, $v0 # o resultado do MOVIMENTO , esta em t2

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

#--- Armazenar em $t3 ---
	move $t3, $v0 #o resultado do MOVIMENTO, esta em t3
	
#--- DEBUG () ---
	move $a0, $t2 #Move o resultado final para $a0, que é o argumento para a syscall
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
# $s1 = A+B
# $s2 = *C
# $s3 = S

# --- Clausula 1 (A+B) ---
	or $s0,$t1,$t2 # $s0 = A+B

# --- Clausula 2 (A+B) * C
	and $s1,$s0,$t3

# --- = ---
	move $s2 ,$s1

#======================================
# ENCERRAMENTO
#======================================
#	CODIGO EM C, GUIA:	
#	if (S = 1){
#		printf("OK")
#	}else{
#		printf("NAO")
#	}

beq $s2, $zero, Negativo # SE S = 0 , vai para negativo(desacionado)

# bloco do else{} (executa se nao desviou):
	li $v0, 4 # codigo para imprimir string
	la $a0, texto_Alarme_Acionado  # string do IF ACIONADO
	syscall 
		j fimIF # Pula o bloco do fimIF PARA NAO EXECUTAR OS DOIS
	
	Negativo:
		li $v0, 4 # codigo para imprimir string
		la $a0, texto_Alarme_Desacionado  # string do IF ACIONADO
		syscall

	fimIF:	# --- Return 0 (saída do programa) ---
		li $v0, 10
		syscall
