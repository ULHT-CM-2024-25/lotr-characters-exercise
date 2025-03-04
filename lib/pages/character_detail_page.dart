import 'package:flutter/material.dart';
import 'package:lotr_characters/model/character.dart';
import 'package:lotr_characters/repository/characters_repository.dart';
import 'package:provider/provider.dart';

class CharacterDetailPage extends StatelessWidget {
  final String characterId;

  const CharacterDetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<CharactersRepository>();

    return Scaffold(
        appBar: AppBar(title: Text('${characterId}')),
        body: Center(
          child: FutureBuilder(
            future: repository.getCharacter(characterId),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error!');
                } else {
                  return buildCharacter(snapshot.data!);
                }
              }
            },
          ),
        ));
  }

  Widget buildCharacter(Character character) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    width: 150,
                    image: NetworkImage(
                        'https://download.vikidia.org/vikidia/fr/images/thumb/f/ff/Anneau_unique.png/400px-Anneau_unique.png')),
                Text(
                  character.name,
                  style: TextStyle(fontSize: 40),
                ),
                Text('Born on ${character.birth}', style: TextStyle(fontSize: 20)),
                Text('Died on ${character.death}', style: TextStyle(fontSize: 20)),
              ],
            );
  }
}
