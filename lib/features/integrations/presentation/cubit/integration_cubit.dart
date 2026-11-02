import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/classroom/enums.dart';
import '../../domain/usecases/integration_usecases.dart';
import 'integration_state.dart';

class IntegrationCubit extends Cubit<IntegrationState> {
  IntegrationCubit({
    required ConnectGoogleClassroomUseCase connect,
    required DisconnectGoogleClassroomUseCase disconnect,
    required GetIntegrationSettingsUseCase getSettings,
    required UpdateConnectionPolicyUseCase updatePolicy,
    required ListExternalCoursesUseCase listCourses,
    required ImportExternalCoursesUseCase importCourses,
  }) : _connect = connect,
       _disconnect = disconnect,
       _getSettings = getSettings,
       _updatePolicy = updatePolicy,
       _listCourses = listCourses,
       _importCourses = importCourses,
       super(const IntegrationState());

  final ConnectGoogleClassroomUseCase _connect;
  final DisconnectGoogleClassroomUseCase _disconnect;
  final GetIntegrationSettingsUseCase _getSettings;
  final UpdateConnectionPolicyUseCase _updatePolicy;
  final ListExternalCoursesUseCase _listCourses;
  final ImportExternalCoursesUseCase _importCourses;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearFailure: true, clearNotice: true));
    await _fetch();
  }

  Future<void> refresh() async {
    emit(state.copyWith(clearFailure: true, clearNotice: true));
    await _fetch();
  }

  Future<void> _fetch() async {
    final result = await _getSettings();
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            loading: false,
            clearConnection: true,
            failure: failure.message.contains('not connected') ? null : failure,
          ),
        );
      },
      (connection) async {
        emit(state.copyWith(loading: false, connection: connection));
        if (connection.isConnected) {
          await refreshCourses();
        }
      },
    );
  }

  Future<void> connect() async {
    emit(state.copyWith(busy: true, clearFailure: true));
    final result = await _connect();
    await result.fold(
      (failure) async => emit(state.copyWith(busy: false, failure: failure)),
      (connection) async {
        emit(
          state.copyWith(
            busy: false,
            connection: connection,
            notice: IntegrationNotice.connected,
          ),
        );
        await refreshCourses();
      },
    );
  }

  Future<void> disconnect() async {
    emit(state.copyWith(busy: true, clearFailure: true));
    final result = await _disconnect();
    result.fold(
      (failure) => emit(state.copyWith(busy: false, failure: failure)),
      (connection) => emit(
        state.copyWith(
          busy: false,
          connection: connection,
          courses: const [],
          notice: IntegrationNotice.disconnected,
        ),
      ),
    );
  }

  Future<void> updatePolicy(ConnectionGradeSyncPolicy policy) async {
    emit(state.copyWith(busy: true, clearFailure: true));
    final result = await _updatePolicy(policy);
    result.fold(
      (failure) => emit(state.copyWith(busy: false, failure: failure)),
      (connection) => emit(
        state.copyWith(
          busy: false,
          connection: connection,
          notice: IntegrationNotice.policyUpdated,
        ),
      ),
    );
  }

  Future<void> refreshCourses() async {
    final result = await _listCourses();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (courses) => emit(state.copyWith(courses: courses)),
    );
  }

  void toggleCourse(String id) {
    final selected = {...state.selectedCourseIds};
    if (selected.contains(id)) {
      selected.remove(id);
    } else {
      selected.add(id);
    }
    emit(state.copyWith(selectedCourseIds: selected));
  }

  Future<void> importSelected() async {
    if (state.selectedCourseIds.isEmpty) {
      return;
    }
    emit(state.copyWith(busy: true, clearFailure: true));
    final result = await _importCourses(state.selectedCourseIds.toList());
    result.fold(
      (failure) => emit(state.copyWith(busy: false, failure: failure)),
      (items) => emit(
        state.copyWith(
          busy: false,
          selectedCourseIds: {},
          notice: IntegrationNotice.imported,
          importedCount: items.length,
        ),
      ),
    );
  }
}
