import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    @Default('') String title,
    @Default(false) bool completed,
  }) = _Task;
}
