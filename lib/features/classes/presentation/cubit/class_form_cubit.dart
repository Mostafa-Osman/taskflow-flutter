import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/entities/class_filter.dart';
import '../../domain/usecases/create_class_usecase.dart';
import 'class_form_state.dart';

class ClassFormCubit extends Cubit<ClassFormState> {
  ClassFormCubit(this._createClass) : super(const ClassFormState());

  final CreateClassUseCase _createClass;

  void setName(String value) =>
      emit(state.copyWith(name: value, clearNameError: true, clearFailure: true));

  void setSubject(String value) => emit(state.copyWith(subject: value));

  void setDescription(String value) => emit(state.copyWith(description: value));

  Future<void> submit() async {
    final nameError = Validators.required(state.name, field: 'Class name');
    if (nameError != null) {
      emit(state.copyWith(nameError: nameError));
      return;
    }
    emit(state.copyWith(submitting: true, clearFailure: true));
    final result = await _createClass(
      CreateClassInput(
        name: state.name.trim(),
        subject: state.subject.trim().isEmpty ? null : state.subject.trim(),
        description: state.description.trim(),
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(submitting: false, failure: failure)),
      (_) => emit(state.copyWith(submitting: false, submitted: true)),
    );
  }
}
