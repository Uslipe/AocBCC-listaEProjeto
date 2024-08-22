.data
    	banner:         .asciiz "AFLM-Shell>> "
    	command:        .space 100		    	# Espaço para o comando inserido
    	num_apto: 	.space 5			# Espaço para o número do apartamento
	nome_apto: 	.space 50			# Espaço para o nome do morador
        tipo_auto:      .space 2                       #Espaço para o tipo do automóvel
    	modelo_auto:    .space 20                      #Espaço para o modelo do automóvel
    	placa_auto:     .space 12                      #Espaço para a placa do automóvel

    	#Nome do arquivo para salvar dados
    	filename:       .asciiz "dados.txt" # Nome do arquivo de dados
        #Caminho do arquivo para salvar dados
    	dadosSalvos:    .asciiz "C:/Users/alexa/OneDrive/Área de Trabalho/5NOITESNOMARS/dados.txt" # Caminho do arquivo
    	
    	#Quebra de linha, hifen e vírgula
    	quebra_linha:   .asciiz "\n"        # Nova linha para formatação
    	hifen:          .asciiz "- "       # Separador entre apto e moradores
    	virgula:        .asciiz ", "        # Separador entre moradores
    	
    	#Comandos válidos
    	cmd_addMorador:     .asciiz "addMorador"
    	cmd_rmvMorador:     .asciiz "rmvMorador"
    	cmd_addAuto:        .asciiz "addAuto"
    	cmd_rmvAuto:        .asciiz "rmvAuto"
    	cmd_limparAp:       .asciiz "limparAp"
    	cmd_infoAp:         .asciiz "infoAp"
    	cmd_infoGeral:      .asciiz "infoGeral"
    	cmd_salvar:         .asciiz "salvar"
    	cmd_recarregar:     .asciiz "recarregar"
    	cmd_formatar:       .asciiz "formatar"
    	
    	#Mensagem de comando inválido
    	msg_comando_invalido:.asciiz "Comando inválido\n"

.text
.globl main

main:
    # Loop principal para processar comandos
main_loop:
    jal print_banner           # Imprime o banner do terminal
    jal read_command           # Lê o comando do teclado
    
    jal clear_newline          # Remove a nova linha (\n) da string lida
    
    jal check_command          # Verifica se o comando é válido
    blt $v0, $zero, comando_invalido # Se o comando for inválido, exibe mensagem se comando inválido
    bgez $v0, executar_comando # Se o comando for válido, executa-o
    
    j main_loop                # Retorna ao loop principal

# Função para imprimir o banner no console
print_banner:
    li $v0, 4
    la $a0, banner
    syscall
    jr $ra

# Função para imprimir uma nova linha
print_novalinha:
    li $v0, 4
    la $a0, quebra_linha
    syscall
    jr $ra
    
# Função para imprimir mensagem de comando inválido
comando_invalido:
    li $v0, 4
    la $a0, msg_comando_invalido
    syscall
    jal print_novalinha		# Chama print_novalinha para pular uma linha
    j main_loop			    # Retorna ao loop principal

# Função para ler o comando do teclado
read_command:
    li $v0, 8          # syscall para leitura de string
    la $a0, command    # Endereço onde a string será armazenada
    li $a1, 100        # Tamanho máximo da string
    syscall
    jr $ra

# Função para remover a nova linha (\n) da string lida
clear_newline:
    la $t0, command    # Ponteiro para o início da string
    li $t1, 0x0A       # Caractere de nova linha (\n)
    
clear_newline_loop:
    lb $t2, 0($t0)     # Caractere atual
    beq $t2, $t1, replace_with_null # Se for nova linha, substitui por \0
    beq $t2, $zero, end_clear_newline # Se for \0, termina
    addi $t0, $t0, 1   # Avança para o próximo caractere
    j clear_newline_loop

replace_with_null:
    sb $zero, 0($t0)   # Substitui nova linha por \0

end_clear_newline:
    jr $ra
    
# Função para verificar se o comando é válido
check_command:
    add $sp, $sp, -8       # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)         # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)         # Armazena $ra (endereço de retorno)

    # Verificar cmd_addMorador
    la $a1, cmd_addMorador      # Carrega o endereço do comando "addMorador" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_addMorador  # Se for igual a "addMorador", salta para ret_addMorador

    # Verificar cmd_rmvMorador
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_rmvMorador      # Carrega o endereço do comando "rmvMorador" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_rmvMorador  # Se for igual a "rmvMorador", salta para ret_rmvMorador

    # Verificar cmd_addAuto
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_addAuto        # Carrega o endereço do comando "addAuto" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_addAuto  # Se for igual a "addAuto", salta para ret_addAuto

    # Verificar cmd_rmvAuto
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_rmvAuto        # Carrega o endereço do comando "rmvAuto" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_rmvAuto  # Se for igual a "rmvAuto", salta para ret_rmvAuto

    # Verificar cmd_limparAp
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_limparAp       # Carrega o endereço do comando "limparAp" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_limparAp  # Se for igual a "limparAp", salta para ret_limparAp

    # Verificar cmd_infoAp
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_infoAp         # Carrega o endereço do comando "infoAp" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_infoAp  # Se for igual a "infoAp", salta para ret_infoAp

    # Verificar cmd_infoGeral
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_infoGeral      # Carrega o endereço do comando "infoGeral" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_infoGeral  # Se for igual a "infoGeral", salta para ret_infoGeral

    # Verificar cmd_salvar
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_salvar         # Carrega o endereço do comando "salvar" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_salvar  # Se for igual a "salvar", salta para ret_salvar

    # Verificar cmd_recarregar
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_recarregar     # Carrega o endereço do comando "recarregar" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_recarregar  # Se for igual a "recarregar", salta para ret_recarregar

    # Verificar cmd_formatar
    add $sp, $sp, -8           # Reserva espaço na pilha para $a0 e $ra
    sw $a0, 4($sp)             # Armazena $a0 (endereço do comando)
    sw $ra, 0($sp)             # Armazena $ra (endereço de retorno)
    la $a1, cmd_formatar       # Carrega o endereço do comando "formatar" em $a1
    jal funcao_compara_strings  # Chama a função de comparação de strings
    lw $a0, 4($sp)             # Restaura $a0 (endereço do comando)
    lw $ra, 0($sp)             # Restaura $ra (endereço de retorno)
    addi $sp, $sp, 8           # Libera o espaço na pilha
    beq $v0, $zero, ret_formatar  # Se for igual a "formatar", salta para ret_formatar

    # Comando inválido
    li $v0, -1
    jr $ra

# Função para comparar duas strings, verifica se são iguais
funcao_compara_strings:
    loop:
        lb $t0, 0($a0)             # Caractere atual da string 1 (comando inserido)
        lb $t1, 0($a1)             # Caractere atual da string 2 (comando esperado)
        
        beqz $t1, comando_com_parametros  # Se chegamos ao final de $a1 (string esperada), pode haver parâmetros
        bne $t0, $t1, strings_diferentes  # Se os caracteres são diferentes, as strings são diferentes
        beq $t0, $zero, strings_iguais    # Se o caractere atual em $a0 for null, ambas as strings terminaram simultaneamente

        addi $a0, $a0, 1           # Incrementa o ponteiro da string 1
        addi $a1, $a1, 1           # Incrementa o ponteiro da string 2
        j loop                     # Continua comparando

comando_com_parametros:
        lb $t2, 0($a0)
        beq $t2, $zero, strings_iguais  # Verifica se a string acabou (comando sem parâmetros adicionais)
        beq $t2, 0x20, strings_iguais   # Verifica se o próximo caractere é um espaço (indicando início de parâmetros)
        j strings_diferentes

strings_iguais:
        li $v0, 0                  # Strings são iguais
        jr $ra                     # Retorna da função
        
strings_diferentes:
        li $v0, 1                  # Strings são diferentes
        jr $ra                     # Retorna da função

#Funções para carregar em $v0 os valores respectivos a cada função chamada
ret_addMorador:
    li $v0, 1
    jr $ra

ret_rmvMorador:
    li $v0, 2
    jr $ra

ret_addAuto:
    li $v0, 3
    jr $ra

ret_rmvAuto:
    li $v0, 4
    jr $ra

ret_limparAp:
    li $v0, 5
    jr $ra

ret_infoAp:
    li $v0, 6
    jr $ra

ret_infoGeral:
    li $v0, 7
    jr $ra

ret_salvar:
    li $v0, 8
    jr $ra

ret_recarregar:
    li $v0, 9
    jr $ra

ret_formatar:
    li $v0, 10
    jr $ra

# Função que deve ser chamada para executar o comando
executar_comando:
    beq $v0, 1, add_Morador
    beq $v0, 2, rmv_Morador
	beq $v0, 3, add_Auto
	beq $v0, 4, rmv_Auto
	beq $v0, 5, limpar_Ap
	beq $v0, 6, info_Ap
	beq $v0, 7, info_Geral
	beq $v0, 8, salvar
	beq $v0, 9, recarregar
	beq $v0, 10, formatar

# Função de adicionar morador
add_Morador:
    	la $t0, command            # Carrega o endereço do buffer de comando
    	addi $t0, $t0, 11          # Move o ponteiro para depois de 'addMorador '

    	# Identificar a primeira opção (número do apartamento)
    	la $a0, num_apto           # Endereço onde armazenaremos o número do apartamento
    	jal read_option            # Chama a função para ler a opção
    	li $v0, 4
    	la $a0, num_apto
    	syscall                    # Exibe o número do apartamento

    	# Identificar a segunda opção (nome do morador)
    	la $a0, nome_apto          # Endereço onde armazenaremos o nome do morador
    	jal read_option            # Chama a função para ler a opção
    	li $v0, 4
    	la $a0, nome_apto
    	syscall                    # Exibe o nome do morador

        #Salvar no arquivo
	jal add_to_file

	#Pula duas linhas
    	jal print_novalinha
    	jal print_novalinha

    	j main_loop                # Volta para o loop principal

rmv_Morador:
	
	
	
	j main_loop

add_Auto:
        # Pular a parte 'addAuto '
        la $t0, command
        addi $t0, $t0, 8

        # Identificar a primeira opção (número do apartamento)
        la $a0, num_apto               # Endereço onde armazenaremos o número do apartamento
        jal read_option
        li $v0, 4
        la $a0, num_apto
        syscall
        
        # Identificar a segunda opção (tipo do veículo)
        la $a0, tipo_auto              # Endereço onde armazenaremos o tipo do veículo
        jal read_option
        li $v0, 4
        la $a0, tipo_auto
        syscall
    
        # Indentificar a terceira opção (modelo do veículo)
        la $a0, modelo_auto               # Endereço onde armazenaremos o modelo do veículo
        jal read_option
        li $v0, 4
        la $a0, modelo_auto
        syscall
    
        # Identificar a quarta opção (placa do veículo)
        la $a0, placa_auto              # Endereço onde armazenaremos o número da placa
        jal read_option
        li $v0, 4
        la $a0, placa_auto
        syscall
    
        # Manipular arquivo dados.txt (essa parte ainda está a ser implementada)
        jal add_to_file_auto
    
        # Exibir uma nova linha para separação
        li $v0, 4
        la $a0, quebra_linha
        syscall

	j main_loop

rmv_Auto:


	j main_loop

limpar_Ap:


	j main_loop

info_Ap:


	j main_loop

info_Geral:


	j main_loop

salvar:


	j main_loop

recarregar:


	j main_loop

formatar:


	j main_loop
	
read_option:
    addi $t0, $t0, 2                # Pula '--'
    li $t3, 0                       # Inicializa contador
    
read_char:
    lb $t4, 0($t0)                  # Lê um caractere
    beqz $t4, end_option            # Se for null, termina
    beq $t4, 0x0A, end_option       # Se for newline, termina
    beq $t4, '-', check_next_char   # Se for '-', verificar se é o próximo argumento
    sb $t4, 0($a0)                  # Armazena caractere na memória (em num_apto ou nome_apto)
    addi $t0, $t0, 1                # Avança para o próximo caractere na entrada
    addi $a0, $a0, 1                # Avança para o próximo endereço na memória
    j read_char

check_next_char:
    lb $t5, 1($t0)                  # Lê o próximo caractere
    bne $t5, '-', not_option_end    # Se não for '--', continua lendo o nome
    j end_option                    # Se for '--', termina a leitura

not_option_end:
    sb $t4, 0($a0)                  # Armazena o '-' anterior
    addi $a0, $a0, 1                # Avança para o próximo endereço na memória
    addi $t0, $t0, 1                # Avança para o próximo caractere
    j read_char                     # Continua a leitura

end_option:
    sb $zero, 0($a0)                # Adiciona null terminator
    jr $ra                          # Retorna da função
	
# Função para extrair o número do apartamento e nome do morador
extrair_info:
    # $a0 = endereço do comando completo
    add $t0, $a0, $a1        # pula o comando "addMorador "
    
    la $t1, num_apto         # endereço de num_apto
    la $t2, nome_apto        # endereço de nome_apto
    
    # Extrai o número do apartamento
copia_num_apto:
    lb $t3, 0($t0)
    beq $t3, ' ', fim_copia_num_apto
    sb $t3, 0($t1)
    addi $t0, $t0, 1
    addi $t1, $t1, 1
    j copia_num_apto

fim_copia_num_apto:
    sb $zero, 0($t1)
    addi $t0, $t0, 3        # Pula " --"
    
    # Extrai o nome do morador
copia_nome_apto:
    lb $t3, 0($t0)
    beq $t3, $zero, fim_extracao
    sb $t3, 0($t2)
    addi $t0, $t0, 1
    addi $t2, $t2, 1
    j copia_nome_apto
    
fim_extracao:
    sb $zero, 0($t2)
    jr $ra

add_to_file:
   # Abrir o arquivo para escrita (append)
    li $v0, 13                      # Syscall para abrir arquivo
    la $a0, dadosSalvos                # Nome do arquivo
    li $a1, 9                       # Código para permissão do arquivo
    li $a2, 664                       # Sem flags adicionais
    syscall

    move $s0, $v0                   # Salva o file descriptor no $t0

    # Escrever o número do apartamento e nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, num_apto               # Pega o endereço do número do apartamento (com separador)
    li $a2, 5                      # Tamanho máximo
    syscall
    
    # Escrever o separador "- " no arquivo
    li $v0, 15
    move $a0, $s0  # Move o descritor do arquivo para o registrador $a0
    la $a1, hifen             # Endereço do separador
    li $a2, 2                  # Tamanho do separador 
    syscall
    
    # Escrever o espaço e o nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, nome_apto           # Pega o endereço do nome do morador
    li $a2, 50                      # Tamanho máximo de 50 bytes
    syscall

    # Escrever uma nova linha no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, quebra_linha                 # Escreve uma nova linha no arquivo
    li $a2, 1                       # Escreve apenas 1 byte (newline)
    syscall

    # Fechar o arquivo
    li $v0, 16                      # Syscall para fechar o arquivo
    move $a0, $s0                   # File descriptor
    syscall

    jr $ra                          # Retorna da função

add_to_file_auto:
   # Abrir o arquivo para escrita (append)
    li $v0, 13                      # Syscall para abrir arquivo
    la $a0, dadosSalvos                # Nome do arquivo
    li $a1, 9                       # Modo de escrita (1 para write-only)
    li $a2, 664                       # Sem flags adicionais
    syscall

    move $s0, $v0                   # Salva o file descriptor no $t0

    # Escrever o número do apartamento e nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, num_apto               # Pega o endereço do número do apartamento (com separador)
    li $a2, 5                      # Tamanho máximo
    syscall
    
    # Escrever o separador "- " no arquivo
    li $v0, 15
    move $a0, $s0  # Move o descritor do arquivo para o registrador $a0
    la $a1, hifen             # Endereço do separador
    li $a2, 2                  # Tamanho do separador 
    syscall
    
    # Escrever o espaço e o nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, tipo_auto           # Pega o endereço do nome do morador
    li $a2, 2                      # Tamanho máximo de 50 bytes
    syscall

    # Escrever o separador "- " no arquivo
    li $v0, 15
    move $a0, $s0  # Move o descritor do arquivo para o registrador $a0
    la $a1, hifen             # Endereço do separador
    li $a2, 2                  # Tamanho do separador 
    syscall
    
    # Escrever o espaço e o nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, modelo_auto           # Pega o endereço do nome do morador
    li $a2, 20                      # Tamanho máximo de 50 bytes
    syscall
    
    # Escrever o separador "- " no arquivo
    li $v0, 15
    move $a0, $s0  # Move o descritor do arquivo para o registrador $a0
    la $a1, hifen             # Endereço do separador
    li $a2, 2                  # Tamanho do separador 
    syscall
    
    # Escrever o espaço e o nome do morador no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, placa_auto           # Pega o endereço do nome do morador
    li $a2, 12                      # Tamanho máximo de 50 bytes
    syscall

    # Escrever uma nova linha no arquivo
    li $v0, 15                      # Syscall para escrever no arquivo
    move $a0, $s0                   # File descriptor
    la $a1, quebra_linha                 # Escreve uma nova linha no arquivo
    li $a2, 1                       # Escreve apenas 1 byte (newline)
    syscall

    # Fechar o arquivo
    li $v0, 16                      # Syscall para fechar o arquivo
    move $a0, $s0                   # File descriptor
    syscall

    jr $ra                          # Retorna da função

load_data:
    jr $ra
