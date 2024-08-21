.data
banner:         .asciiz "AFLM-Shell>> "
buffer:         .space 128         # Buffer para armazenar a linha de comando
apartment:      .space 10          # Espaço para o número do apartamento
resident_name:  .space 50          # Espaço para o nome do morador
filename:       .asciiz "dados.txt" # Nome do arquivo de dados
newline:        .asciiz "\n"        # Nova linha para formatação
separator:      .asciiz " - "       # Separador entre apto e moradores
comma:          .asciiz ", "        # Separador entre moradores

.text
.globl main

main:

    li $v0, 4
    la $a0, banner
    syscall
    
    # Leitura da linha de comando
    li $v0, 8                       # syscall para leitura de string
    la $a0, buffer                  # endereço do buffer
    li $a1, 128                     # tamanho máximo da string
    syscall

    # Pular a parte 'addMorador '
    la $t0, buffer
    addi $t0, $t0, 11               # Move o ponteiro para depois de 'addMorador '

    # Identificar a primeira opção (número do apartamento)
    la $a0, apartment               # Endereço onde armazenaremos o número do apartamento
    jal read_option
    li $v0, 4
    la $a0, apartment
    syscall

    # Identificar a segunda opção (nome do morador)
    la $a0, resident_name           # Endereço onde armazenaremos o nome do morador
    jal read_option
    li $v0, 4
    la $a0, resident_name
    syscall

    # Manipular arquivo dados.txt
    #jal add_to_file

    # Encerrar o programa
    li $v0, 10
    syscall

# Função para ler uma opção (após '--')
read_option:
    addi $t0, $t0, 2                # Pula '--'
    li $t3, 0                       # Inicializa contador
read_char:
    lb $t4, 0($t0)                  # Lê um caractere
    beqz $t4, end_option            # Se for null, termina
    beq $t4, 0x20, end_option       # Se for espaço, termina
    sb $t4, 0($a0)                  # Armazena caractere na memória (em apartment ou resident_name)
    addi $t0, $t0, 1                # Avança para o próximo caractere na entrada
    addi $a0, $a0, 1                # Avança para o próximo endereço na memória
    j read_char
    
end_option:
    sb $zero, 0($a0)                # Adiciona null terminator
    jr $ra                          # Retorna da função

# Função para adicionar o morador ao arquivo
#add_to_file:

   # jr $ra                          # Retorna da função
