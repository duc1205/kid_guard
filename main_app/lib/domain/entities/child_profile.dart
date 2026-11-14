class ChildProfile {
  const ChildProfile({
    required this.id,
    required this.name,
    required this.dateOfBirth,
    required this.grade,
    required this.createdAt,
  });

  final String id;
  final String name;
  final DateTime dateOfBirth;

  /// Lớp 1..12 theo chương trình giáo dục phổ thông Việt Nam.
  final int grade;
  final DateTime createdAt;

  int ageAt(DateTime now) {
    var age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  ChildProfile copyWith({String? name, DateTime? dateOfBirth, int? grade}) =>
      ChildProfile(
        id: id,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        grade: grade ?? this.grade,
        createdAt: createdAt,
      );
}
