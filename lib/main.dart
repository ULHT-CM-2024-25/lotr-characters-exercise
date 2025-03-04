import 'package:flutter/material.dart';
import 'package:lotr_characters/pages/characters_list_page.dart';
import 'package:lotr_characters/repository/characters_repository.dart';
import 'package:provider/provider.dart';

import 'http/http_client.dart';

void main() {
  runApp(Provider(
    create: (_) => CharactersRepository(client: HttpClient()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CharactersListPage(),
    );
  }
}
