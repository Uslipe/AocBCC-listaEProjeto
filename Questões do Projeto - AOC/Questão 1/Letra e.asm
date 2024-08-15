.data
msg: .asciiz "Digite a primeira string: "      # Mensagem inicial para a primeira string
msg2: .asciiz "Digite a segunda string: "      # Mensagem inicial para a segunda string
msg_result: .asciiz "\nString concatenada: "   # Mensagem para exibir a string concatenada
buffer1: .space 100                            # Espaço para armazenar a primeira string (100 bytes)
buffer2: .space 100                            # Espaço para armazenar a segunda string (100 bytes)

.text
.globl main
main:
    	# Exibir a mensagem inicial para a primeira string
    	li $v0, 4
    	la $a0, msg
    	syscall
    
    	# Ler a primeira string digitada pelo usuário
    	li $v0, 8
    	la $a0, buffer1
    	li $a1, 100
    	syscall
    	jal remove_novaLinha   # Remove a quebra de linha, se houver

    	# Exibir a mensagem inicial para a segunda string
    	li $v0, 4
    	la $a0, msg2
    	syscall
    
    	# Ler a segunda string digitada pelo usuário
    	li $v0, 8
    	la $a0, buffer2
    	li $a1, 100
    	syscall
    	jal remove_novaLinha   # Remove a quebra de linha, se houver

    	# Chamar a função strcat
    	la $a0, buffer1           		# $a0 = endereço de destino(buffer1)
    	la $a1, buffer2           		# $a1 = endereço de origem (buffer2)
    	jal strcat                		# Chama a função strcat

    	# Exibir a mensagem para a string concatenada
    	li $v0, 4
    	la $a0, msg_result
    	syscall

    	# Exibir a string concatenada
    	li $v0, 4
    	la $a0, buffer1
    	syscall

    	# Finalizar o programa
    	li $v0, 10
    	syscall
    	
remove_novaLinha:
	# Percorre a string no buffer passado em $a0 para remover a quebra de linha
    	move $t0, $a0             	  # $t0 = endereço da string
    	
remove_loop:
    	lb $t1, 0($t0)            	  # Carrega o byte atual da string em $t1
    	beq $t1, $zero, fim_remove  	# Se encontrar NULL, termina a verificação
    	beq $t1, 10, substituir_null 	# Se encontrar '\n' (ASCII 10), substitui por NULL
    	addi $t0, $t0, 1          	  # Avança para o próximo byte
    	j remove_loop             	  # Continua verificando
    	
substituir_null:
    sb $zero, 0($t0)          	# Substitui '\n' por NULL
    
fim_remove:
    jr $ra                    	# Retorna da função

strcat:
    	# Verificação de sobreposição
    	la $t4, 100($a0)                	# $t4 = endereço final de `destination` (buffer1 + 100)
    	blt $a1, $a0, continuar         	# Se `source` (buffer2) começa antes de `destination` (buffer1), não há sobreposição
    	ble $t4, $a1, continuar         	# Se o final de `destination` <= início de `source`, não há sobreposição

    	# Se houve sobreposição, finalize o programa ou trate o erro
    	li $v0, 4                      	# Carrega 4 em $v0 para exibir uma mensagem de erro
    	la $a0, msg_result             	# Mensagem de erro (você pode definir uma nova mensagem no .data)
    	syscall
    	li $v0, 10                     	# Finaliza o programa
	syscall

continuar:
    	# Encontrar o final da string em destination ($a0)
    	move $t0, $a0            		# $t0 = endereço de destino
    
encontrar_fim:
    	lb $t1, 0($t0)           		    # Carrega o byte atual de destino em $t1
    	beq $t1, $zero, copiar_source 	# Se $t1 == NULL, encontrou o final da string
    	addi $t0, $t0, 1         		    # Avança para o próximo byte
    	j encontrar_fim          		    # Continua buscando o final da string

copiar_source:
    	# Copiar a string de source ($a1) para o final de destination
    	move $t2, $a1            		# $t2 = endereço de origem
    
copiar_loop:
    	lb $t3, 0($t2)           		  # Carrega o byte atual de origem em $t3
    	sb $t3, 0($t0)           		  # Armazena o byte atual no destino (no final da string)
    	beq $t3, $zero, fim_strcat 		# Se o byte for NULL, termina a cópia
    	addi $t0, $t0, 1         		  # Avança para o próximo byte no destino
    	addi $t2, $t2, 1         		  # Avança para o próximo byte na origem
    	j copiar_loop            		  # Repete o loop

fim_strcat:
    	move $v0, $a0            		# Retorna o endereço de destino em $v0
    	jr $ra                   		# Retorna da função
