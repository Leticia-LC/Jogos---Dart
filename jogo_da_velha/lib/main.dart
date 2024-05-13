import 'package:flutter/material.dart';

import 'dart:io';

String syncPrompt(String prompt) {
  stdout.write(prompt);
  return stdin.readLineSync()!;
}

void main() {
  final tabuleiro = Tabuleiro();

  var jogadas = 0;
  while (jogadas < 9) {
    tabuleiro.mostrarTabuleiro();
    var jogadorEmAndamento = jogadas.isEven ? CasaTabuleiro.X : CasaTabuleiro.O;

    print('Vez do jogador ${jogadorEmAndamento.print}');
    final jogada = syncPrompt('Digite a jogada: ');


    if (jogada.length != 2) {
      print('Digite uma jogada no formato válido! (A1, B2, C3...)');
      continue;
    }

    final mensagem = tabuleiro.fazerJogada(
      linha: jogada[0],
      coluna: jogada[1],
      jogador: jogadorEmAndamento,
    );

    if (mensagem != null) {
      print(mensagem);
      continue;
    }

    final sucesso = tabuleiro.checarVencedor();

    if (sucesso) {
      tabuleiro.mostrarTabuleiro();
      print('Você venceu!');
      return;
    }

    jogadas++;
  }
}

enum CasaTabuleiro {
  vazio,
  X,
  O;

  String get print => switch (this) {
    vazio => ' ',
    X => 'X',
    O => 'O',
  };
}

class Tabuleiro {
  final matriz = [
    [CasaTabuleiro.vazio, CasaTabuleiro.vazio, CasaTabuleiro.vazio],
    [CasaTabuleiro.vazio, CasaTabuleiro.vazio, CasaTabuleiro.vazio],
    [CasaTabuleiro.vazio, CasaTabuleiro.vazio, CasaTabuleiro.vazio],
  ];

  bool checarVencedor() {
    for (var i = 0; i < matriz.length; i++) {
      if (matriz[i][0] == matriz[i][1] &&
          matriz[i][1] == matriz[i][2] &&
          matriz[i][1] != CasaTabuleiro.vazio) {
        return true;
      }
    }

    for (var j = 0; j < 3; j++) {
      if (matriz[0][j] == matriz[1][j] &&
          matriz[1][j] == matriz[2][j] &&
          matriz[1][j] != CasaTabuleiro.vazio) {
        return true;
      }
    }

    if (matriz[0][0] == matriz[1][1] &&
        matriz[1][1] == matriz[2][2] &&
        matriz[1][1] != CasaTabuleiro.vazio) {
      return true;
    }

    if (matriz[0][2] == matriz[1][1] &&
        matriz[1][1] == matriz[2][0] &&
        matriz[1][1] != CasaTabuleiro.vazio) {
      return true;
    }

    return false;
  }

  String? fazerJogada(
      {required String linha,
        required String coluna,
        required CasaTabuleiro jogador}) {
    var colunaIndice = int.tryParse(coluna);
    var linhaIndice = 0;

    switch (linha.toUpperCase()) {
      case 'A':
        linhaIndice = 0;
        break;
      case 'B':
        linhaIndice = 1;
        break;
      case 'C':
        linhaIndice = 2;
        break;
      default:
        return 'Informe uma linha válida!';
    }

    if (colunaIndice == null) {
      return 'Informe uma coluna válida!';
    }

    if (matriz[linhaIndice][colunaIndice - 1] == CasaTabuleiro.vazio) {
      matriz[linhaIndice][colunaIndice - 1] = jogador;
    } else {
      return 'Essa opção ja foi escolhida!';
    }
  }

  void mostrarTabuleiro() {
    var tabuleiro = '     1   2   3  ';
    tabuleiro += '\n   _____________';

    for (var i = 0; i < matriz.length; i++) {
      var itens = '';

      switch (i) {
        case 0:
          itens = '\nA  |';
          break;
        case 1:
          itens = '\nB  |';
          break;
        case 2:
          itens = '\nC  |';
          break;
      }

      for (var j = 0; j < matriz[j].length; j++) {
        itens += ' ${matriz[i][j].print} |';
      }
      tabuleiro += itens;
      tabuleiro += '\n   |___|___|___|';
    }

    print(tabuleiro);
  }
}
