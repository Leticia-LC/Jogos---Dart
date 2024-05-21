import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(ForcaApp());
}

class ForcaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Forca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Forca'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue[900], // Cor do texto dentro do botão
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Ajuste do padding para aumentar o tamanho do botão
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaJogo()),
            );
          },
          child: Text(
            'Iniciar Jogo',
            style: TextStyle(fontSize: 20), // Tamanho do texto dentro do botão
          ),
        ),
      ),
    );
  }
}

class TelaJogo extends StatefulWidget {
  @override
  _TelaJogoState createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  final List<String> palavras = [
    'abacaxi',
    'damasco',
    'uva',
    'morango',
    'cereja',
  ];
  String palavra = '';
  String palavraOculta = '';
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

  @override
  void initState() {
    super.initState();
    reiniciarJogo();
  }

  void reiniciarJogo() {
    final random = Random();
    palavra = palavras[random.nextInt(palavras.length)];
    palavraOculta = '_' * palavra.length;
    tentativasRestantes = 6;
    letrasTentadas = [];
    setState(() {});
  }

  void verificarLetra(String letra) {
    if (letrasTentadas.contains(letra)) {
      return;
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

    if (tentativasRestantes == 0) {
      mostrarMensagem('Você perdeu! A palavra era: $palavra');
    } else if (!palavraOculta.contains('_')) {
      mostrarMensagem('Parabéns! Você acertou a palavra: $palavra');
    }

    setState(() {});
  }

  void mostrarMensagem(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fim de Jogo'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: Text('Jogar Novamente'),
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarJogo();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Forca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              forca[6 - tentativasRestantes],
              style: TextStyle(fontFamily: 'Courier', fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              palavraOculta,
              style: TextStyle(fontSize: 30, letterSpacing: 2),
            ),
            SizedBox(height: 20),
            Text(
              'Letras tentadas: ${letrasTentadas.join(', ')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: 'abcdefghijklmnopqrstuvwxyz'.split('').map((String letra) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue[900],
                  ),
                  onPressed: (tentativasRestantes > 0 && palavraOculta.contains('_') && !letrasTentadas.contains(letra))
                      ? () {
                    verificarLetra(letra);
                  }
                      : null,
                  child: Text(letra.toUpperCase()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
