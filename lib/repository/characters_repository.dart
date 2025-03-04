import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lotr_characters/http/http_client.dart';
import 'package:lotr_characters/model/character.dart';

class CharactersRepository {
  final HttpClient _client;

  CharactersRepository({required HttpClient client}) : _client = client;

  Future<List<Character>> getCharacters() async {
    final response = await _client.get(
      url: 'https://the-one-api.dev/v2/character',
      headers: {'Authorization': 'Bearer TQiWw7336HyGreC_b0Y_'},
    );

    if (response.statusCode == 200) {
      final responseJSON = jsonDecode(response.body);
      List charactersJSON = responseJSON['docs'];

      List<Character> characters =
        charactersJSON.map((characterJSON) => Character.fromMap(characterJSON)).toList();

      return characters;
    } else {
      throw Exception('status code: ${response.statusCode}');
    }
  }

  Future<Character> getCharacter(String id) async {

    final response = await _client.get(
      url: 'https://the-one-api.dev/v2/character/$id',
      headers: {'Authorization': 'Bearer TQiWw7336HyGreC_b0Y_'},
    );

    if (response.statusCode == 200) {
      final responseJSON = jsonDecode(response.body);
      List charactersJSON = responseJSON['docs'];

      final characterJSON = charactersJSON[0];

      return Character.fromMap(characterJSON);
    } else {
      throw Exception('status code: ${response.statusCode}');
    }
  }
}
