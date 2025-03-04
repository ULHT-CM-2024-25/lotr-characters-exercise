import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lotr_characters/http/http_client.dart';

import 'package:lotr_characters/main.dart';
import 'package:lotr_characters/repository/characters_repository.dart';
import 'package:provider/provider.dart';

import '../test/fake_characters_repository.dart';

final keyCharactersListPage = Key('characters-list-page');
final keyCharactersListTitle = Key('characters-list-title');
final keyGetCharactersButton = Key('get-characters-list-btn');
final keyCharactersList = Key('characters-list');

final keyCharactersDetailPage = Key('characters-detail-page');
final keyCharactersDetailTitle = Key('characters-detail-title');
final keyCharacterDetailDiedOn = Key('character-detail-died-on');
final keyCharacterQuotesButton = Key('get-character-detail-quotes-btn');

final keyCharactersQuotePage = Key('characters-quotes-page');
final keyCharactersQuotesTitle = Key('characters-quotes-title');
final keyCharacterQuotesEmpty = Key('characters-quotes-empty');
final keyCharacterQuotesList = Key('characters-quotes-list');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /**
   * Testa se o title da lista de personagens é <nome> - <raça>
   */
  testWidgets('Titulo dos elementos da lista de personagens', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<CharactersRepository>(
        create: (_) => FakeCharactersRepository(client: HttpClient()),
        child: const MyApp(),
      ),
    );

    expectKey(keyCharactersListPage);

    await tester.tap(find.byExpectedKey(keyGetCharactersButton));
    // wait for list rendering
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersListPage);

    final listViewFinder = find.byExpectedKey(keyCharactersList);
    final firstTileTextFinder = find.descendant(of: listViewFinder.first, matching: find.text("jet li - human"));
    expect(
        firstTileTextFinder, findsOneWidget,
        reason: "Os títulos da lista dos personagens deve seguir o formato <nome> - <raça>"
    );
  });

  /**
   * Caso o personagem não tenha data de falecimento, deve aparecer 'Chuck Norris birthday'
   */
  testWidgets('Data de falecimento', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<CharactersRepository>(
        create: (_) => FakeCharactersRepository(client: HttpClient()),
        child: const MyApp(),
      ),
    );

    expectKey(keyCharactersListPage);

    await tester.tap(find.byExpectedKey(keyGetCharactersButton));
    // wait for list rendering
    await tester.pumpAndSettle(Duration(milliseconds: 200));

    final listViewFinder = find.byExpectedKey(keyCharactersList);
    final listTilesFinder = find.descendant(of: listViewFinder, matching: find.byType(ListTile));

    await tester.tap(listTilesFinder.first);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);

    var diedOnFinder = find.byExpectedKey(keyCharacterDetailDiedOn);
    var diedOnText = tester.widget(diedOnFinder);

    expect(
        diedOnText, isA<Text>(),
        reason: "O widget da key ${keyCharacterDetailDiedOn.toString()} deveria ser do tipo <Text>"
    );

    expect(
        (diedOnText as Text).data,
        "Died on Chuck Norris' backyard",
        reason: "O texto <died on> deveria ser <Died on Chuck Norris' backyard> caso <death> seja <null>"
    );

    await tester.pageBack();
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersListPage);

    await tester.tap(listTilesFinder.last);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);

    diedOnFinder = find.byExpectedKey(keyCharacterDetailDiedOn);
    diedOnText = tester.widget(diedOnFinder);
    expect(
        diedOnText, isA<Text>(),
        reason: "O widget da key ${keyCharacterDetailDiedOn.toString()} deveria ser do tipo <Text>"
    );

    expect(
        (diedOnText).data,
        "Died on never dies",
        reason: "O texto <died on> deveria ser <never dies>"
    );
  });

  /**
   * Verifica se no ecrã que lista as quotes o nome do personagem está na AppBar
   */
  testWidgets('Consulta quotes - nomes dos personagens', (WidgetTester tester) async {
    final repository = FakeCharactersRepository(client: HttpClient());

    await tester.pumpWidget(
      Provider<CharactersRepository>(
        create: (_) => repository,
        child: const MyApp(),
      ),
    );

    expectKey(keyCharactersListPage);
    await tester.tap(find.byExpectedKey(keyGetCharactersButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));

    final listViewFinder = find.byExpectedKey(keyCharactersList);
    final listTilesFinder = find.descendant(of: listViewFinder, matching: find.byType(ListTile));
    // Navegar para o detalhe
    await tester.tap(listTilesFinder.first);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    // Navegar para quotes
    await tester.tap(find.byExpectedKey(keyCharacterQuotesButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersQuotePage);

    final firstAppBarTitleFinder = find.byExpectedKey(keyCharactersQuotesTitle);
    final firstAppBarText = tester.widget(firstAppBarTitleFinder);

    expect(
        firstAppBarText, isA<Text>(),
        reason: "O widget da key ${keyCharactersQuotesTitle.toString()} deveria ser do tipo <Text>"
    );

    expect(
        (firstAppBarText as Text).data,
        repository.characters.first.name,
        reason: "O nome do personagem deveria ser apresentado na AppBar ao visitar o ecrãd e quotes"
    );

    // Voltar para o detalhe
    await tester.pageBack();
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);
    // Voltar para a lista de personagens
    await tester.pageBack();
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersListPage);
    // Navegar para o detalhe
    await tester.tap(listTilesFinder.last);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);
    // Navegar para quotes
    await tester.tap(find.byExpectedKey(keyCharacterQuotesButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersQuotePage);

    final lastAppBarTitleFinder = find.byExpectedKey(keyCharactersQuotesTitle);
    final lastAppBarText = tester.widget(lastAppBarTitleFinder);

    expect(
        lastAppBarText, isA<Text>(),
        reason: "O widget da key ${keyCharactersQuotesTitle.toString()} deveria ser do tipo <Text>"
    );

    expect(
        (lastAppBarText as Text).data,
        repository.characters.last.name,
        reason: "O nome do personagem deveria ser apresentado na AppBar ao visitar o ecrãd e quotes"
    );
  });

  /**
   * Verifica se os diálogos dos personagens são listados, caso não existam diálogos, testa se
   * o um texto "no quotes available" é apresentado.
   */
  testWidgets('Consulta quotes - dialogos', (WidgetTester tester) async {
    final repository = FakeCharactersRepository(client: HttpClient());

    await tester.pumpWidget(
      Provider<CharactersRepository>(
        create: (_) => repository,
        child: const MyApp(),
      ),
    );

    expectKey(keyCharactersListPage);
    await tester.tap(find.byExpectedKey(keyGetCharactersButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));

    final listViewFinder = find.byExpectedKey(keyCharactersList);
    final listTilesFinder = find.descendant(of: listViewFinder, matching: find.byType(ListTile));
    // Navegar para o detalhe
    await tester.tap(listTilesFinder.first);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);
    // Navegar para quotes
    await tester.tap(find.byExpectedKey(keyCharacterQuotesButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersQuotePage);

    final noQuotesFinder = find.byExpectedKey(keyCharacterQuotesEmpty);
    final noQuotesText = tester.widget(noQuotesFinder);

    expect(
        noQuotesText, isA<Text>(),
        reason: "O widget da key ${keyCharacterQuotesEmpty.toString()} deveria ser do tipo <Text>"
    );

    expect(
        (noQuotesText as Text).data,
        "No quotes for you",
        reason: "Como não há quotes para este personagem, deveria aparecer a mensagem <No quotes for you>"
    );

    // Voltar para o detalhe
    await tester.pageBack();
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);
    // Voltar para a lista de personagens
    await tester.pageBack();
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersListPage);
    // Navegar para o detalhe
    await tester.tap(listTilesFinder.last);
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersDetailPage);
    // Navegar para quotes
    await tester.tap(find.byExpectedKey(keyCharacterQuotesButton));
    await tester.pumpAndSettle(Duration(milliseconds: 200));
    expectKey(keyCharactersQuotePage);

    expect(
        find.byKey(keyCharacterQuotesEmpty), findsNothing,
        reason: "Para os personagens que têm quotes, a key ${keyCharacterQuotesEmpty.toString()} não deve existir"
    );

    final quotesListViewFinder = find.byExpectedKey(keyCharacterQuotesList);

    repository.quotes
        .map((quote) => quote.dialog)
        .forEach((dialog) {
      final title = find.descendant(of: quotesListViewFinder, matching: find.text(dialog));
      expect(
          title,
          findsOneWidget,
          reason: "Não consegui encontrar na lista de quotes, a quote <$dialog>"
      );
    }
    );
  });
}

/// Helpers
extension on CommonFinders {

  Finder byExpectedKey(Key key, { String? reason }) {
    final result = find.byKey(key);
    expect(
        result, findsOneWidget,
        reason: reason ?? "Não consegui encontrar a key ${key.toString()}"
    );
    return result;
  }

}

void expectKey(Key key, { String? reason }) {
  expect(
      find.byKey(key), findsOneWidget,
      reason: reason ?? "Não consegui encontrar a key ${key.toString()}"
  );
}