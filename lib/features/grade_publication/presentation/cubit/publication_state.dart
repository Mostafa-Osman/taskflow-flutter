import '../../../../core/errors/failures.dart';
import '../../../coursework/domain/entities/coursework_item.dart';
import '../../domain/entities/publication_models.dart';

enum PublicationNotice { retry, finished }

class PublicationState {
  const PublicationState({
    this.coursework,
    this.items = const [],
    this.selectedIds = const {},
    this.attempts = const [],
    this.loading = false,
    this.busy = false,
    this.failure,
    this.notice,
    this.noticeStatus,
  });

  final CourseworkItem? coursework;
  final List<PublicationPreviewItem> items;
  final Set<String> selectedIds;
  final List<PublicationAttempt> attempts;
  final bool loading;
  final bool busy;
  final Failure? failure;
  final PublicationNotice? notice;
  final String? noticeStatus;

  PublicationState copyWith({
    CourseworkItem? coursework,
    List<PublicationPreviewItem>? items,
    Set<String>? selectedIds,
    List<PublicationAttempt>? attempts,
    bool? loading,
    bool? busy,
    Failure? failure,
    PublicationNotice? notice,
    String? noticeStatus,
    bool clearFailure = false,
    bool clearNotice = false,
  }) {
    return PublicationState(
      coursework: coursework ?? this.coursework,
      items: items ?? this.items,
      selectedIds: selectedIds ?? this.selectedIds,
      attempts: attempts ?? this.attempts,
      loading: loading ?? this.loading,
      busy: busy ?? this.busy,
      failure: clearFailure ? null : failure ?? this.failure,
      notice: clearNotice ? null : notice ?? this.notice,
      noticeStatus: noticeStatus ?? this.noticeStatus,
    );
  }
}
