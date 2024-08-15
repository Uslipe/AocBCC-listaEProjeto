.data
   str1: .asciiz "Stanley"                  #Exemplo string1
   str2: .asciiz "Stanford"                 #Exemplo string2
   intN: .word 5                            #Numero de caracteres a comparar
   result: .word 0                          #Armazena o resultado
   msgErro: .asciiz "Número n negativo"     #Mensagem de erro caso n seja < 0

.text
   main:
   
      la $a0, str1              #Armazena a string nos registradores
      la $a1, str2
      lw $a2, intN              #Armazena o número n nos registradores
      
      jal strncmpFuncao         #Pular para a função
      sw $v0, result            #Salvar o resultado pós fim da função
      
      li $v0, 1                
      lw $a0, result            #Imprimir resultado
      syscall                   
      
      li $v0, 10                #Encerrar programa
      syscall                   
      
   #Função que direciona os dados e pula para outras funções

   strncmpFuncao:

      addi $sp, $sp, -16          #Reserva espaço no stack
      sw $ra, 12($sp)             #Salva o endereço de retorno
      sw $a0, 8($sp)              #Salva a string1 no stack
      sw $a1, 4($sp)              #Salva a string2 no stack
      sw $a2, 0($sp)              #Salva o numero n no stack
      
      move $t0, $a0               #Guarda a str1 em t0
      move $t1, $a1               #Guarda a str2 em t1
      move $t2, $a2               #Guarda o intN em t2
      
      li $t3, 0
      blt $t2, $zero, erroNumero          #If caso o número n seja menor que 0
      beq $t2, $zero, stringsIguais       #If caso o número n seja igual a 0
      j compararStrings                   #Pular para função
      
      #Função que compara n caracteres de ambas strings

      compararStrings:
      	 
      	 bge $t3, $t2, stringsIguais      #Laço de repetição, sai quando i = n
         lb $t4, 0($t0)
         lb $t5, 0($t1)                   #Carrega o byte da posição n 
         blt $t4, $t5, string1Menor       #Redireciona para tal função caso byte1 < byte2
         bgt $t4, $t5, string1Maior       #Redireciona para tal função caso byte1 > byte2
         addi $t3, $t3, 1
         addi $t0, $t0, 1                 #Incrementa os registradores e o índice
         addi $t1, $t1, 1
         j compararStrings                #Repete o loop
         
      #Função caso o número n seja menor que 0
         
      erroNumero:
         
         li $v0, 4
         la $a0, msgErro                  #Imprimir mensagem de erro
         syscall                          
         li $v0, 10                       #Encerrar programa
         syscall                          
         
      #Função caso as strings sejam iguais

      stringsIguais:
      
         li $v0, 0                        #Armazena 0 (será o resultado)
         jr $ra                           #Retorna ao 'jal' no main
      
      #Função caso a string1 seja menor

      string1Menor:
         
         li $v0, -1                       #Armazena -1 (será o resultado)
         jr $ra                           #Retorna ao 'jal' no main

      #Função caso a string1 seja maior
         
      string1Maior:
      
         li $v0, 1                        #Armazena 1 (será o resultado)
         jr $ra                           #Retorna ao 'jal' no main
