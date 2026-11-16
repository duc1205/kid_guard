import '../../domain/entities/active_session.dart';
import '../../domain/entities/child_profile.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/study_task.dart';
import '../../domain/entities/usage_log.dart';

/// Chuyển đổi entity <-> JSON. Tách khỏi domain để domain không phụ thuộc định dạng lưu trữ.
typedef Json = Map<String, dynamic>;

DateTime _dt(Object? v) => DateTime.parse(v as String);
DateTime? _dtOrNull(Object? v) =>
    v == null ? null : DateTime.parse(v as String);

class ChildProfileMapper {
  static Json toJson(ChildProfile c) => {
    'id': c.id,
    'name': c.name,
    'dateOfBirth': c.dateOfBirth.toIso8601String(),
    'grade': c.grade,
    'createdAt': c.createdAt.toIso8601String(),
  };

  static ChildProfile fromJson(Json j) => ChildProfile(
    id: j['id'] as String,
    name: j['name'] as String,
    dateOfBirth: _dt(j['dateOfBirth']),
    grade: j['grade'] as int,
    createdAt: _dt(j['createdAt']),
  );
}

class QuestionMapper {
  /// Đọc từ file assets/questions/grade_N.json.
  static Question fromAsset(Json j, int grade) => Question(
    id: j['id'] as String,
    grade: grade,
    subject: j['subject'] as String,
    topic: j['topic'] as String,
    type: QuestionType.values.byName(j['type'] as String),
    text: j['question'] as String,
    options: List<String>.from(j['options'] as List),
    answerIndex: j['answerIndex'] as int,
    suggestion: j['suggestion'] as String,
    optionOrder: j['optionOrder'] == null
        ? const [0, 1, 2, 3]
        : List<int>.from(j['optionOrder'] as List),
    difficulty: j['difficulty'] as int?,
    term: j['term'] as int?,
  );

  static Json toJson(Question q) => {
    'id': q.id,
    'subject': q.subject,
    'topic': q.topic,
    'type': q.type.name,
    'question': q.text,
    'options': q.options,
    'answerIndex': q.answerIndex,
    'suggestion': q.suggestion,
    'grade': q.grade,
    'optionOrder': q.optionOrder,
    if (q.difficulty != null) 'difficulty': q.difficulty,
    if (q.term != null) 'term': q.term,
  };

  static Question fromJson(Json j) => fromAsset(j, j['grade'] as int);
}

class UsageLogMapper {
  static Json attemptToJson(QuestionAttempt a) => {
    'questionId': a.questionId,
    'subject': a.subject,
    'topic': a.topic,
    'questionText': a.questionText,
    'options': a.options,
    'correctIndex': a.correctIndex,
    'chosenIndex': a.chosenIndex,
    'suggestion': a.suggestion,
    'answeredAt': a.answeredAt.toIso8601String(),
  };

  static QuestionAttempt attemptFromJson(Json j) => QuestionAttempt(
    questionId: j['questionId'] as String,
    subject: j['subject'] as String,
    topic: j['topic'] as String,
    questionText: j['questionText'] as String,
    options: List<String>.from(j['options'] as List),
    correctIndex: j['correctIndex'] as int,
    chosenIndex: j['chosenIndex'] as int,
    suggestion: j['suggestion'] as String,
    answeredAt: _dt(j['answeredAt']),
  );

  static Json toJson(UsageLog l) => {
    'id': l.id,
    'childId': l.childId,
    'childName': l.childName,
    'grade': l.grade,
    'startedAt': l.startedAt.toIso8601String(),
    'endedAt': l.endedAt?.toIso8601String(),
    'lockedAt': l.lockedAt?.toIso8601String(),
    'usedSeconds': l.usedTime.inSeconds,
    'attempts': l.attempts.map(attemptToJson).toList(),
  };

  static UsageLog fromJson(Json j) => UsageLog(
    id: j['id'] as String,
    childId: j['childId'] as String,
    childName: j['childName'] as String,
    grade: j['grade'] as int,
    startedAt: _dt(j['startedAt']),
    endedAt: _dtOrNull(j['endedAt']),
    lockedAt: _dtOrNull(j['lockedAt']),
    usedTime: Duration(seconds: j['usedSeconds'] as int? ?? 0),
    attempts: (j['attempts'] as List? ?? const [])
        .map((e) => attemptFromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

class StudyTaskMapper {
  static Json toJson(StudyTask t) => {
    'id': t.id,
    'childId': t.childId,
    'title': t.title,
    'kind': t.kind.name,
    'rewardMinutes': t.reward.inMinutes,
    'durationMinutes': t.duration?.inMinutes,
    'position': t.position,
    'createdAt': t.createdAt.toIso8601String(),
  };

  static StudyTask fromJson(Json j) => StudyTask(
    id: j['id'] as String,
    childId: j['childId'] as String,
    title: j['title'] as String,
    kind: StudyTaskKind.values.byName(j['kind'] as String),
    reward: Duration(minutes: j['rewardMinutes'] as int),
    duration: j['durationMinutes'] == null
        ? null
        : Duration(minutes: j['durationMinutes'] as int),
    position: j['position'] as int? ?? 0,
    createdAt: _dt(j['createdAt']),
  );
}

class ActiveSessionMapper {
  static Json toJson(ActiveSession s) => {
    'logId': s.logId,
    'child': ChildProfileMapper.toJson(s.child),
    'status': s.status.name,
    'endsAt': s.endsAt.toIso8601String(),
    'segmentStartedAt': s.segmentStartedAt?.toIso8601String(),
    'currentQuestion': s.currentQuestion == null
        ? null
        : QuestionMapper.toJson(s.currentQuestion!),
    'chosenIndex': s.chosenIndex,
    if (s.currentTask != null)
      'currentTask': StudyTaskMapper.toJson(s.currentTask!),
    if (s.taskEndsAt != null) 'taskEndsAt': s.taskEndsAt!.toIso8601String(),
  };

  static ActiveSession fromJson(Json j) => ActiveSession(
    logId: j['logId'] as String,
    child: ChildProfileMapper.fromJson(
      Map<String, dynamic>.from(j['child'] as Map),
    ),
    status: GuardStatus.values.byName(j['status'] as String),
    endsAt: _dt(j['endsAt']),
    segmentStartedAt: _dtOrNull(j['segmentStartedAt']),
    currentQuestion: j['currentQuestion'] == null
        ? null
        : QuestionMapper.fromJson(
            Map<String, dynamic>.from(j['currentQuestion'] as Map),
          ),
    chosenIndex: j['chosenIndex'] as int?,
    currentTask: j['currentTask'] == null
        ? null
        : StudyTaskMapper.fromJson(
            Map<String, dynamic>.from(j['currentTask'] as Map),
          ),
    taskEndsAt: _dtOrNull(j['taskEndsAt']),
  );
}
