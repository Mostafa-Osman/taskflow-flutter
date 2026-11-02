import '../../../../core/errors/failures.dart';
import '../../domain/entities/google_connection.dart';

enum IntegrationNotice { connected, disconnected, policyUpdated, imported }

class IntegrationState {
  const IntegrationState({
    this.connection,
    this.courses = const [],
    this.selectedCourseIds = const {},
    this.loading = false,
    this.busy = false,
    this.failure,
    this.notice,
    this.importedCount,
  });

  final GoogleConnection? connection;
  final List<ExternalCourseOption> courses;
  final Set<String> selectedCourseIds;
  final bool loading;
  final bool busy;
  final Failure? failure;
  final IntegrationNotice? notice;
  final int? importedCount;

  bool get connected => connection?.isConnected == true;

  IntegrationState copyWith({
    GoogleConnection? connection,
    List<ExternalCourseOption>? courses,
    Set<String>? selectedCourseIds,
    bool? loading,
    bool? busy,
    Failure? failure,
    IntegrationNotice? notice,
    int? importedCount,
    bool clearFailure = false,
    bool clearConnection = false,
    bool clearNotice = false,
  }) {
    return IntegrationState(
      connection: clearConnection ? null : connection ?? this.connection,
      courses: courses ?? this.courses,
      selectedCourseIds: selectedCourseIds ?? this.selectedCourseIds,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      failure: clearFailure ? null : failure ?? this.failure,
      notice: clearNotice ? null : notice ?? this.notice,
      importedCount: importedCount ?? this.importedCount,
    );
  }
}
