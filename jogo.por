programa // PARA JOGAR, CLIQUE NO BOTÃO "PLAY" DO PORTUGOL OU PRESSIONE SHIFT F6.
{

	inclua biblioteca Arquivos-->a
	inclua biblioteca Calendario-->c
	inclua biblioteca Matematica-->m
	inclua biblioteca Sons-->s
	//inclua biblioteca Teclado-->k [não funcionou na interface somente-texto do Portugol para Linux]
	inclua biblioteca Texto-->t
	inclua biblioteca Tipos-->conv
	inclua biblioteca Util-->use

	
	// CONSTANTES GLOBAIS
	// Duração máxima de uma partida, em segundos:
	const inteiro DURACAO_MAX_JOGO = 120

	// Quantidade máxima de erros (i.e. chutes errados + pedidos de dica) por partida:
	const inteiro MAX_ERROS = 6

	// Quantidade máxima de chutes (certos + errados, inclusive dicas pedidas) por partida:
	const inteiro MAX_CHUTES = 30

	// Duração da contagem regressiva na tela de apresentação dos alunos, em segundos:
	const inteiro DURACAO_COUNTDOWN_ALUNOS = 30


	// VARIÁVEIS GLOBAIS
	// Define o momento em que a partida em andamento deverá ser encerrada por ter excedido o tempo limite:
	inteiro timeout

	// Definte se o timeout ocorreu:
	logico tempoAcabou = falso
	
	// Caminho pra fonte de dados i.e. pro arquivo que contém as palavras
	// e respectivas dicas a serem postas numa matriz:
	cadeia fonte = "jogo.txt"
	
	// Quantidade total de palavras encontradas no arquivo fonte de dados:
	inteiro qtdPal = contarLetraInicial("p", fonte)
	
	// Nº sorteado que corresponde à linha da palavra na matriz:
	inteiro numPalSort = use.sorteia(0, qtdPal-1)

	// Armazena o nº da dica da palavra que foi sorteada:
	inteiro numDica = 1
	
	// Palavra sorteada, obtida na linha "numPalSort" e coluna 0 da matriz
	// que foi gerada a partir do arquivo fonte de dados:
	cadeia palSort = obter(numPalSort, 0, fonte)
	
	// Nº de caracteres da palavra sorteada:
	inteiro tamanhoPalSort = t.numero_caracteres(palSort)
	
	// Nº de caracteres da palavra sorteada após os caracteres repetidos terem sido eliminados:
	inteiro tamanhoPalSortSemRepeticoes = tamanhoSemRepeticoes(palSort, tamanhoPalSort)
	
	// Máscara usada para esconder do jogador os caracteres da palavra sorteada:
	cadeia mascara = criarMascara(palSort, tamanhoPalSort)
	
	// Armazena cada chute dado (caractere digitado) pelo jogador:
	cadeia chute = ""
	
	// Estoca o histórico de chutes do (i.e. caracteres digitados pelo) jogador:
	cadeia letrasChutadas[MAX_CHUTES]
	
	// Quantidade de chutes dados pelo jogador durante a partida:
	inteiro qtdChutesDados = -1
	
	// Quantidade de chutes do jogador que correspondem a algum caractere da palavra sorteada:
	inteiro acertos = 0
	
	// Quantidade de chutes do jogador que não correspondem a nenhum caractere da palavra sorteada:
	inteiro erros = 0

	// Variáveis que armazenam os endereços de memória dos sons utilizados no jogo:
	inteiro somAcertou, somAjuda, somErrou, somPerdeu, somQuit, somStart, somSuspense, somVenceu, somVouMorrer

	// Inicia o jogo em modo de loop.
	logico sair=falso

	// Registra se o áudio de aviso de última chance já foi executado.
	logico jaTocouAviso = falso

	funcao inicio()
	{
		limpa()
		alunos()
		// Sai do programa caso o arquivo fonte de dados não seja encontrado:
		se(nao a.arquivo_existe(fonte))
		{
			escreva("\n\"", fonte, "\" não é um caminho de arquivo válido!\n")
			retorne
		}
		senao
		{
/* Testes para mostrar os valores de qtdPal, numPalSort, palSort e tamanhoPalSortSemRepeticoes: 
			escreva("\nQuantidade de palavras encontradas no arquivo fonte de dados: ",qtdPal,"\n")
			escreva("Nº de palavra sorteado: ",numPalSort,"\n")
			escreva("Palavra sorteada: ",palSort,"\n")
			escreva("Tamanho da palavra sorteada sem repetições: ",tamanhoPalSortSemRepeticoes,"\n") */
			carregarSons()
			mascararLetrasChutadas()
			timeout = use.tempo_decorrido()+DURACAO_MAX_JOGO*1000
			enquanto(sair==falso)
			{
				
				enquanto (erros < MAX_ERROS e acertos < tamanhoPalSortSemRepeticoes e letrasChutadas[MAX_CHUTES-1] == "")
				{
					qtdChutesDados++
					mostrarForca(erros)
					escreva("Digite uma letra ou o caractere espaço (envie DICA para receber uma dica): ")
					leia(chute)
					se(use.tempo_decorrido() >= timeout)
					{
						tempoAcabou = verdadeiro
						pare
					}
					processarChuteOuPedidoDeDica()
				}
				mostrarForca(erros)
				gameover()
				reiniciarJogo()
			}
		}
	}


/**************************************************
*			FUNÇÕES ACESSÓRIAS				*
**************************************************/


//Apresenta os alunos que desenvolveram o jogo.
	funcao alunos()
	{
		cadeia avisoDaDuracaoMaxima
		inteiro minutos
		inteiro segundos
		se(DURACAO_MAX_JOGO<=60)
		{
			avisoDaDuracaoMaxima = DURACAO_MAX_JOGO+" SEGUNDOS"
		}
		senao
		{
			minutos = DURACAO_MAX_JOGO / 60
			segundos = DURACAO_MAX_JOGO % 60
			avisoDaDuracaoMaxima = minutos + " MINUTO"
			se(minutos > 1)
			{
				avisoDaDuracaoMaxima += "S"
			}
			se(segundos > 0)
			{
				avisoDaDuracaoMaxima += " E "+segundos+" SEGUNDO"
			}
			se(segundos > 1)
			{
				avisoDaDuracaoMaxima += "S"
			}
		}
		escreva("JOGO DA FORCA, versão 1.0 --> JOGO[x] DICAS[x] CONTROLE DE TEMPO[x]\n\nAlunos: FABIO SAMPAIO (100%, RA 1680482411001), JUAN PABLLO (100%, RA 1680482411005) e YURI SUCUPIRA (100%, RA 1680482411003)\n\n")
		contadorRegressivo1s("DURAÇÃO MÁXIMA DA PARTIDA: "+avisoDaDuracaoMaxima+". VOCÊ PODE DAR NO MÁXIMO "+MAX_CHUTES+" CHUTES E ERRAR NO MÁXIMO "+MAX_ERROS+" CHUTES.\nPARA PEDIR UMA DICA AO JOGO, ENVIE A PALAVRA 'DICA' NO LUGAR DO CHUTE, MAS CADA PEDIDO DE DICA CONTA COMO UM CHUTE ERRADO!\n\nO jogo iniciará daqui a ", DURACAO_COUNTDOWN_ALUNOS)
		limpa()
	}


// Avisa caso a letra já tenha sido chutada.
	funcao avisaCasoLetraJaChutada()
	{
		se(letraJaChutada(chute, qtdChutesDados))
		{
			escreva("Você já chutou essa letra!\n")
			erros--
			qtdChutesDados--
			use.aguarde(1000)
		}
		senao
		{
			letrasChutadas[qtdChutesDados] = chute
			escreva("\n")
		}
	}


// Converte um caractere de caixa baixa para caixa alta.
	funcao caracter caixaAltaCaractere(caracter char)
	{
		char = conv.cadeia_para_caracter(t.caixa_alta(conv.caracter_para_cadeia(char)))
		retorne char
	}


// Carrega arquivos mp3 dentro de endereços da memória principal.
	funcao carregarSons()
	{
		cadeia diretorioSons = "sons/"
		somAjuda = s.carregar_som(diretorioSons + "ajuda.mp3")
		somAcertou = s.carregar_som(diretorioSons + "acertou.mp3")
		somErrou = s.carregar_som(diretorioSons + "errou.mp3")
		somPerdeu = s.carregar_som(diretorioSons + "perdeu.mp3")
		somStart = s.carregar_som(diretorioSons + "start.mp3")
		somSuspense = s.carregar_som(diretorioSons + "suspense.mp3")
		somVenceu = s.carregar_som(diretorioSons + "venceu.mp3")
		somVouMorrer = s.carregar_som(diretorioSons + "voumorrer.mp3")
		tocarSom(somStart, 2, falso)
	}


// Escreve uma contagem regressiva de "duração" segundos usando pausas de 1 segundo.
	funcao contadorRegressivo1s(cadeia message, inteiro duration)
	{
		para(inteiro timer = duration; timer > 0; timer--)
		{
			se(timer == duration)
			{
				escreva(message, timer, "s")
			}
			senao se(timer > 1)
			{
				se((timer+1) % 20 == 0)
				{
					escreva(",\n", timer, "s")
				}
				senao
				{
					escreva(", ", timer, "s")
				}
			}
			senao
			{
				escreva(", ", timer, "s.")
			}
			use.aguarde(1000)
		}
	}


// Para cada chute dado (letra digitada), contabiliza-o como erro ou acerto e,
// caso se trate de acerto, exibe esse chute/letra em todas as posições dele
// na máscara da palavra que foi sorteada.
	funcao contarErrosAcertosEDesmascararAcertos()
	{
		inteiro qtdDesmascaradaChute = 0
		para (inteiro cont = 0; cont < tamanhoPalSort; cont++)
		{
			se(t.obter_caracter(palSort, cont) == conv.cadeia_para_caracter(chute) e t.obter_caracter(mascara, cont) != conv.cadeia_para_caracter(chute))
			{
				mascara = substituir(chute, cont, mascara)
				qtdDesmascaradaChute++
			}
		}
		se(qtdDesmascaradaChute > 0)
		{
			acertos++
			tocarSom(somAcertou, 1, falso)
		}
		senao
		{
			erros++
			tocarSom(somErrou, 1, falso)
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
			inteiro arquivoFonte = a.abrir_arquivo(caminhoPraFonte, a.MODO_LEITURA)
			cadeia linha
			inteiro qtdPalavras = 0
			enquanto(nao a.fim_arquivo(arquivoFonte))
			{
				linha = a.ler_linha(arquivoFonte)
				se(linha != "")
				{
					se(t.caixa_baixa(conv.caracter_para_cadeia(t.obter_caracter(linha, 0))) == t.caixa_baixa(letraInicial))
					{
						++qtdPalavras
					}
				}
			}
			a.fechar_arquivo(arquivoFonte)
			retorne qtdPalavras
		}
	}


// Cria a máscara da palavra sorteada.
	funcao cadeia criarMascara(cadeia palavra, inteiro tamanhoDaPalavra)
	{
		cadeia mask = ""
		para (inteiro posicao = 0; posicao < tamanhoDaPalavra; posicao++)
		{
			mask += "_"
		}
		retorne mask
	}


// Finaliza a partida informando o resultado.
	funcao logico gameover()
	{
		se (acertos == tamanhoPalSortSemRepeticoes)
		{
			escreva("Parabéns, você acertou! A palavra realmente é ", palSort, ".\n")
			tocarSom(somVenceu, 4, falso)
		}
		senao
		{
			use.aguarde(500)
			tocarSom(somVouMorrer, 1, falso)
			escreva("Que pena, ")
			se(tempoAcabou == verdadeiro)
			{
				escreva("o tempo acabou")
			}
			se(erros==MAX_ERROS)
			{
				escreva("você gastou suas 6 chances (dicas + chutes errados)")
			}
			se(letrasChutadas[MAX_CHUTES-1] != "")
			{
				escreva("não há mais chutes disponíveis")
			}
			escreva(", por isto você foi enforcado! A palavra era ", palSort, ".\n")
			tocarSom(somPerdeu, 2, falso)
		}
		contadorRegressivo1s("", 5)
		limpa()
		cadeia resposta=""
		enquanto(t.caixa_alta(resposta) != "S" e t.caixa_alta(resposta) != "J")
		{
			escreva("Envie 'S' para sair do jogo ou 'J' para jogar novamente.\n")
			leia(resposta)
		}
		se(t.caixa_alta(resposta)=="S")
		{
			sair=verdadeiro
			limpa()
			escreva("ATÉ A PRÓXIMA!")
			use.aguarde(3000)
		}
		senao
		{
			sair=falso
			tocarSom(somStart, 2, falso)
		}
		retorne sair
	}


// Avalia se o chute já foi chutado antes.
	funcao logico letraJaChutada(cadeia letraChutada, inteiro qtdChutes)
	{
		para (inteiro cont = 0; cont < qtdChutes; cont++)
		{
			se (letrasChutadas[cont] == letraChutada)
			{
				retorne verdadeiro
			}
		}
		retorne falso
	}


// Baseia-se no tamanho da palavra informada para escrever na tela uma máscara dela contendo espaços.
	funcao cadeia mascararComEspacos(inteiro tamanho)
	{
		cadeia mask = ""
		para (inteiro posicao = 0; posicao < tamanho; posicao++)
		{
			mask += conv.caracter_para_cadeia(t.obter_caracter(mascara, posicao)) + " "
		}
		mask += "\n"
		retorne mask
	}


// Mascara o vetor letrasChutadas com o caractere de interrogação.
	funcao mascararLetrasChutadas()
	{
		para(inteiro cont = 0; cont < MAX_CHUTES; cont++)
		{
			letrasChutadas[cont] = ""
		}
	}


// Mostra sequencialmente cada dica (1 a 10) da palavra sorteada. Após a 10ª dica, volta a mostrar a 1ª dica.
	funcao cadeia mostrarDica(inteiro numeroDaPalavraSorteada, inteiro coluna)
	{
		se(obter(numeroDaPalavraSorteada, coluna, fonte) == "")
		{
			retorne "não cadastrada"
		}
		senao
		{
			retorne obter(numeroDaPalavraSorteada, coluna % 10, fonte)
		}
	}


//Desenha a forca em função de cada caso/etapa do jogo.
	funcao mostrarForca(inteiro casos)
	{
		limpa()
		caracter cabeca=' '
		cadeia tronco="   "
		cadeia pernas="   "
		escolha (casos)
		{
			caso 0:
				pare
			caso 1:
				cabeca='O'
				pare
			caso 2:
				cabeca='O'
				tronco=" | "
				pare
			caso 3:
				cabeca='O'
				tronco="/| "
				pare
			caso 4:
				cabeca='O'
				tronco="/|\\"
				pare
			caso 5:
				cabeca='O'
				tronco="/|\\"
				pernas="/  "
				pare
			caso contrario:
				cabeca='O'
				tronco="/|\\"
				pernas="/ \\"
				pare
		}
		//escreva("  .:::.   Dica: ",mostrarDica(numPalSort, acertos+erros+1),"\n")
		escreva("  .:::.   Dica: ",mostrarDica(numPalSort, numDica),"\n")
		escreva("  |   |   ")
		se(erros == 5)
		{
			escreva("   ***** SE ERRAR DE NOVO OU PEDIR DICA É FIM DE JOGO! *****")
			se(jaTocouAviso == falso)
			{
				tocarSom(somSuspense, 7, falso)
				jaTocouAviso = verdadeiro
			}
		}
		escreva("\n  ",cabeca,"   |   ",mascararComEspacos(tamanhoPalSort))
		escreva(" ",tronco,"  |\n")
		escreva(" ",pernas,"  |   ")mostrarLetrasChutadas()
		escreva("      |   Dicas pedidas: ", numDica-1, ". Chutes errados: ", erros-(numDica-1),".\n")
		escreva("=========\n")
	}


// Mostra as letras que já foram chutadas.
	funcao mostrarLetrasChutadas()
	{
		escreva("Letras chutadas: ")
		para(inteiro cont = 0; cont <= qtdChutesDados; cont++)
		{
			se(letrasChutadas[cont] == " ")
			{
				letrasChutadas[cont] = "_"
				escreva(letrasChutadas[cont], " ")
			}
			senao
			{
				escreva(letrasChutadas[cont], " ")
			}
		}
		escreva("\n")
	}


// Abre o arquivo fonte de dados no modo somente-leitura, ENTÃO
// pega as palavras desse arquivo e as coloca em CAIXA ALTA na coluna 0 de uma matriz, ENTÃO
// pega as dicas de cada palavra desse arquivo e as coloca em CAIXA ALTA nas colunas 1 a 10
// da linha respectiva de cada palavra, nessa matriz, ENTÃO
// verifica qual foi a linha e a coluna dessa matriz que foram informadas na entrada da função, ENTÃO
// retorna essa posição (linhaDesejada, colunaDesejada) dessa matriz.
	funcao cadeia obter(inteiro linhaDesejada, inteiro colunaDesejada, cadeia caminhoPraFonte)
	{
		se(linhaDesejada < 0 ou linhaDesejada > 99)
		{
			retorne "\nobter(): O nº da linha tem de ser um nº inteiro entre 0 e 99 (inclusive)!"
		}
		senao
		{
			se(colunaDesejada < 0 ou colunaDesejada > 10)
			{
				retorne "\nobter(): O nº da coluna tem de ser um nº inteiro entre 0 e 10 (inclusive)!"
			}
			senao
			{
				se(nao a.arquivo_existe(caminhoPraFonte))
				{
					retorne "\nobter(): Caminho inválido para o arquivo fonte de dados!"
				}
				senao //Se os 3 parâmetros de entrada estão corretos, então:
				{
					inteiro arquivoFonte = a.abrir_arquivo(caminhoPraFonte, a.MODO_LEITURA)
					cadeia linhaDaFonte, matriz[100][11]
					inteiro linhaDaMatriz = 0, colunaDaMatriz = 0
					enquanto(nao a.fim_arquivo(arquivoFonte))
					{
						linhaDaFonte = a.ler_linha(arquivoFonte)
						se(linhaDaFonte != "")
						{
							enquanto(t.caixa_alta(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0))) == "P")
							{
								colunaDaMatriz = 0
								matriz[linhaDaMatriz][colunaDaMatriz] = t.caixa_alta(t.extrair_subtexto(linhaDaFonte, 2, t.numero_caracteres(linhaDaFonte))) //salva a palavra na coluna 0 da matriz
								linhaDaFonte = a.ler_linha(arquivoFonte) //vai pra linha seguinte do arquivo fonte de dados, para coletar as dicas da palavra
								enquanto(t.caixa_alta(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0))) == "D")
								{
									++colunaDaMatriz
									matriz[linhaDaMatriz][colunaDaMatriz] = t.caixa_alta(t.extrair_subtexto(linhaDaFonte, 2, t.numero_caracteres(linhaDaFonte)))
									linhaDaFonte = a.ler_linha(arquivoFonte) //vai pra linha seguinte do arquivo fonte de dados, para coletar a próxima dica da palavra
									se(nao a.fim_arquivo(arquivoFonte) e t.caixa_alta(conv.caracter_para_cadeia(t.obter_caracter(linhaDaFonte, 0))) != "D")
									{
										enquanto(colunaDaMatriz < 10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz] = ""
										}
									}
									se(a.fim_arquivo(arquivoFonte))
									{
										enquanto(colunaDaMatriz < 10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz] = ""
										}
										pare
									}
								}
								se(a.fim_arquivo(arquivoFonte))
								{
									enquanto(linhaDaMatriz < 99)
									{
										++linhaDaMatriz
										colunaDaMatriz = -1
										enquanto(colunaDaMatriz < 10)
										{
											++colunaDaMatriz
											matriz[linhaDaMatriz][colunaDaMatriz] = ""
										}
									}
									pare
								}
								++linhaDaMatriz
							}
						}
					}
					a.fechar_arquivo(arquivoFonte)
					retorne matriz[linhaDesejada][colunaDesejada]
				}//<-- fecha o 3º "senao" da função obter()
			}//<-- fecha o 2º "senao" da função obter()
		}//<-- fecha o 1º "senao" da função obter()
	}


//Processa o chute ou dica pedida.
	funcao processarChuteOuPedidoDeDica()
	{
		se(t.caixa_alta(chute)=="DICA")
		{
			erros++
			numDica++
			qtdChutesDados--
			tocarSom(somAjuda, 2, falso)
		}
		senao
		{
			chute = t.caixa_alta(conv.caracter_para_cadeia(t.obter_caracter(chute, 0)))
			avisaCasoLetraJaChutada()
			contarErrosAcertosEDesmascararAcertos()
		}
	}


// Reinicia as variáveis globais para poder reiniciar o jogo.
	funcao reiniciarJogo()
	{
		// Redefine o momento em que a partida em andamento deverá ser encerrada por ter excedido o tempo limite:
		timeout = use.tempo_decorrido()+DURACAO_MAX_JOGO*1000

		// Redefinte se o timeout ocorreu:
		tempoAcabou = falso

		// Sorteia um novo número de palavra:
		numPalSort = use.sorteia(0, qtdPal-1)

		// Reinicia a numeração da dica da palavra que foi sorteada:
		numDica = 1
		
		// Obtém a nova palavra que foi sorteada:
		palSort = obter(numPalSort, 0, fonte)
		
		// Nº de caracteres da nova palavra sorteada:
		tamanhoPalSort = t.numero_caracteres(palSort)

		// Nº de caracteres da nova palavra sorteada após os caracteres repetidos terem sido eliminados:
		tamanhoPalSortSemRepeticoes = tamanhoSemRepeticoes(palSort, tamanhoPalSort)

		// Máscara da nova palavra sorteada:
		mascara = criarMascara(palSort, tamanhoPalSort)

		// Limpa o chute:
		chute=""

		// Limpa o histórico de chutes do (i.e. caracteres digitados pelo) jogador:
		mascararLetrasChutadas()

		// Reinicializa a quantidade de chutes dados pelo jogador durante a partida:
		qtdChutesDados = -1

		// Reinicializa a quantidade de chutes do jogador que correspondem a algum caractere da nova palavra sorteada:
		acertos = 0

		// Reinicializa a quantidade de chutes do jogador que não correspondem a nenhum caractere da nova palavra sorteada:
		erros = 0

		// Registra que o áudio de aviso de última chance ainda não foi executado.
		jaTocouAviso = falso
	}


// Substitui a letra informada na posição informada da palavra informada.
	funcao cadeia substituir(cadeia letra, inteiro posicao, cadeia palavra)
	{
		letra = conv.caracter_para_cadeia(t.obter_caracter(letra, 0))
		cadeia palavraAlterada = ""
		para(inteiro endereco = 0; endereco < t.numero_caracteres(palavra); endereco++)
		{
			se (endereco != posicao)
			{
				palavraAlterada += conv.caracter_para_cadeia(t.obter_caracter(palavra, endereco))
			}
			senao
			{
				palavraAlterada += letra
			}
		}
		retorne t.caixa_alta(palavraAlterada)
	}


// Recebe uma palavra e o tamanho dela, elimina os caracteres repetidos e então
// retorna a quantidade de caracteres dessa palavra sem caracteres repetidos.
	funcao inteiro tamanhoSemRepeticoes(cadeia palavra, inteiro tamanhoDaPalavra)
	{
		cadeia palSemRept = ""
		inteiro ocorrencias
		inteiro posicao = 0
		
		para(posicao = 0; posicao < tamanhoDaPalavra; posicao++)
		{
			ocorrencias = 0
			para(inteiro cont = posicao; cont < tamanhoDaPalavra; cont++)
			{
				se(t.obter_caracter(palavra, posicao) == t.obter_caracter(palavra, cont))
				{
					ocorrencias++
				}
			}
			se(ocorrencias == 1)
			{
				palSemRept+=conv.caracter_para_cadeia(t.obter_caracter(palavra, posicao))
			}
		}
		retorne t.numero_caracteres(palSemRept)
	}


// Toca o "som" durante "duracao" segundos, com ou sem loop.
	funcao tocarSom(inteiro som, inteiro lapso, logico repetir)
	{
		s.definir_volume(100)
		s.reproduzir_som(som, repetir)
		use.aguarde(1000*lapso)
	}


// Fecha o programa:
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 0; 
 * @DOBRAMENTO-CODIGO = [89, 84, 134, 168, 186, 194, 210, 241, 268, 297, 309, 361, 375, 388, 398, 412, 469, 494, 577, 596, 643, 664, 690, 0];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */
