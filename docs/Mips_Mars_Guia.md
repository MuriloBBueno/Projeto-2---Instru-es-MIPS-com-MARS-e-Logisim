# MIPS/MARS — Guia Explicado

>Playlist de referência: [YouTube](https://www.youtube.com/watch?v=XtznbGfyd1o&list=PLHCyLhqWSaHBFGanvPRIIvta3eSna2G6Z)

---

## Como o MARS está organizado

Quando você abre o MARS, ele tem 3 áreas principais:

- **Editor principal** — onde você digita o código Assembly
- **Console de mensagens** — onde aparecem erros de sintaxe e a saída do programa
- **Painel de registradores** — mostra em tempo real o valor de cada registrador durante a execução

Para executar um programa: `F3` para montar (compilar) e `F5` para rodar.

---

## O que é um Registrador?

Em C, você declara variáveis na memória RAM. Em Assembly, o processador trabalha principalmente com **registradores** — pequenas áreas de armazenamento que ficam **dentro do próprio processador**. Acesso à RAM é muito mais lento do que acesso a registradores.

O MIPS tem **32 registradores**, cada um com **32 bits** (4 bytes). Todo registrador começa com `$`.

A grande diferença em relação ao C é que **cada registrador tem um propósito definido por convenção**. Você não escolhe o nome e usa o registrador certo para cada situação.

---

## Registradores e seus papéis

### `$zero`
Sempre vale 0. Não tem como mudar ele. É muito útil para atribuir zero a outros registradores ou fazer comparações com zero.

```asm
addi $t0, $zero, 25    # t0 = 0 + 25 → forma comum de carregar um valor
```

### `$t0` – `$t9` (temporários)
São os registradores de uso geral para cálculos intermediários. Pense neles como variáveis locais. Funções podem sobrescrever esses valores sem aviso — se você chamar uma função e precisar do valor depois, salve antes.

### `$s0` – `$s8` (salvos)
Similares aos `$t`, mas com a garantia de que uma função **vai preservar** seus valores. Use quando precisar que o dado sobreviva a uma chamada de função.

### `$v0`, `$v1` (valores de retorno)
Usado para duas coisas:
1. Retornar resultados de funções
2. Indicar ao sistema qual **syscall** executar

### `$a0` – `$a3` (argumentos)
Servem para passar argumentos para funções. Também são usados pelas syscalls para receber parâmetros (como o endereço de uma string a imprimir).

### `$ra` (return address)
Quando você chama uma função com `jal`, o endereço de retorno é salvo automaticamente aqui. Sem ele, o programa não saberia para onde voltar.

### `hi` e `lo`
Registradores especiais usados pela divisão e multiplicação.
- Na divisão: `lo` recebe o **quociente**, `hi` recebe o **resto**
- Você não acessa direto — usa `mflo` e `mfhi` para mover o valor para um registrador normal

---

## Segmentos de memória: `.data` e `.text`

Um programa MIPS é dividido em duas seções obrigatórias:

```asm
.data    # aqui ficam as variáveis (armazenadas na RAM)
.text    # aqui fica o código (as instruções)
```

Isso é diferente do C, onde variáveis e código ficam no mesmo arquivo sem separação explícita. No Assembly, você precisa declarar isso manualmente.

### Tipos de dados no `.data`

```asm
idade:    .word 56        # inteiro de 32 bits (equivale a int no C)
letra:    .byte 'A'       # 1 byte, usado para caracteres
msg:      .asciiz "Olá"   # string terminada em \0 (como char[] no C)
buffer:   .space 25       # reserva 25 bytes vazios (para entrada de texto)
```

> O `z` no `.asciiz` significa que ele adiciona automaticamente o `\0` no final da string, como o C faz. Sem o `z` (só `.ascii`)

---

## Syscalls — como o programa faz I/O

Em C, você usa `printf` e `scanf`. Em MIPS, essas operações são feitas pelo sistema operacional através de **syscalls** (chamadas de sistema).

O mecanismo funciona assim:
1. Você coloca um **código numérico** em `$v0` para dizer qual operação quer
2. Coloca os parâmetros nos registradores corretos (`$a0`, `$a1`...)
3. Executa `syscall` — o sistema faz o trabalho

```asm
# Imprimir um inteiro:
li $v0, 1       # código 1 = "imprimir inteiro"
move $a0, $t0   # o valor a imprimir vai em $a0
syscall         # executa

# Encerrar o programa:
li $v0, 10      # código 10 = "encerrar" (equivale ao return 0 do C)
syscall
```

### Tabela de syscalls mais usadas

| Código | Operação | Parâmetro | Resultado |
|---|---|---|---|
| 1 | Imprimir inteiro | `$a0` = valor | — |
| 4 | Imprimir string | `$a0` = endereço da string | — |
| 5 | Ler inteiro | — | valor em `$v0` |
| 8 | Ler string | `$a0` = buffer, `$a1` = tamanho | string em `$a0` |
| 10 | Encerrar programa | — | — |

---

## Instruções de movimentação de dados

### `li` — Load Immediate
Carrega um valor **constante** diretamente no registrador.
```asm
li $t0, 75     # t0 = 75
```

### `la` — Load Address
Carrega o **endereço de memória** de um label. Usado para apontar para strings e variáveis na RAM.
```asm
la $a0, msg    # a0 = endereço onde 'msg' está guardada na RAM
```

### `lw` — Load Word
Lê um valor inteiro **da RAM** e coloca no registrador.
```asm
lw $t0, idade  # t0 = conteúdo da variável 'idade' na RAM
```

### `sw` — Store Word
Salva o valor de um registrador **na RAM**.
```asm
sw $t0, idade  # RAM[idade] = t0
```

### `move`
Copia o conteúdo de um registrador para outro.
```asm
move $t1, $v0  # t1 = v0
```

> **Resumo mental:** `li` = valor fixo no registrador | `la` = endereço de variável | `lw/sw` = lê/escreve na RAM | `move` = copia entre registradores.

---

## Operações Aritméticas

### Por que existem `add` e `addi`?

O processador MIPS tem instruções de tamanho fixo (32 bits cada). Uma instrução `add` com 3 registradores usa os bits assim: bits pro opcode, bits pro registrador destino, bits pros dois registradores fonte.

Quando você quer somar um **número fixo** (imediato), não tem um segundo registrador — o número em si fica codificado dentro da instrução. Isso exige um formato diferente, por isso existe `addi` (add immediate).

```asm
add  $t0, $t1, $t2     # t0 = t1 + t2  → soma dois registradores
addi $t0, $t1, 15      # t0 = t1 + 15  → soma registrador com constante
```

### Subtração

```asm
sub  $t0, $t1, $t2     # t0 = t1 - t2
subi $t0, $t1, 15      # t0 = t1 - 15
```

> Para subtrair com imediato negativo, você pode usar `addi` com valor negativo: `addi $t0, $t1, -15`

### Multiplicação

```asm
mul $s0, $t0, $t1      # s0 = t0 * t1
```

### Divisão — atenção ao `hi` e `lo`

A divisão em MIPS não coloca o resultado num registrador diretamente. Ela guarda os dois resultados possíveis (quociente e resto) nos registradores especiais `lo` e `hi`. Você precisa mover explicitamente:

```asm
div $t0, $t1    # executa a divisão t0 ÷ t1
mflo $s0        # s0 = quociente  (move from lo)
mfhi $s1        # s1 = resto      (move from hi)
```

Isso equivale a fazer `t0 / t1` e `t0 % t1` em C ao mesmo tempo.

### Shift — multiplicar/dividir por potências de 2

`sll` (shift left logical) desloca os bits para a esquerda. Cada posição deslocada **dobra** o valor.

```asm
sll $s0, $t0, 3    # s0 = t0 * 2³ = t0 * 8
sll $s0, $t0, 1    # s0 = t0 * 2
srl $s0, $t0, 1    # s0 = t0 / 2  (shift right)
```

Usar shift é mais rápido do que usar `mul` quando o multiplicador é uma potência de 2.

---

## Estruturas de Controle

### O modelo mental: labels e desvios

Em C, você tem `if`, `else`, `while`, `for`. Em Assembly, **nada disso existe diretamente**. O que existe são:
- **Labels** — marcações de posição no código (como `goto` no C)
- **Instruções de branch** — desviam para um label se uma condição for verdadeira
- **`j`** — jump incondicional, sempre desvia para o label

O compilador C, quando gera Assembly, transforma seus `if`s e `while`s exatamente nesses blocos.

### Comandos de branch

```asm
beq $t1, $t2, label    # se t1 == t2, vai para label
bne $t1, $t2, label    # se t1 != t2, vai para label
blt $t1, $t2, label    # se t1 < t2,  vai para label
bgt $t1, $t2, label    # se t1 > t2,  vai para label
ble $t1, $t2, label    # se t1 <= t2, vai para label
bge $t1, $t2, label    # se t1 >= t2, vai para label
```

### Simulando um `if` sem `else`

```c
// Em C:
if (x == 0) {
    printf("zero");
}
```

```asm
# Em MIPS — lógica invertida: pula o bloco se a condição NÃO for verdadeira
bne $t0, $zero, fimIf   # se t0 != 0, pula o bloco

    li $v0, 4
    la $a0, msg_zero
    syscall

fimIf:
```

### Simulando `if-else`

```c
// Em C:
if (x > 0) {
    printf("positivo");
} else {
    printf("negativo");
}
```

```asm
# Em MIPS:
bgt $t0, $zero, positivo   # se t0 > 0, vai para 'positivo'

# bloco do else (executa se não desviou):
li $v0, 4
la $a0, msg_neg
syscall
j fimIf                    # pula o bloco do if para não executar os dois

positivo:
li $v0, 4
la $a0, msg_pos
syscall

fimIf:
li $v0, 10
syscall
```

> O `j fimIf` antes do label `positivo:` é essencial. Sem ele, o programa entraria no bloco do `if` mesmo após executar o `else`.

### Simulando `while`

```c
// Em C:
int i = 0;
while (i <= n) {
    printf("%d ", i);
    i++;
}
```

```asm
# Em MIPS — dois labels: um para manter o loop, um para sair
    move $t1, $zero       # i = 0

laco:
    bgt $t1, $t0, caiFora # se i > n, sai do loop

    li $v0, 1
    move $a0, $t1
    syscall               # imprime i

    addi $t1, $t1, 1      # i++
    j laco                # volta para o início do loop

caiFora:
    li $v0, 10
    syscall
```

> A estrutura é sempre: `label_loop:` → corpo → incremento → `j label_loop` → `label_saida:`. A condição de saída fica no início com um branch.

---

## Fluxo completo de um programa

Todo programa MIPS segue essa estrutura base:

```asm
.data
    # declare suas variáveis e strings aqui

.text
    # seu código começa aqui

    # ... lógica do programa ...

    li $v0, 10    # SEMPRE termine com isso
    syscall
```

Esquecer o `li $v0, 10` + `syscall` no final é equivalente a não ter `return 0` — o programa continua executando lixo de memória.

---

## Dicas e armadilhas comuns

**`la` vs `li`:** `la` é para endereços de variáveis na memória. `li` é para valores numéricos diretos. Confundir os dois é um erro muito comum.

**Resultado da leitura:** Depois de `syscall` com `$v0 = 5` (ler inteiro), o valor lido fica em `$v0`. Se você não salvar com `move`, a próxima operação que usar `$v0` vai sobrescrever o valor.

**Divisão sem `mflo`/`mfhi`:** Fazer `div` e esquecer de mover o resultado com `mflo` ou `mfhi` é um erro silencioso — o programa roda sem mensagem de erro mas o valor fica inacessível.

**Loop infinito:** Se esquecer o `j laco` no final do while, o código cai naturalmente para o `caiFora` e executa o loop só uma vez.

**Strings sem `.asciiz`:** Usar `.ascii` em vez de `.asciiz` pode causar lixo no final da impressão porque não há o `\0` terminador.
