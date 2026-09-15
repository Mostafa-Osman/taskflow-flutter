// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_details_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState()';
}


}

/// @nodoc
class $TaskDetailsStateCopyWith<$Res>  {
$TaskDetailsStateCopyWith(TaskDetailsState _, $Res Function(TaskDetailsState) __);
}


/// Adds pattern-matching-related methods to [TaskDetailsState].
extension TaskDetailsStatePatterns on TaskDetailsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskDetailsInitial value)?  initial,TResult Function( TaskDetailsLoading value)?  loading,TResult Function( TaskDetailsSuccess value)?  success,TResult Function( TaskDetailsError value)?  error,TResult Function( TaskDetailsDeleted value)?  deleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskDetailsInitial() when initial != null:
return initial(_that);case TaskDetailsLoading() when loading != null:
return loading(_that);case TaskDetailsSuccess() when success != null:
return success(_that);case TaskDetailsError() when error != null:
return error(_that);case TaskDetailsDeleted() when deleted != null:
return deleted(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskDetailsInitial value)  initial,required TResult Function( TaskDetailsLoading value)  loading,required TResult Function( TaskDetailsSuccess value)  success,required TResult Function( TaskDetailsError value)  error,required TResult Function( TaskDetailsDeleted value)  deleted,}){
final _that = this;
switch (_that) {
case TaskDetailsInitial():
return initial(_that);case TaskDetailsLoading():
return loading(_that);case TaskDetailsSuccess():
return success(_that);case TaskDetailsError():
return error(_that);case TaskDetailsDeleted():
return deleted(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskDetailsInitial value)?  initial,TResult? Function( TaskDetailsLoading value)?  loading,TResult? Function( TaskDetailsSuccess value)?  success,TResult? Function( TaskDetailsError value)?  error,TResult? Function( TaskDetailsDeleted value)?  deleted,}){
final _that = this;
switch (_that) {
case TaskDetailsInitial() when initial != null:
return initial(_that);case TaskDetailsLoading() when loading != null:
return loading(_that);case TaskDetailsSuccess() when success != null:
return success(_that);case TaskDetailsError() when error != null:
return error(_that);case TaskDetailsDeleted() when deleted != null:
return deleted(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Task task,  bool busy)?  success,TResult Function( Failure failure)?  error,TResult Function()?  deleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskDetailsInitial() when initial != null:
return initial();case TaskDetailsLoading() when loading != null:
return loading();case TaskDetailsSuccess() when success != null:
return success(_that.task,_that.busy);case TaskDetailsError() when error != null:
return error(_that.failure);case TaskDetailsDeleted() when deleted != null:
return deleted();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Task task,  bool busy)  success,required TResult Function( Failure failure)  error,required TResult Function()  deleted,}) {final _that = this;
switch (_that) {
case TaskDetailsInitial():
return initial();case TaskDetailsLoading():
return loading();case TaskDetailsSuccess():
return success(_that.task,_that.busy);case TaskDetailsError():
return error(_that.failure);case TaskDetailsDeleted():
return deleted();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Task task,  bool busy)?  success,TResult? Function( Failure failure)?  error,TResult? Function()?  deleted,}) {final _that = this;
switch (_that) {
case TaskDetailsInitial() when initial != null:
return initial();case TaskDetailsLoading() when loading != null:
return loading();case TaskDetailsSuccess() when success != null:
return success(_that.task,_that.busy);case TaskDetailsError() when error != null:
return error(_that.failure);case TaskDetailsDeleted() when deleted != null:
return deleted();case _:
  return null;

}
}

}

/// @nodoc


class TaskDetailsInitial implements TaskDetailsState {
  const TaskDetailsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState.initial()';
}


}




/// @nodoc


class TaskDetailsLoading implements TaskDetailsState {
  const TaskDetailsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState.loading()';
}


}




/// @nodoc


class TaskDetailsSuccess implements TaskDetailsState {
  const TaskDetailsSuccess(this.task, {this.busy = false});
  

 final  Task task;
@JsonKey() final  bool busy;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailsSuccessCopyWith<TaskDetailsSuccess> get copyWith => _$TaskDetailsSuccessCopyWithImpl<TaskDetailsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsSuccess&&(identical(other.task, task) || other.task == task)&&(identical(other.busy, busy) || other.busy == busy));
}


@override
int get hashCode => Object.hash(runtimeType,task,busy);

@override
String toString() {
  return 'TaskDetailsState.success(task: $task, busy: $busy)';
}


}

/// @nodoc
abstract mixin class $TaskDetailsSuccessCopyWith<$Res> implements $TaskDetailsStateCopyWith<$Res> {
  factory $TaskDetailsSuccessCopyWith(TaskDetailsSuccess value, $Res Function(TaskDetailsSuccess) _then) = _$TaskDetailsSuccessCopyWithImpl;
@useResult
$Res call({
 Task task, bool busy
});




}
/// @nodoc
class _$TaskDetailsSuccessCopyWithImpl<$Res>
    implements $TaskDetailsSuccessCopyWith<$Res> {
  _$TaskDetailsSuccessCopyWithImpl(this._self, this._then);

  final TaskDetailsSuccess _self;
  final $Res Function(TaskDetailsSuccess) _then;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? busy = null,}) {
  return _then(TaskDetailsSuccess(
null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class TaskDetailsError implements TaskDetailsState {
  const TaskDetailsError(this.failure);
  

 final  Failure failure;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailsErrorCopyWith<TaskDetailsError> get copyWith => _$TaskDetailsErrorCopyWithImpl<TaskDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'TaskDetailsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TaskDetailsErrorCopyWith<$Res> implements $TaskDetailsStateCopyWith<$Res> {
  factory $TaskDetailsErrorCopyWith(TaskDetailsError value, $Res Function(TaskDetailsError) _then) = _$TaskDetailsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$TaskDetailsErrorCopyWithImpl<$Res>
    implements $TaskDetailsErrorCopyWith<$Res> {
  _$TaskDetailsErrorCopyWithImpl(this._self, this._then);

  final TaskDetailsError _self;
  final $Res Function(TaskDetailsError) _then;

/// Create a copy of TaskDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(TaskDetailsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

/// @nodoc


class TaskDetailsDeleted implements TaskDetailsState {
  const TaskDetailsDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetailsDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskDetailsState.deleted()';
}


}




// dart format on
