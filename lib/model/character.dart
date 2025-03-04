class Character {
  final String id;
  final String? birth;
  final String? death;
  final String? gender;
  final String name;

  Character({required this.id, this.birth, this.death, this.gender, required this.name});

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
        id: map['_id'],
        birth: map['birth'],
        death: map['death'],
        gender: map['gender'],
        name: map['name']);
  }
}