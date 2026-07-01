// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Нохчийн';

  @override
  String get appTagline => 'Лучший путь к чеченскому языку';

  @override
  String get kidsModeTitle => 'Детский режим';

  @override
  String get kidsModeSubtitle => 'Игра, истории, большие кнопки';

  @override
  String get adultModeTitle => 'Взрослый режим';

  @override
  String get adultModeSubtitle => 'Карточки, грамматика, статистика';

  @override
  String get agePickerTitle => 'Сколько лет?';

  @override
  String get age3to6 => '3–6 лет';

  @override
  String get age6to9 => '6–9 лет';

  @override
  String get age9to12 => '9–12 лет';

  @override
  String get dictionaryTitle => 'Словарь';

  @override
  String get dictionarySearchHint => 'Поиск: чеченский или русский';

  @override
  String dictionaryMeta(int count) {
    return '$count слов · Мациев + Алироев + учебник';
  }

  @override
  String get verifiedLabel => '✓ проверено';

  @override
  String quizTitle(int score) {
    return 'Викторина · ★ $score';
  }

  @override
  String get notEnoughWords => 'Недостаточно слов';

  @override
  String get quizTapHint => 'Выберите правильный перевод';

  @override
  String get paywallTitle => 'Нохчийн Premium';

  @override
  String get paywallHeadline => 'Весь путь к чеченскому';

  @override
  String get paywallSubtitle =>
      'Безлимитные уроки, повторения и статистика для родителей';

  @override
  String paywallTrialTitle(int days) {
    return '$days дней бесплатно';
  }

  @override
  String get paywallTrialSubtitle => 'затем подписка · отмена в любой момент';

  @override
  String get paywallStartTrial => 'Начать пробный период';

  @override
  String get paywallBuyPremium => 'Купить Premium';

  @override
  String get paywallRestore => 'Восстановить покупки';

  @override
  String get paywallLegal =>
      'Продолжая, вы соглашаетесь с Условиями и Политикой конфиденциальности';

  @override
  String get compareFree => 'Free';

  @override
  String get comparePremium => 'Premium';

  @override
  String get compareRowUnits => 'Первые 3 юнита';

  @override
  String get compareRowPath => 'Весь путь обучения';

  @override
  String get compareRowSrs => 'SRS без лимита';

  @override
  String get compareRowParent => 'Статистика родителя';

  @override
  String get compareRowOffline => 'Офлайн-паки';

  @override
  String get loading => 'Загрузка…';

  @override
  String get retry => 'Повторить';
}
