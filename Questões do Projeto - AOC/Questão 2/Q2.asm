.data
.text
main:
    # Função de loop 
  loop:
	# Ler status do teclado em 0xFFFF0000
     li $t0, 0xFFFF0000         # Carrega o endereço do status do teclado
     lw $t1, 0($t0)             # Lê o status (1 = caractere disponível)

     # Verificar se há um caractere disponível
     beq $t1, $zero, loop       # Se não houver caractere, continua no loop

     # Ler o caractere do teclado em 0xFFFF0004
     li $t0, 0xFFFF0004         # Carrega o endereço de dados do teclado
     lw $t2, 0($t0)             # Lê o caractere

     # Loop para esperar o display estar pronto
     esperar_display:
     # Ler status do display em 0xFFFF0008
     li $t0, 0xFFFF0008    # Carrega o endereço do status do display
     lw $t1, 0($t0)        # Lê o status (1 = display pronto)

     beq $t1, $zero, esperar_display  # Se não estiver pronto, espera

     # Escrever o caractere no display em 0xFFFF000C
     li $t0, 0xFFFF000C         # Carrega o endereço de dados do display
     sw $t2, 0($t0)             # Escreve o caractere no display

     # Voltar ao início do loop
     j loop
