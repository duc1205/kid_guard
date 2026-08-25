import '../../data/datasources/gemini_valuation_datasource.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/repositories/repository_impl.dart';
import '../../domain/repositories/repositories.dart';

/// Simple service locator for the app.
class AppLocator {
  AppLocator._();

  static late final ValuationRepository valuation;
  static late final HistoryRepository history;

  static void init() {
    valuation = ValuationRepositoryImpl(GeminiValuationDatasource());
    history = HistoryRepositoryImpl(HistoryLocalDatasource());
  }
}
