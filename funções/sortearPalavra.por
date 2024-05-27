programa
{
	inclua biblioteca Arquivos --> a
	inclua biblioteca Texto --> t
	inclua biblioteca Tipos --> conv
	inclua biblioteca Util --> use
	funcao inicio()
	{
		//Caminho pra fonte de dados i.e. pro arquivo que contém as palavras e dicas:
		cadeia fonte="palavras.txt"
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
			// "Obtenha (1,1) no arquivo fonte de dados"
			// Em outras palavras: abre o arquivo fonte de dados e então
			// traz a string que está na posição (0,0) da matriz correspondente.
			// Esta função pode ser usada para obter qualquer palavra e qualquer dica
			// dessa palavra que esteja no arquivo fonte de dados.
			
			escreva("\nTotal de palavras encontradas no arquivo fonte de dados: ",contarLetraInicial("p",fonte)) //Informa quantas palavras existem no arquivo fonte de dados i.e. qual o total de linhas da matriz que estão preenchidas com palavras.
			inteiro numPalavraSorteada = use.sorteia(1, contarLetraInicial("p",fonte)) //Sorteia um número inteiro que corresponde à linha da palavra na matriz.
			escreva("\nNúmero ordinal da palavra sorteada: ",numPalavraSorteada) //Informa o número resultante do sorteio.
			escreva("\nPalavra sorteada: ",obtenha(numPalavraSorteada,1,fonte)) //Informa a respectiva palavra que foi sorteada.
		}
	}

// Abre o arquivo fonte de dados no modo somente-leitura, ENTÃO
// pega as palavras desse arquivo e as coloca na coluna 0 de uma matriz, ENTÃO
// pega as dicas de cada palavra desse arquivo e as coloca nas colunas 1 a 10
// da linha respectiva de cada palavra, nessa matriz, ENTÃO
// verifica qual foi a linha e a coluna dessa matriz que foram informadas na entrada da função, ENTÃO
// retorna essa posição (linhaDesejada, colunaDesejada) dessa matriz.
	funcao cadeia obtenha(inteiro linhaDesejada, inteiro colunaDesejada, cadeia caminhoPraFonte)
	{
		se(linhaDesejada<1 ou linhaDesejada>100)
		{
			retorne "\nobtenha(): O nº da linha tem de ser um nº inteiro entre 1 e 100 (inclusive)!"
		}
		senao
		{
			se(colunaDesejada<1 ou colunaDesejada>11)
			{
				retorne "\nobtenha(): O nº da coluna tem de ser um nº inteiro entre 1 e 11 (inclusive)!"
			}
			senao
			{
				se(nao a.arquivo_existe(caminhoPraFonte))
				{
					retorne "\nobtenha(): Caminho inválido para o arquivo fonte de dados!"
				}
				senao //Se os 3 parâmetros de entrada estão corretos, então:
				{
					inteiro fonte = a.abrir_arquivo(caminhoPraFonte, a.MODO_LEITURA)
					cadeia linhaDaFonte, matriz[100][11]
					inteiro linhaDaMatriz=0, colunaDaMatriz=0
					enquanto(nao a.fim_arquivo(fonte))
					{
						linhaDaFonte=a.ler_linha(fonte)
						se(linhaDaFonte!="")
						{
							enquanto(t.caixa_baixa(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0)))=="p")
							{
								colunaDaMatriz=0
								matriz[linhaDaMatriz][colunaDaMatriz]=t.extrair_subtexto(linhaDaFonte, 2, t.numero_caracteres(linhaDaFonte)) //salva a palavra na coluna 0 da matriz
								linhaDaFonte=a.ler_linha(fonte) //vai pra linha seguinte do arquivo fonte de dados, para coletar as dicas da palavra
								enquanto(t.caixa_baixa(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0)))=="d")
								{
									++colunaDaMatriz
									matriz[linhaDaMatriz][colunaDaMatriz]=t.extrair_subtexto(linhaDaFonte, 2, t.numero_caracteres(linhaDaFonte))
									linhaDaFonte=a.ler_linha(fonte) //vai pra linha seguinte do arquivo fonte de dados, para coletar a próxima dica da palavra
									se(nao a.fim_arquivo(fonte) e t.caixa_baixa(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0)))!="d")
									{
										enquanto(colunaDaMatriz<10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz]=""
										}
									}
									se(a.fim_arquivo(fonte))
									{
										enquanto(colunaDaMatriz<10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz]=""
										}
											pare
									}
								}
								se(a.fim_arquivo(fonte))
								{
									enquanto(linhaDaMatriz<99)
									{
										++linhaDaMatriz
										colunaDaMatriz=-1
										enquanto(colunaDaMatriz<10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz]=""
										}
									}
									pare
								}
								++linhaDaMatriz
							}
						}
					}
					a.fechar_arquivo(fonte)
					retorne matriz[linhaDesejada-1][colunaDesejada-1]
				}//<-- fecha o 3º "senao" da função obtenha()
			}//<-- fecha o 2º "senao" da função obtenha()
		}//<-- fecha o 1º "senao" da função obtenha()
	}//<-- fecha a função obtenha()

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
	}//<-- fecha a função contarLetraInicial()

//fecha o programa:
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 1389; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */