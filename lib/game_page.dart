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
    // array of words state having false values for 10 values
    List<bool> wordState = List.generate(10, (index) => false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Page du Jeu'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Colonne de gauche
            Expanded(
              flex: 1, // Utilise 1/2 de l'espace disponible
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tour de ${widget.playerNames[currentPlayerIndex]}'),
                  if (currentMovie != null)
                    Column(
                      children: [
                        Text('Film: ${currentMovie!['title']}'),
                        Image.network('https://image.tmdb.org/t/p/w200${currentMovie!['posterPath']}'),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5, // Limite la largeur du synopsis à la moitié de l'écran
                          child: Text('Synopsis: ${currentMovie!['overview']}'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // Colonne de droite
            Expanded(
              flex: 1, // Utilise 1/2 de l'espace disponible
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Appelle la fonction de génération de film
                      Map<String, String> movie = await MovieGenerator.generateRandomMovie();
                      currentMovie = movie;
                      // Met à jour l'affiche du film et le synopsis
                      setState(() {});
                    },
                    child: Text('Film aléatoire'),
                  ),
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
                  // BOucle pour afficher les mots les uns en dessous des autres
                  if (currentWords != null) Text('Mots à placer:'),
                  if (currentWords != null)
                    // affiche des boutons pour chaque mot
                    for (var i = 0; i < currentWords!.length; i++)
                      ElevatedButton(
                        onPressed: () {
                          // changer la couleur du bouton
                          setState(() {
                            wordState[i] = !wordState[i];
                            // console log to check if the state is changing
                            print(wordState);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: wordState[i] ? Colors.green : Colors.grey,
                        ),
                        child: Text('${currentWords![i]}'),
                      ),
                ],
              ),
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

    // générer les mots
    generateWords();

    print("Après appel à generateRandomMovieAndWords");
    print("currentMovie: ${currentMovie!['title']}");
    print("currentWords: $currentWords");

  }

  // Fonction pour générer les mots
  void generateWords() async {
    List<String> words = await WordGenerator.getRandomWords();

    // Met à jour l'état avec les mots générés
    setState(() {
      currentWords = words;
    });
  }




}

