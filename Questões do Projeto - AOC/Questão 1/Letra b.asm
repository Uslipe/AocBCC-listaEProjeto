.data
msg_input: .asciiz "Digite os bytes a serem copiados: "
msg_output: .asciiz "Bytes copiados: "
buffer_origem: .space 100    	#Espaço para armazenar os bytes originais 
buffer_dest: .space 100      	#Espaço para armazenar os bytes copiados 

.text
.globl main
main:
	#Exibir mensagem para o usuário
    	li $v0, 4
    	la $a0, msg_input
    	syscall
    
    	#Ler a string digitada pelo usuário
    	li $v0, 8               	#Carrega 8 em $v0 para ler uma string
    	la $a0, buffer_origem   	#Endereço de destino onde a string será armazenada
    	li $a1, 100             	#Tamanho máximo da string a ser lida
    	syscall
    
    	#Definir os parâmetros para a função memcpy
    	la $a0, buffer_dest     	#Endereço de destino 
    	la $a1, buffer_origem   	#Endereço de origem 
    	li $a2, 100             	#Número de bytes a serem copiados

    	#Chamar a função memcpy
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
    	move $t0, $a0       	#$t0 = endereço de destino
    	move $t1, $a1       	#$t1 = endereço de origem
    	move $t2, $a2       	#$t2 = número de bytes a serem copiados

loop_copia:
    	beqz $t2, fim_copia 	#Se $t2 == 0, fim da cópia
    	lb $t3, 0($t1)      	#Carrega o byte atual da origem em $t3
    	sb $t3, 0($t0)      	#Armazena o byte atual no destino
    	addi $t0, $t0, 1    	#Avança para o próximo byte do destino
    	addi $t1, $t1, 1    	#Avança para o próximo byte da origem
    	addi $t2, $t2, -1   	#Decrementa o contador de bytes
    	j loop_copia        	#Repete o loop

fim_copia:
    	move $v0, $a0       	#Retorna o endereço de destino em $v0
    	jr $ra              	#Retorna da função