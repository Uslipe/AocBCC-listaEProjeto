.data
msg: .asciiz "Digite uma string pra ser copiada: "	#Mensagem inicial
msg_copia: .asciiz "\nString copiada: " 		#Mensagem para exibir a string copiada
buffer: .space 100					#Espaço para armazenar a string copiada (100 bytes)

.text
.globl main
main:
	#Exibir a mensagem inicial
	li $v0, 4				#Carrega 4 em $v0 pra imprimir a mensagem inicial
	la $a0, msg				#Imprime a mensagem inicial
	syscall
	
	#Ler a string digitada pelo usuário
    	li $v0, 8				#Carrega 8 em $v0 pra ler uma string
    	la $a0, buffer          		#Endereço de destino onde a string vai ser armazenada
    	li $a1, 100             		#Tamanho máximo da string a ser lida
    	syscall

	#Chamar a função strcpy
    	la $a0, buffer          		#$a0 recebe o endereço de destino (onde a string será copiada)
    	move $a1, $a0           		#$a1 recebe o endereço de origem (a própria string lida)
    	jal strcpy              		#Chama a função strcpy
    	
    	#Exibir a mensagem para a string copiada
    	li $v0, 4                		#Carrega 4 em $v0 para imprimir a mensagem
    	la $a0, msg_copia        		#Endereço da mensagem de exibição da string copiada
    	syscall

    	#Exibir a string copiada
    	li $v0, 4                		#Carrega 4 em $v0 para imprimir a string copiada
    	la $a0, buffer           		#Endereço da string copiada
    	syscall

	#Finalizar o programa
	li $v0, 10				#Carrega 10 em $v0 pra finalizar o programa
	syscall			
	
strcpy:
    	move $t0, $a0       			#$t0 = endereço de destino
    	move $t1, $a1       			#$t1 = endereço de origem
    	
loop_copia:
	lb $t2, 0($t1)           		#Carrega o byte atual da origem em $t2
	
    	#Verificar se o caractere é um número ('0', '9')
    	li $t3, 0x30             		#Carrega o valor ASCII de '0' em $t3
    	li $t4, 0x39             		#Carrega o valor ASCII de '9' em $t4
    	blt $t2, $t3, check_alpha		#Se $t2 < '0', pode ser uma letra, então checar próximo
    	bgt $t2, $t4, check_alpha		#Se $t2 > '9', pode ser uma letra, então checar próximo
    
    	j skip_char             		#Se estiver entre '0' e '9', ignora e vai para o próximo caractere

check_alpha:
    	sb $t2, 0($t0)          		#Armazena o byte atual no destino
    	addi $t0, $t0, 1        		#Avança para o próximo byte do destino
    
skip_char:
	addi $t1, $t1, 1        		#Avança para o próximo byte da origem
    	bnez $t2, loop_copia    		#Continua se o byte não for NULL

fim_loop:
    sb $zero, 0($t0)         			#Adiciona caractere NULL para finalizar a string copiada
    move $v0, $a0            			#Retorna o endereço de destino em $v0
    jr $ra                   			#Retorna da função
