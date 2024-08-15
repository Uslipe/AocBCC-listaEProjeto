.data
	str1: .space 20 #Reserva memória para string 1
	str2: .space 20 #Reserva memória para string 2
	
	msg1: .asciiz "Digite a primeira string: "
	msg2: .asciiz "Digite a segunda string: "
	
	msg_result_iguais: .asciiz "A saída é 0"
	msg_result_maior: .asciiz "A saída é 1"
	msg_result_menor: .asciiz "A saída é -1"
.text

	#Criar uma função que verifica se $a0 e $a1 são iguais
	#Oque fazer? um while comparando

		#Imprime a primeira mensagem
		la $a0, msg1
		jal funcao_imprime_string
		
		#Lê a primeira string do usuário
		li $v0, 8
		la $a0, str1
		li $a1, 20
		syscall		

		#Imprime a primeira mensagem
		la $a0, msg2
		jal funcao_imprime_string
		
		#Lê a segunda string do usuário
		li $v0, 8
		la $a0, str2
		li $a1, 20
		syscall
		
		la $a0, str1  #Carrega o endereço da primeira string em $a0
		la $a1, str2  #Carrega o endereço da segunda string em $a1
		jal funcao_compara_strings  #Chama a função
		
		# Imprime o resultado baseado no valor retornado
		beq $v0, 0, imprime_resultado_iguais #Verifica se o retorno é 0
		beq $v0, 1, imprime_resultado_maior #Verifica se o retorno é 1
		beq $v0, -1, imprime_resultado_menor #Verifica se o retorno é -1
	
		# Finaliza o programa
		li $v0, 10
		syscall
	
	#FUNÇÃO COM O PROPÓSITO SIMPLES DE IMPRIMIR UMA STRING	
	funcao_imprime_string:
		li $v0, 4 #Syscall 4 de impressão de string ou char
		syscall
		jr $ra #Retorna para onde chamaram ela
	
	#FUNÇÃO DE COMPARAR DUAS STRINGS, DETERMINAR SE SÃO IGUAIS, MAIOR OU MENOR
	funcao_compara_strings:
		while:
			lb $t0, 0($a0) #Carrega o primeiro byte de $a0 em $t0
			lb $t1, 0($a1) #Carrega o primeiro byte de $a1 em $t1
			
			#Primeira condição de parada: caractere nulo
			beq $t0, $t1, verifica_caractere_nulo #Se $t0 for igual a $t1, vai verificar se o caractere é nulo
			
			#Segunda condição de parada: caracteres diferentes
			bne $t0, $t1, verifica_maior_ou_menor
			
		
		verifica_caractere_nulo:
			beq $t0, $zero, verifica_caractere_nulo_2 #Se chegou ao caractere nulo de uma, vai para o da outra
			#Se não é o caractere nulo, segue abaixo
			addi $a0, $a0, 1 #Itera o byte
			addi $a1, $a1, 1 #Itera o byte
			j while #Volta para o loop
		
		verifica_caractere_nulo_2:
			beq $t1, $zero, strings_iguais #Se a segunda string tbm alcançou o caractere nulo, elas são iguais
			#Encerra programa
			j verifica_maior_ou_menor
			
		verifica_maior_ou_menor:
			bgt $t0, $t1, str1_maior_que_str2 #Se $t0 for maior que $t1, segue para o módulo
			#Se não, verifica se é menor
			blt $t0, $t1, str1_menor_que_str2 #$t0 é menor que $t1
			
		strings_iguais:
			li $v0, 0 #Strigs iguais 
			
			jr $ra #Retorna para o chamado
			
		str1_maior_que_str2:
			li $v0, 1 #É maior em str1
			jr $ra #Retorna para o chamado
		
		str1_menor_que_str2:
			li $v0, -1 #É menor em str1
			jr $ra #Retorna para o chamado
			
	#FUNÇÃO DE IMPRESSÃO DA MENSAGEM DO RESULTADO
	imprime_resultado_iguais:
		la $a0, msg_result_iguais #Carrega a mensagem em $a0
		jal funcao_imprime_string #Pula pra função de imprimir string com $a0 como parametro
		j finalizar

	#FUNÇÃO DE IMPRESSÃO DA MENSAGEM DO RESULTADO
	imprime_resultado_maior:
		la $a0, msg_result_maior #Carrega a mensagem em $a0
		jal funcao_imprime_string #Pula pra função de imprimir string com $a0 como parametro
		j finalizar

	#FUNÇÃO DE IMPRESSÃO DA MENSAGEM DO RESULTADO
	imprime_resultado_menor:
		la $a0, msg_result_menor #Carrega a mensagem em $a0
		jal funcao_imprime_string #Pula pra função de imprimir string com $a0 como parametro
		j finalizar

	#Módulo para finalizar o programa
	finalizar:
		li $v0, 10
		syscall
		
