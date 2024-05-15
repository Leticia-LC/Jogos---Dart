import 'package:flutter/material.dart';

void main() {
  runApp(JogoDaVelha());
}

class JogoDaVelha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Jogo da Velha'),
        ),
        body: JogoTabuleiro(),
      ),
    );
  }
}

class JogoTabuleiro extends StatefulWidget {
  @override
  _JogoTabuleiroState createState() => _JogoTabuleiroState();
}

class _JogoTabuleiroState extends State<JogoTabuleiro> {
  List<List<String>> tabuleiro = [
    [' ', ' ', ' '],
    [' ', ' ', ' '],
    [' ', ' ', ' '],
  ];

  bool jogadorX = true;
  int jogadas = 0;

  String? checarVencedor() {
    // Checando linhas e colunas
    for (var i = 0; i < 3; i++) {
      if (tabuleiro[i][0] == tabuleiro[i][1] &&
          tabuleiro[i][1] == tabuleiro[i][2] &&
          tabuleiro[i][1] != ' ') {
        return tabuleiro[i][0];
      }
      if (tabuleiro[0][i] == tabuleiro[1][i] &&
          tabuleiro[1][i] == tabuleiro[2][i] &&
          tabuleiro[1][i] != ' ') {
        return tabuleiro[0][i];
      }
    }

    // Checando diagonais
    if (tabuleiro[0][0] == tabuleiro[1][1] &&
        tabuleiro[1][1] == tabuleiro[2][2] &&
        tabuleiro[1][1] != ' ') {
      return tabuleiro[0][0];
    }
    if (tabuleiro[0][2] == tabuleiro[1][1] &&
        tabuleiro[1][1] == tabuleiro[2][0] &&
        tabuleiro[1][1] != ' ') {
      return tabuleiro[0][2];
    }

    // Checando empate
    if (jogadas == 9) {
      return 'Empate';
    }

    return null;
  }

  void fazerJogada(int linha, int coluna) {
    if (tabuleiro[linha][coluna] == ' ') {
      setState(() {
        tabuleiro[linha][coluna] = jogadorX ? 'X' : 'O';
        jogadorX = !jogadorX;
        jogadas++;
      });
      String? resultado = checarVencedor();
      if (resultado != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fim de Jogo'),
              content: Text(resultado == 'Empate'
                  ? 'O jogo terminou em empate!'
                  : 'O jogador $resultado venceu!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    reiniciarJogo();
                  },
                  child: Text('Reiniciar'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void reiniciarJogo() {
    setState(() {
      tabuleiro = [
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' '],
      ];
      jogadorX = true;
      jogadas = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Vez do jogador ${jogadorX ? 'X' : 'O'}',
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 20),
        Column(
          children: tabuleiro
              .asMap()
              .entries
              .map((linha) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: linha.value
                  .asMap()
                  .entries
                  .map((coluna) {
                return GestureDetector(
                  onTap: () => fazerJogada(linha.key, coluna.key),
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      coluna.value,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}
