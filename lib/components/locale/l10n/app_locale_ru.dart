// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get title => 'Пингвины';

  @override
  String get searchHint => 'Поиск по пингвинам…';

  @override
  String get emptyList => 'Список пуст';

  @override
  String get notFound => 'Ничего не найдено';

  @override
  String get refresh => 'Обновить';

  @override
  String get retry => 'Повторить';

  @override
  String get liked => 'Добавлено в избранное';

  @override
  String get disliked => 'Удалено из избранного';
}
