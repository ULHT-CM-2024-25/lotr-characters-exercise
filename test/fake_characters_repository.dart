import 'package:lotr_characters/model/character.dart';
import 'package:lotr_characters/model/quote.dart';
import 'package:lotr_characters/repository/characters_repository.dart';

class FakeCharactersRepository extends CharactersRepository {

  final quotes = [
    Quote(
      id: "1",
      dialog: "wooof wooof"
    ),
    Quote(
      id: "2",
      dialog: "meowwwww"
    ),
  ];

  final characters = [
    Character(
        id: "456",
        name: "jet li",
        race: "human"
    ),
    Character(
        id: "789",
        name: "bruce lee",
        race: "semi-god"
    ),
    Character(
        id: "123",
        name: "chuck norris",
        race: "god",
        death: "never dies"
    ),
  ];

  FakeCharactersRepository({required super.client});

  @override
  Future<List<Character>> getCharacters() {
    return Future.value(characters);
  }

  @override
  Future<Character> getCharacter(String id) async {
    return Future.value(
      characters.firstWhere((character) => character.id == id)
    );
  }

  @override
  Future<List<Quote>> getCharacterQuotes(String id) async {
    return Future.value(
      id == "123" ? quotes : []
    );
  }

}