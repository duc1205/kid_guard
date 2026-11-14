/// Nguồn thời gian có thể thay thế trong test.
typedef Clock = DateTime Function();

DateTime systemClock() => DateTime.now();
