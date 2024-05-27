programa
{
	inclua biblioteca Arquivos --> a
	inclua biblioteca Texto --> t
	inclua biblioteca Tipos --> conv
	
	funcao inicio()
	{
		//Caminho pra fonte de dados i.e. pro arquivo que contém as palavras e dicas:
		cadeia fonte="jogo.txt"
		//Sai do programa caso a fonte de dados não seja encontrada:
		se(nao a.arquivo_existe(fonte))
		{
			escreva("\n\"", fonte, "\" não é um caminho de arquivo válido!\n")
			retorne
		}
		senao
		// Como o jogo só pode ser executado se a fonte de dados já tiver sido inicializada,
		// todo o código do jogo tem de ser chamado dentro deste "senão".
		{
			escreva(contarLetraInicial("p", fonte))
		}
			
	}

// Abre um arquivo no modo somente-leitura e então conta quantas linhas dele
// iniciam com a letra informada, independentemente de essa letra estar em
// caixa alta ou em caixa baixa (i.e. a análise é case-insensitive).
	funcao inteiro contarLetraInicial(cadeia letraInicial, cadeia caminhoPraFonte)
	{
		se(nao a.arquivo_existe(caminhoPraFonte))
		{
			retorne 0
		}
		senao
		{
			inteiro fonte = a.abrir_arquivo(caminhoPraFonte, a.MODO_LEITURA)
			cadeia linha
			inteiro qtdPalavras=0
			enquanto(nao a.fim_arquivo(fonte))
			{
				linha=a.ler_linha(fonte)
				se(linha!="")
				{
					se(t.caixa_baixa(conv.caracter_para_cadeia(t.obter_caracter(linha, 0)))==t.caixa_baixa(letraInicial))
					{
						++qtdPalavras
					}
				}
			}
			a.fechar_arquivo(fonte)
			retorne qtdPalavras
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 1446; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */
