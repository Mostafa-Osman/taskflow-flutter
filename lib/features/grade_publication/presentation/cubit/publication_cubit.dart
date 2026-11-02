import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../coursework/domain/usecases/coursework_usecases.dart';
import '../../domain/usecases/grade_publication_usecases.dart';
import 'publication_state.dart';

class PublicationCubit extends Cubit<PublicationState> {
  PublicationCubit({
    required GetCourseworkUseCase getCoursework,
    required PreviewPublicationsUseCase preview,
    required PublishGradesUseCase publish,
    required RetryPublicationUseCase retry,
  }) : _getCoursework = getCoursework,
       _preview = preview,
       _publish = publish,
       _retry = retry,
       super(const PublicationState());

  final GetCourseworkUseCase _getCoursework;
  final PreviewPublicationsUseCase _preview;
  final PublishGradesUseCase _publish;
  final RetryPublicationUseCase _retry;
  String? _courseworkId;

  Future<void> load(String courseworkId) async {
    _courseworkId = courseworkId;
    emit(state.copyWith(loading: true, clearFailure: true, clearNotice: true));
    await _fetch(courseworkId);
  }

  Future<void> refresh() async {
    final courseworkId = _courseworkId;
    if (courseworkId == null) {
      return;
    }
    await _fetch(courseworkId);
  }

  Future<void> _fetch(String courseworkId) async {
    final coursework = await _getCoursework(courseworkId);
    final preview = await _preview(courseworkId);
    coursework.fold(
      (failure) => emit(state.copyWith(loading: false, failure: failure)),
      (item) {
        preview.fold(
          (failure) => emit(
            state.copyWith(loading: false, coursework: item, failure: failure),
          ),
          (items) => emit(
            state.copyWith(loading: false, coursework: item, items: items),
          ),
        );
      },
    );
  }

  void toggle(String resultId) {
    final selected = {...state.selectedIds};
    if (selected.contains(resultId)) {
      selected.remove(resultId);
    } else {
      selected.add(resultId);
    }
    emit(state.copyWith(selectedIds: selected));
  }

  Future<void> publishSelected() {
    return _runPublish(state.selectedIds.toList());
  }

  Future<void> publishAllEligible() {
    return _runPublish(
      state.items
          .where((item) => item.eligible)
          .map((item) => item.result.id)
          .toList(),
    );
  }

  Future<void> retry(String attemptId) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    final result = await _retry(attemptId);
    await result.fold(
      (failure) async => emit(state.copyWith(busy: false, failure: failure)),
      (attempt) async {
        emit(
          state.copyWith(
            busy: false,
            attempts: [...state.attempts, attempt],
            notice: PublicationNotice.retry,
            noticeStatus: attempt.status.apiValue,
          ),
        );
        final courseworkId = state.coursework?.id;
        if (courseworkId != null) {
          await load(courseworkId);
        }
      },
    );
  }

  Future<void> _runPublish(List<String> ids) async {
    if (ids.isEmpty) {
      return;
    }
    emit(state.copyWith(busy: true, clearFailure: true, clearNotice: true));
    final result = await _publish(ids);
    await result.fold(
      (failure) async => emit(state.copyWith(busy: false, failure: failure)),
      (attempts) async {
        emit(
          state.copyWith(
            busy: false,
            attempts: attempts,
            notice: PublicationNotice.finished,
          ),
        );
        final courseworkId = state.coursework?.id;
        if (courseworkId != null) {
          await load(courseworkId);
        }
      },
    );
  }
}
