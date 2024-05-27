programa
{
    // Inclui a biblioteca texto para usar a função caixaAlta
    inclua biblioteca Texto --> txt

    // Constantes
    inteiro MAX_TENTATIVAS = 6

    // Variáveis globais
    cadeia palavraSecreta = "PROGRAMACAO"
    cadeia mascara = ""
    caracter chutes[26]
    inteiro tentativas = 0
    inteiro chutesDados = 0
    inteiro acertos = 0
    inteiro tamanhoPalavra

    funcao inicio()
    {
        tamanhoPalavra = txt.numero_caracteres(palavraSecreta)
        inicializarPalavraSecreta()

        enquanto (tentativas < MAX_TENTATIVAS e acertos < tamanhoPalavra)
        {
            mostrarForca()
            mostrarPalavraMascarada()
            escreva("Chutes dados: ")
            para (inteiro i = 0; i < chutesDados; i++)
            {
                escreva(chutes[i], " ")
            }
            escreva("\n")

            caracter chute
            escreva("Digite uma letra: ")
            leia(chute)

            se (letraJaChutada(chute))
            {
                escreva("Você já chutou essa letra. Tente outra.\n")
            }

            chutes[chutesDados] = chute
            chutesDados++

            inteiro acerto = 0
            para (inteiro i = 0; i < tamanhoPalavra; i++)
            {
                se (caractereNaPosicao(palavraSecreta, i) == chute)
                {
                    mascara = substituirNaPosicao(mascara, i, chute)
                    acertos++
                    acerto = 1
                }
            }

            se (acerto == 0)
            {
                tentativas++
            }

            escreva("\n")
        }

        mostrarForca()
        se (acertos == tamanhoPalavra)
        {
            escreva("Parabéns! Você acertou a palavra: ", palavraSecreta, "\n")
        }
        senao
        {
            escreva("Que pena! Você foi enforcado. A palavra era: ", palavraSecreta, "\n")
        }
    }

    funcao mostrarForca()
    {
        escolha (tentativas)
        {
            caso 0:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 1:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 2:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva("  |   |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 3:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva(" /|   |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 4:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva(" /|\\  |\n")
                escreva("      |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 5:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva(" /|\\  |\n")
                escreva(" /    |\n")
                escreva("      |\n")
                escreva("=========\n")
            caso 6:
                escreva("  +---+\n")
                escreva("  |   |\n")
                escreva("  O   |\n")
                escreva(" /|\\  |\n")
                escreva(" / \\  |\n")
                escreva("      |\n")
                escreva("=========\n")
        }
    }

    funcao inicializarPalavraSecreta()
    {
        para (inteiro i = 0; i < tamanhoPalavra; i++)
        {
            se (caractereNaPosicao(palavraSecreta, i) == ' ')
            {
                mascara = mascara + ' '
            }
            senao
            {
                mascara = mascara + '_'
            }
        }
    }

    funcao logico letraJaChutada(caracter letra)
    {
        para (inteiro i = 0; i < chutesDados; i++)
        {
            se (chutes[i] == letra)
            {
                retorne verdadeiro
            }
        }
        retorne falso
    }

    funcao mostrarPalavraMascarada()
    {
        para (inteiro i = 0; i < tamanhoPalavra; i++)
        {
            escreva(caractereNaPosicao(mascara, i), " ")
        }
        escreva("\n")
    }

    funcao caracter caractereNaPosicao(cadeia texto, inteiro posicao)
    {
        retorne txt.obter_caracter(texto, posicao)
    }

    funcao cadeia substituirNaPosicao(cadeia texto, inteiro posicao, caracter letra)
    {
        cadeia resultado = ""
        para (inteiro i = 0; i < txt.numero_caracteres(texto); i++)
        {
            se (i == posicao)
            {
                resultado = resultado + letra
            }
            senao
            {
                resultado = resultado + txt.obter_caracter(texto, i)
            }
        }
        retorne resultado
    }
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 5175; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */