import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';

import '../test/widget_test.dart';

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

  runWidgetTests();
}