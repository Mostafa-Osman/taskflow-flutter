import '../../../../core/errors/failures.dart';

class ClassFormState {
  const ClassFormState({
    this.name = '',
    this.subject = '',
    this.description = '',
    this.submitting = false,
    this.submitted = false,
    this.nameError,
    this.failure,
  });

  final String name;
  final String subject;
  final String description;
  final bool submitting;
  final bool submitted;
  final String? nameError;
  final Failure? failure;

  ClassFormState copyWith({
    String? name,
    String? subject,
    String? description,
    bool? submitting,
    bool? submitted,
    String? nameError,
    Failure? failure,
    bool clearNameError = false,
    bool clearFailure = false,
  }) {
    return ClassFormState(
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      submitting: submitting ?? this.submitting,
      submitted: submitted ?? this.submitted,
      nameError: clearNameError ? null : nameError ?? this.nameError,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
