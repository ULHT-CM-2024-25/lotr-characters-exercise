import 'package:flutter/material.dart';
import 'package:lotr_characters/pages/character_detail_page.dart';
import 'package:lotr_characters/repository/characters_repository.dart';
import 'package:provider/provider.dart';

import '../model/character.dart';

class CharactersListPage extends StatefulWidget {
  CharactersListPage({super.key});

  @override
  State<CharactersListPage> createState() => _CharactersListPageState();
}

class _CharactersListPageState extends State<CharactersListPage> {
  bool _buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<CharactersRepository>();

    return Scaffold(
      appBar: AppBar(title: Text('Lord of the rings')),
      body: !_buttonPressed
          ? buildGetCharactersButton(repository)
          : FutureBuilder(
              future: repository.getCharacters(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else {
                    return buildList(snapshot.data ?? []);
                  }
                }
              },
            ),
    );
  }

  Widget buildList(List<Character> characters) {
    return ListView.separated(
      itemBuilder: (_, index) => ListTile(
        leading: characters[index].gender == 'Male'
            ? Icon(Icons.man)
            : characters[index].gender == 'Female'
                ? Icon(Icons.woman)
                : null,
        title: Text(characters[index].name),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CharacterDetailPage(characterId: characters[index].id),
            )),
      ),
      separatorBuilder: (_, index) => Divider(color: Colors.grey, thickness: 0.5),
      itemCount: characters.length,
    );
  }

  Widget buildGetCharactersButton(CharactersRepository repository) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() => _buttonPressed = true);
        },
        child: Text('Get Characters'),
      ),
    );
  }
}
