import 'package:flutter_test/flutter_test.dart';
import 'package:lotr_characters/model/character.dart';

void main() {
  test('toString', () {
    final character = Character(id: "123", name: "chuck norris", race: "god");

    expect(
      character.toString(),
      "chuck norris - god",
      reason: "O método toString deve seguir o formato <name> - <race>"
    );

  });
}