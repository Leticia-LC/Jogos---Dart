import 'dart:io';
import 'dart:math';

const int larguraTabuleiro = 14;
const int alturaTabuleiro = 6;

void main() {
  print('Escolha o nível de dificuldade (fácil, médio, difícil):');
  String? dificuldade = stdin.readLineSync();

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
      print('Dificuldade inválida!');
      return;
  }

  List<List<String>> tabuleiro = List.generate(alturaTabuleiro, (_) => List.generate(larguraTabuleiro, (_) => '~'));
  List<List<String>> tabuleiroOculto = List.generate(alturaTabuleiro, (_) => List.generate(larguraTabuleiro, (_) => '~'));

  for (var navio in navios) {
    for (int i = 0; i < navio['quantidade']; i++) {
      bool posicionado = false;
      while (!posicionado) {
        int linha = Random().nextInt(alturaTabuleiro);
        int coluna = Random().nextInt(larguraTabuleiro);
        bool horizontal = Random().nextBool();
        posicionado = posicionarNavio(tabuleiro, linha, coluna, navio['tamanho'], navio['tipo'], horizontal);
      }
    }
  }

  int jogadasRestantes = limiteJogadas;
  while (jogadasRestantes > 0) {
    imprimirTabuleiro(tabuleiroOculto, 'Jogador');
    print('Jogadas restantes: $jogadasRestantes');
    turnoJogador(tabuleiro, tabuleiroOculto);
    jogadasRestantes--;

    if (verificarVitoria(tabuleiro)) {
      print('Parabéns! Você venceu!');
      return;
    }
  }

  print('Você perdeu! O limite de jogadas foi alcançado.');
}

bool posicionarNavio(List<List<String>> tabuleiro, int linha, int coluna, int tamanho, String tipo, bool horizontal) {
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

void imprimirTabuleiro(List<List<String>> tabuleiro, String jogador) {
  print('Tabuleiro do $jogador:');
  for (var linha in tabuleiro) {
    print(linha.join(' '));
  }
  print('');
}

void turnoJogador(List<List<String>> tabuleiro, List<List<String>> tabuleiroOculto) {
  int linha, coluna;
  while (true) {
    print('Seu turno! Informe a linha e coluna (0-5 para linha e 0-13 para coluna) para atacar (separados por espaço):');
    List<String> entrada = stdin.readLineSync()!.split(' ');
    if (entrada.length != 2) {
      print('Entrada inválida. Tente novamente.');
      continue;
    }
    linha = int.tryParse(entrada[0]) ?? -1;
    coluna = int.tryParse(entrada[1]) ?? -1;
    if (linha < 0 || linha >= alturaTabuleiro || coluna < 0 || coluna >= larguraTabuleiro) {
      print('Coordenadas fora do alcance. Tente novamente.');
      continue;
    }
    if (tabuleiroOculto[linha][coluna] != '~') {
      print('Você já atacou essas coordenadas. Tente novamente.');
      continue;
    }
    break;
  }
  if (tabuleiro[linha][coluna] != '~') {
    print('Acertou!');
    tabuleiro[linha][coluna] = 'X';
    tabuleiroOculto[linha][coluna] = 'X';
  } else {
    print('Errou!');
    tabuleiroOculto[linha][coluna] = 'O';
  }
}

bool verificarVitoria(List<List<String>> tabuleiro) {
  for (var linha in tabuleiro) {
    for (var celula in linha) {
      if (celula == 'P' || celula == 'M' || celula == 'G') {
        return false;
      }
    }
  }
  return true;
}
