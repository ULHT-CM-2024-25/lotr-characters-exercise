import 'package:lotr_characters/http/http_client.dart';
import 'package:lotr_characters/model/character.dart';

class CharactersRepository {

  final HttpClient _client;

  CharactersRepository({required HttpClient client}) : _client = client;

  Future<List<Character>> getCharacters() async {

  }

  Future<Character> getCharacter(String id) async {

  }

  Future<List<Quote>> getCharacterQuotes(String id) async {

  }

}
