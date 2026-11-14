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
import '../../domain/usecases/parent_usecases.dart';
import '../../domain/usecases/pick_question.dart';
import '../../domain/usecases/question_bank_usecases.dart';
import '../../domain/usecases/register_child.dart';
import '../../domain/usecases/session_usecases.dart';
import '../../presentation/controllers/guard_controller.dart';
import '../../presentation/controllers/parent_controller.dart';
import '../../presentation/controllers/question_bank_controller.dart';
import '../constants/app_constants.dart';

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
    required this.questionBankController,
  });

  final GuardController guardController;
  final ParentController parentController;
  final DeviceControlRepository device;
  final ParentAuthRepository parentAuth;
  final GetChildHistoryUseCase getChildHistory;
  final GetWeakTopicsUseCase getWeakTopics;
  final SetupChecklistRepository setupChecklist;
  final QuestionBankController questionBankController;

  static Future<AppDependencies> create() async {
    const uuid = Uuid();
    String newId() => uuid.v4();

    final store = LocalStore(SharedPreferencesAsync());
    final database = await AppDatabase.open();
    final ChildRepository children = SqliteChildRepository(database);
    final UsageLogRepository logs = SqliteUsageLogRepository(database);
    final ActiveSessionRepository active = PrefsActiveSessionRepository(store);
    final questionBank = QuestionBankRepositoryImpl(
      assets: QuestionAssetDataSource(),
      cache: QuestionCacheDataSource(database),
      remote: QuestionRemoteDataSource(),
      store: store,
    );
    final QuestionRepository questions = questionBank;
    final DeviceControlRepository device = DeviceControlChannel();
    final ParentAuthRepository parentAuth = LocalAuthDataSource();

    await LegacyPrefsMigration(store, children, logs).run();
    // Dọn nhật ký cũ ở nền, không chặn lúc mở app.
    PruneOldLogsUseCase(logs)().then(
      (n) => n > 0 ? debugPrint('Pruned $n old sessions') : null,
      onError: (Object e) => debugPrint('Prune failed: $e'),
    );

    final syncQuestions = SyncQuestionBankUseCase(questionBank);
    // Kiểm tra bộ câu hỏi mới ở nền; lỗi mạng thì vẫn dùng bản đang có.
    syncQuestions(minInterval: AppConstants.questionSyncInterval).then(
      (r) => r == null ? null : debugPrint('Question sync: ${r.status}'),
      onError: (Object e) => debugPrint('Question sync failed: $e'),
    );

    final pickQuestion = PickQuestionUseCase(questions, logs);
    final authenticate = AuthenticateParentUseCase(parentAuth, device);

    return AppDependencies._(
      device: device,
      parentAuth: parentAuth,
      getChildHistory: GetChildHistoryUseCase(logs),
      getWeakTopics: GetWeakTopicsUseCase(logs),
      setupChecklist: PrefsSetupChecklistRepository(store),
      questionBankController: QuestionBankController(
        bank: questionBank,
        sync: syncQuestions,
        changeSource: ChangeQuestionSourceUseCase(questionBank),
      ),
      guardController: GuardController(
        activeSessions: active,
        device: device,
        parentAuth: parentAuth,
        registerChild: RegisterChildUseCase(children, newId),
        startSession: StartSessionUseCase(active, logs, device, newId),
        handleTimeUp: HandleTimeUpUseCase(active, logs, device, pickQuestion),
        submitAnswer: SubmitAnswerUseCase(active, logs, device),
        acknowledgeWrong: AcknowledgeWrongAnswerUseCase(active, logs, device),
        revokeSession: RevokeSessionUseCase(active, logs, device),
        authenticateParent: authenticate,
      ),
      parentController: ParentController(
        getReports: GetChildReportsUseCase(children, logs),
        authenticateParent: authenticate,
      ),
    );
  }
}
