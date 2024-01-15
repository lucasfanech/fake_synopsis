import 'package:flutter/material.dart';
import 'game_page.dart';  // Assure-toi d'importer la classe GamePage correctement

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlayerInputPage(),
    );
  }
}

class PlayerInputPage extends StatefulWidget {
  @override
  _PlayerInputPageState createState() => _PlayerInputPageState();
}

class _PlayerInputPageState extends State<PlayerInputPage> {
  int numberOfPlayers = 2; // Valeur par défaut
  List<String> playerNames = List.generate(2, (index) => ""); // Initialisation des noms des joueurs
  List<int> playerScores = List.generate(2, (index) => 0); // Initialisation des scores des joueurs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisie des Joueurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nombre de Joueurs:'),
            Slider(
              value: numberOfPlayers.toDouble(),
              min: 2,
              max: 6,
              divisions: 4,
              onChanged: (value) {
                setState(() {
                  numberOfPlayers = value.toInt();
                  playerNames = List.generate(numberOfPlayers, (index) => "");
                  playerScores = List.generate(numberOfPlayers, (index) => 0);
                });
              },
            ),
            Text('Noms des Joueurs:'),
            Column(
              children: List.generate(
                numberOfPlayers,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    onChanged: (value) {
                      playerNames[index] = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Joueur ${index + 1}',
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Faire quelque chose avec numberOfPlayers et playerNames
                // Par exemple, naviguer vers la page suivante
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GamePage(numberOfPlayers, playerNames, playerScores),
                  ),
                );
              },
              child: Text('Commencer le Jeu'),
            ),
          ],
        ),
      ),
    );
  }
}


