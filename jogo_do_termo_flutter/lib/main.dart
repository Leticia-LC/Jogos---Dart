import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo do Termo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JogoTermo(),
    );
  }
}

class JogoTermo extends StatefulWidget {
  @override
  _JogoTermoState createState() => _JogoTermoState();
}

class _JogoTermoState extends State<JogoTermo> {
  final List<String> palavras = [
    'fruta', 'plano', 'verde', 'livro', 'canto',
    'certo', 'treze', 'pardo', 'peixe', 'prato'
  ];

  final Random random = Random();
  late String palavraSecreta;
  late List<List<String>> matrizTentativas;
  late int tentativaAtual;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    palavraSecreta = palavras[random.nextInt(palavras.length)].toUpperCase();
    matrizTentativas = List.generate(6, (_) => List.filled(palavraSecreta.length, ''));
    tentativaAtual = 0;
    controller = TextEditingController();
  }

  void verificarTentativa(String tentativa) {
    setState(() {
      for (int i = 0; i < palavraSecreta.length; i++) {
        if (tentativa[i].toUpperCase() == palavraSecreta[i]) {
          matrizTentativas[tentativaAtual][i] = tentativa[i].toUpperCase();
        } else {
          matrizTentativas[tentativaAtual][i] = tentativa[i].toUpperCase();
        }
      }

      tentativaAtual++;

      if (tentativa.toUpperCase() == palavraSecreta) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Parabéns!'),
              content: Text('Você adivinhou a palavra secreta: $palavraSecreta'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    reiniciarJogo();
                  },
                  child: Text('Jogar Novamente'),
                ),
              ],
            );
          },
        );
      } else if (tentativaAtual == 6) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fim de Jogo'),
              content: Text('Você não adivinhou a palavra secreta. A palavra era: $palavraSecreta'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    reiniciarJogo();
                  },
                  child: Text('Jogar Novamente'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void reiniciarJogo() {
    setState(() {
      palavraSecreta = palavras[random.nextInt(palavras.length)].toUpperCase();
      matrizTentativas = List.generate(6, (_) => List.filled(palavraSecreta.length, ''));
      tentativaAtual = 0;
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo do Termo'),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < matrizTentativas.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int j = 0; j < matrizTentativas[i].length; j++)
                    Container(
                      width: 50.0,
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: matrizTentativas[i][j] == palavraSecreta[j].toUpperCase() ? Colors.green : Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: matrizTentativas[i][j].isEmpty ? null : Text(
                        matrizTentativas[i][j],
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20.0),
            TextField(
              controller: controller,
              maxLength: palavraSecreta.length,
              onChanged: (value) {
                if (value.length == palavraSecreta.length) {
                  verificarTentativa(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Digite a palavra',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}

