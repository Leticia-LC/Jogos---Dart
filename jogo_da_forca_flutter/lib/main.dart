import 'dart:io';

void main() {
  // Lista de palavras possíveis
  final List<String> palavras = [
    'abacaxi',
    'damasco',
    'uva',
    'morango',
    'cereja',
  ];

  final String palavra = palavras[(palavras.length * (new DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor()];

  String palavraOculta = '_' * palavra.length;
  int tentativasRestantes = 6;
  List<String> letrasTentadas = [];

  List<String> forca = [
    '''
     +---+
     |   |
         |
         |
         |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
         |
         |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
     |   |
         |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
    /|   |
         |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
    /|\\  |
         |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
    /|\\  |
    /    |
         |
    ======''',
    '''
     +---+
     |   |
     O   |
    /|\\  |
    / \\  |
         |
    ======''',
  ];

  while (tentativasRestantes > 0 && palavraOculta.contains('_')) {
    print(forca[6 - tentativasRestantes]);
    print('Palavra: $palavraOculta');
    print('Tentativas restantes: $tentativasRestantes');
    print('Letras tentadas: ${letrasTentadas.join(', ')}');

    stdout.write('Digite uma letra: ');
    String? input = stdin.readLineSync();

    if (input == null || input.length != 1) {
      print('Por favor, digite apenas uma letra');
      continue;
    }

    String letra = input.toLowerCase();

    if (letrasTentadas.contains(letra)) {
      print('Você já tentou essa letra');
      continue;
    }

    letrasTentadas.add(letra);

    if (palavra.contains(letra)) {
      for (int i = 0; i < palavra.length; i++) {
        if (palavra[i] == letra) {
          palavraOculta = palavraOculta.substring(0, i) + letra + palavraOculta.substring(i + 1);
        }
      }
    } else {
      tentativasRestantes--;
    }
  }

  if (!palavraOculta.contains('_')) {
    print('Parabéns! Você acertou a palavra: $palavra');
  } else {
    print(forca[6 - tentativasRestantes]);
    print('Você perdeu! A palavra era: $palavra');
  }
}
