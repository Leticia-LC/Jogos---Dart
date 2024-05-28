import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(BatalhaNavalApp());
}

class BatalhaNavalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batalha Naval',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChooseDifficultyScreen(),
    );
  }
}

const int larguraTabuleiro = 14;
const int alturaTabuleiro = 6;

class GameLogic {
  late List<List<String>> tabuleiro;
  late List<List<String>> tabuleiroOculto;
  late int jogadasRestantes;

  GameLogic(String dificuldade) {
    _inicializarJogo(dificuldade);
  }

  void _inicializarJogo(String dificuldade) {
    int limiteJogadas;
    List<Map<String, dynamic>> navios;

    switch (dificuldade) {
      case 'facil':
        limiteJogadas = 60;
        navios = [
          {'tamanho': 1, 'quantidade': 5, 'tipo': 'P'},
          {'tamanho': 2, 'quantidade': 3, 'tipo': 'M'},
          {'tamanho': 3, 'quantidade': 1, 'tipo': 'G'}
        ];
        break;
      case 'medio':
        limiteJogadas = 40;
        navios = [
          {'tamanho': 1, 'quantidade': 8, 'tipo': 'P'},
          {'tamanho': 2, 'quantidade': 5, 'tipo': 'M'},
          {'tamanho': 3, 'quantidade': 2, 'tipo': 'G'}
        ];
        break;
      case 'dificil':
        limiteJogadas = 30;
        navios = [
          {'tamanho': 1, 'quantidade': 7, 'tipo': 'P'},
          {'tamanho': 2, 'quantidade': 2, 'tipo': 'M'},
          {'tamanho': 3, 'quantidade': 3, 'tipo': 'G'}
        ];
        break;
      default:
        throw Exception('Dificuldade inválida');
    }

    tabuleiro = List.generate(alturaTabuleiro, (_) => List.generate(larguraTabuleiro, (_) => '~'));
    tabuleiroOculto = List.generate(alturaTabuleiro, (_) => List.generate(larguraTabuleiro, (_) => '~'));
    jogadasRestantes = limiteJogadas;

    for (var navio in navios) {
      for (int i = 0; i < navio['quantidade']; i++) {
        bool posicionado = false;
        while (!posicionado) {
          int linha = Random().nextInt(alturaTabuleiro);
          int coluna = Random().nextInt(larguraTabuleiro);
          bool horizontal = Random().nextBool();
          posicionado = _posicionarNavio(tabuleiro, linha, coluna, navio['tamanho'], navio['tipo'], horizontal);
        }
      }
    }
  }

  bool _posicionarNavio(List<List<String>> tabuleiro, int linha, int coluna, int tamanho, String tipo, bool horizontal) {
    if (horizontal) {
      if (coluna + tamanho > larguraTabuleiro) return false;
      for (int i = 0; i < tamanho; i++) {
        if (tabuleiro[linha][coluna + i] != '~') return false;
      }
      for (int i = 0; i < tamanho; i++) {
        tabuleiro[linha][coluna + i] = tipo;
      }
    } else {
      if (linha + tamanho > alturaTabuleiro) return false;
      for (int i = 0; i < tamanho; i++) {
        if (tabuleiro[linha + i][coluna] != '~') return false;
      }
      for (int i = 0; i < tamanho; i++) {
        tabuleiro[linha + i][coluna] = tipo;
      }
    }
    return true;
  }

  bool verificarVitoria() {
    for (var linha in tabuleiro) {
      for (var celula in linha) {
        if (celula == 'P' || celula == 'M' || celula == 'G') {
          return false;
        }
      }
    }
    return true;
  }

  String realizarJogada(int linha, int coluna) {
    if (tabuleiroOculto[linha][coluna] != '~') {
      return 'Você já atacou essas coordenadas.';
    }
    jogadasRestantes--;
    if (tabuleiro[linha][coluna] != '~') {
      tabuleiro[linha][coluna] = 'X';
      tabuleiroOculto[linha][coluna] = 'X';
      return 'Acertou!';
    } else {
      tabuleiroOculto[linha][coluna] = 'O';
      return 'Errou!';
    }
  }
}

class ChooseDifficultyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha a Dificuldade'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(dificuldade: 'facil')),
                  );
                },
                child: Text('Fácil', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(dificuldade: 'medio')),
                  );
                },
                child: Text('Médio', style: TextStyle(fontSize: 20)),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen(dificuldade: 'dificil')),
                  );
                },
                child: Text('Difícil', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String dificuldade;

  GameScreen({required this.dificuldade});

  @override
  _JogoScreenState createState() => _JogoScreenState();
}

class _JogoScreenState extends State<GameScreen> {
  late GameLogic game;

  @override
  void initState() {
    super.initState();
    game = GameLogic(widget.dificuldade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batalha Naval'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: larguraTabuleiro,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: larguraTabuleiro * alturaTabuleiro,
                  itemBuilder: (BuildContext context, int index) {
                    int linha = index ~/ larguraTabuleiro;
                    int coluna = index % larguraTabuleiro;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          String resultado = game.realizarJogada(linha, coluna);
                          if (game.verificarVitoria()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Parabéns!'),
                                  content: Text('Você venceu!'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (game.jogadasRestantes <= 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Fim de Jogo'),
                                  content: Text('Você perdeu! O limite de jogadas foi alcançado.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultado)));
                          }
                        });
                      },
                      child: GridTile(
                        child: Container(
                          color: game.tabuleiroOculto[linha][coluna] == '~'
                              ? Colors.blue
                              : (game.tabuleiroOculto[linha][coluna] == 'X'
                              ? Colors.red
                              : Colors.grey),
                          child: Center(
                            child: Text(
                              game.tabuleiroOculto[linha][coluna],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Jogadas restantes: ${game.jogadasRestantes}'),
            ),
          ],
        ),
      ),
    );
  }
}
