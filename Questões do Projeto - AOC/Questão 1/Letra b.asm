.data
msg_input: .asciiz "Digite os bytes a serem copiados: "
msg_output: .asciiz "Bytes copiados: "
buffer_origem: .space 100    	#Espa�o para armazenar os bytes originais 
buffer_dest: .space 100      	#Espa�o para armazenar os bytes copiados 

.text
.globl main
main:
	#Exibir mensagem para o usu�rio
    	li $v0, 4
    	la $a0, msg_input
    	syscall
    
    	#Ler a string digitada pelo usu�rio
    	li $v0, 8               	#Carrega 8 em $v0 para ler uma string
    	la $a0, buffer_origem   	#Endere�o de destino onde a string ser� armazenada
    	li $a1, 100             	#Tamanho m�ximo da string a ser lida
    	syscall
    
    	#Definir os par�metros para a fun��o memcpy
    	la $a0, buffer_dest     	#Endere�o de destino 
    	la $a1, buffer_origem   	#Endere�o de origem 
    	li $a2, 100             	#N�mero de bytes a serem copiados

    	#Chamar a fun��o memcpy
    	jal memcpy

    	#Exibir a msg_output
    	li $v0, 4				#Carrega 4 em $v0 para exibir uma string
    	la $a0, msg_output		#Exibe a mensagem final
    	syscall
    
    	#Exibir a string copiada
    	li $v0, 4				#Carrega 4 em $v0 para exibir uma string
    	la $a0, buffer_dest		#Exibe os bytes copiados
    	syscall
    
    	#Finalizar o programa
    	li $v0, 10			#Carrega 10 em $v0 para finalizar o programa
    	syscall

memcpy:
    	move $t0, $a0       	#$t0 = endere�o de destino
    	move $t1, $a1       	#$t1 = endere�o de origem
    	move $t2, $a2       	#$t2 = n�mero de bytes a serem copiados

loop_copia:
    	beqz $t2, fim_copia 	#Se $t2 == 0, fim da c�pia
    	lb $t3, 0($t1)      	#Carrega o byte atual da origem em $t3
    	sb $t3, 0($t0)      	#Armazena o byte atual no destino
    	addi $t0, $t0, 1    	#Avan�a para o pr�ximo byte do destino
    	addi $t1, $t1, 1    	#Avan�a para o pr�ximo byte da origem
    	addi $t2, $t2, -1   	#Decrementa o contador de bytes
    	j loop_copia        	#Repete o loop

fim_copia:
    	move $v0, $a0       	#Retorna o endere�o de destino em $v0
    	jr $ra              	#Retorna da fun��o