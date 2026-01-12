// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocaleEn extends AppLocale {
  AppLocaleEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'Penguins';

  @override
  String get searchHint => 'Search penguins…';

  @override
  String get emptyList => 'List is empty';

  @override
  String get notFound => 'Nothing found';

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';

  @override
  String get liked => 'Add to favourites';

  @override
  String get disliked => 'Deleted from favourites';
}
