import 'package:flutter/material.dart';
import 'movie_generator.dart';
import 'word_generator.dart';

class GamePage extends StatefulWidget {
  final int numberOfPlayers;
  final List<String> playerNames;

  GamePage(this.numberOfPlayers, this.playerNames);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int currentPlayerIndex = 0;
  Map<String, String>? currentMovie;
  List<String>? currentWords;

  @override
  void initState() {
    super.initState();
    // Initialise le premier tour
    generateRandomMovieAndWords();
  }


  // Fonction pour passer au tour suivant
  void nextTurn() {
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % widget.numberOfPlayers;
    });
    // Génère un nouveau film et de nouveaux mots pour le joueur suivant
    generateRandomMovieAndWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page du Jeu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tour de ${widget.playerNames[currentPlayerIndex]}'),
            if (currentMovie != null)
              Column(
                children: [
                  Text('Film: ${currentMovie!['title']}'),
                  Image.network('https://image.tmdb.org/t/p/w200${currentMovie!['posterPath']}'),
                  Text('Synopsis: ${currentMovie!['overview']}'),
                ],
              ),
            if (currentWords != null) Text('Mots à placer: ${currentWords!.join(', ')}'),
            ElevatedButton(
              onPressed: () {
                // Faire quelque chose avec les mots placés (à implémenter)
                // Par exemple, vérifier si les mots sont correctement placés et attribuer des points
                // ...

                // Passer au tour suivant
                nextTurn();
              },
              child: Text('Terminer le Tour'),
            ),
            ElevatedButton(
              onPressed: () {
                // Commencer le tour pour le joueur actuel
                print('Avant appel à generateRandomMovieAndWords');
                print('currentMovie: $currentMovie');
                generateRandomMovieAndWords();
                // print movie and words in console
                print('Après appel à generateRandomMovieAndWords');
                print('currentMovie: $currentMovie');
              },
              child: Text('Commencer le Tour'),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour générer un film et des mots aléatoires
  void generateRandomMovieAndWords() async {

    // Appelle la fonction de génération de film
    Map<String, String> movie = await MovieGenerator.generateRandomMovie();
    // Met à jour l'état avec les résultats
    setState(() {
      currentMovie = movie;

    });

    // Utilise le synopsis du film pour générer les mots
    generateWordsFromSynopsis(currentMovie!['overview']!);


    print("Après appel à generateRandomMovieAndWords");
    print("currentMovie: ${currentMovie!['title']}");
    print("currentWords: $currentWords");

  }

  // Fonction pour générer les mots en utilisant le synopsis
  void generateWordsFromSynopsis(String synopsis) async {
    List<String> words = await WordGenerator.generateWordsFromSynopsis(synopsis);

    // Met à jour l'état avec les mots générés
    setState(() {
      currentWords = words;
    });
  }




}

