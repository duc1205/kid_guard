import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/app_database.dart';
import '../../data/datasources/device_control_channel.dart';
import '../../data/datasources/legacy_prefs_migration.dart';
import '../../data/datasources/local_auth_datasource.dart';
import '../../data/datasources/local_store.dart';
import '../../data/datasources/question_asset_datasource.dart';
import '../../data/datasources/question_cache_datasource.dart';
import '../../data/datasources/question_remote_datasource.dart';
import '../../data/repositories/question_bank_repository.dart';
import '../../data/repositories/repository_impls.dart';
import '../../data/repositories/sqlite_repositories.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/advanced_lock_usecases.dart';
import '../../domain/usecases/parent_usecases.dart';
import '../../domain/usecases/pick_question.dart';
import '../../domain/usecases/question_bank_usecases.dart';
import '../../domain/usecases/register_child.dart';
import '../../domain/usecases/session_usecases.dart';
import '../../domain/usecases/settings_usecases.dart';
import '../../presentation/controllers/guard_controller.dart';
import '../../presentation/controllers/parent_controller.dart';
import '../../presentation/controllers/question_bank_controller.dart';
import '../../presentation/controllers/settings_controller.dart';

/// Composition root: nơi duy nhất nối các tầng data → domain → presentation.
class AppDependencies {
  AppDependencies._({
    required this.guardController,
    required this.parentController,
    required this.device,
    required this.parentAuth,
    required this.getChildHistory,
    required this.getWeakTopics,
    required this.setupChecklist,
    required this.parentConsent,
    required this.checkAdvancedLock,
    required this.questionBankController,
    required this.settingsController,
  });

  final GuardController guardController;
  final ParentController parentController;
  final DeviceControlRepository device;
  final ParentAuthRepository parentAuth;
  final GetChildHistoryUseCase getChildHistory;
  final GetWeakTopicsUseCase getWeakTopics;
  final SetupChecklistRepository setupChecklist;
  final ParentConsentRepository parentConsent;
  final CheckAdvancedLockUseCase checkAdvancedLock;
  final QuestionBankController questionBankController;
  final SettingsController settingsController;

  /// Các tham số tuỳ chọn chỉ để test thay phần phụ thuộc nền tảng
  /// (bộ nhớ, CSDL, kênh native, xác thực); app thật gọi không tham số.
  static Future<AppDependencies> create({
    @visibleForTesting LocalStore? store,
    @visibleForTesting AppDatabase? database,
    @visibleForTesting DeviceControlRepository? device,
    @visibleForTesting ParentAuthRepository? parentAuth,
    @visibleForTesting QuestionRemoteDataSource? remote,
  }) async {
    const uuid = Uuid();
    String newId() => uuid.v4();

    store ??= LocalStore(SharedPreferencesAsync());
    database ??= await AppDatabase.open();
    final ChildRepository children = SqliteChildRepository(database);
    final UsageLogRepository logs = SqliteUsageLogRepository(database);
    final ActiveSessionRepository active = PrefsActiveSessionRepository(store);
    final questionBank = QuestionBankRepositoryImpl(
      assets: QuestionAssetDataSource(),
      cache: QuestionCacheDataSource(database),
      remote: remote ?? QuestionRemoteDataSource(),
      store: store,
    );
    final QuestionRepository questions = questionBank;
    device ??= DeviceControlChannel();
    parentAuth ??= LocalAuthDataSource();
    final SettingsRepository settings = PrefsSettingsRepository(store);
    final settingsController = SettingsController(
      settings: settings,
      setInitialAllowance: SetInitialAllowanceUseCase(settings),
    );
    await settingsController.load();

    await LegacyPrefsMigration(store, children, logs).run();
    // Dọn nhật ký cũ ở nền, không chặn lúc mở app.
    PruneOldLogsUseCase(logs)().then(
      (n) => n > 0 ? debugPrint('Pruned $n old sessions') : null,
      onError: (Object e) => debugPrint('Prune failed: $e'),
    );

    final syncQuestions = SyncQuestionBankUseCase(questionBank);
    final questionBankController = QuestionBankController(
      bank: questionBank,
      sync: syncQuestions,
      changeSource: ChangeQuestionSourceUseCase(questionBank),
    );
    // Kiểm tra bộ câu hỏi mới ở nền, không chặn lúc mở app.
    questionBankController.syncInBackground();

    final pickQuestion = PickQuestionUseCase(questions, logs);
    final authenticate = AuthenticateParentUseCase(parentAuth, device);

    return AppDependencies._(
      device: device,
      parentAuth: parentAuth,
      getChildHistory: GetChildHistoryUseCase(logs),
      getWeakTopics: GetWeakTopicsUseCase(logs),
      setupChecklist: PrefsSetupChecklistRepository(store),
      parentConsent: PrefsParentConsentRepository(store),
      checkAdvancedLock: CheckAdvancedLockUseCase(
        PrefsAdvancedLockMemoryRepository(store),
      ),
      settingsController: settingsController,
      questionBankController: questionBankController,
      guardController: GuardController(
        activeSessions: active,
        children: children,
        device: device,
        parentAuth: parentAuth,
        registerChild: RegisterChildUseCase(children, newId),
        startSession: StartSessionUseCase(
          active,
          logs,
          device,
          settings,
          newId,
        ),
        handleTimeUp: HandleTimeUpUseCase(active, logs, device, pickQuestion),
        submitAnswer: SubmitAnswerUseCase(active, logs, device),
        acknowledgeWrong: AcknowledgeWrongAnswerUseCase(active, logs, device),
        revokeSession: RevokeSessionUseCase(active, logs, device),
        authenticateParent: authenticate,
      ),
      parentController: ParentController(
        getReports: GetChildReportsUseCase(children, logs),
        authenticateParent: authenticate,
        updateChild: UpdateChildUseCase(children),
      ),
    );
  }
}
