// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TasksState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TasksState()';
}


}

/// @nodoc
class $TasksStateCopyWith<$Res>  {
$TasksStateCopyWith(TasksState _, $Res Function(TasksState) __);
}


/// Adds pattern-matching-related methods to [TasksState].
extension TasksStatePatterns on TasksState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TasksInitial value)?  initial,TResult Function( TasksLoading value)?  loading,TResult Function( TasksEmpty value)?  empty,TResult Function( TasksError value)?  error,TResult Function( TasksSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TasksInitial() when initial != null:
return initial(_that);case TasksLoading() when loading != null:
return loading(_that);case TasksEmpty() when empty != null:
return empty(_that);case TasksError() when error != null:
return error(_that);case TasksSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TasksInitial value)  initial,required TResult Function( TasksLoading value)  loading,required TResult Function( TasksEmpty value)  empty,required TResult Function( TasksError value)  error,required TResult Function( TasksSuccess value)  success,}){
final _that = this;
switch (_that) {
case TasksInitial():
return initial(_that);case TasksLoading():
return loading(_that);case TasksEmpty():
return empty(_that);case TasksError():
return error(_that);case TasksSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TasksInitial value)?  initial,TResult? Function( TasksLoading value)?  loading,TResult? Function( TasksEmpty value)?  empty,TResult? Function( TasksError value)?  error,TResult? Function( TasksSuccess value)?  success,}){
final _that = this;
switch (_that) {
case TasksInitial() when initial != null:
return initial(_that);case TasksLoading() when loading != null:
return loading(_that);case TasksEmpty() when empty != null:
return empty(_that);case TasksError() when error != null:
return error(_that);case TasksSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( TaskFilter filter)?  loading,TResult Function( TaskFilter filter)?  empty,TResult Function( Failure failure,  TaskFilter filter)?  error,TResult Function( List<Task> items,  TaskFilter filter,  bool hasMore,  bool refreshing,  bool loadingMore,  Failure? loadMoreFailure)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TasksInitial() when initial != null:
return initial();case TasksLoading() when loading != null:
return loading(_that.filter);case TasksEmpty() when empty != null:
return empty(_that.filter);case TasksError() when error != null:
return error(_that.failure,_that.filter);case TasksSuccess() when success != null:
return success(_that.items,_that.filter,_that.hasMore,_that.refreshing,_that.loadingMore,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( TaskFilter filter)  loading,required TResult Function( TaskFilter filter)  empty,required TResult Function( Failure failure,  TaskFilter filter)  error,required TResult Function( List<Task> items,  TaskFilter filter,  bool hasMore,  bool refreshing,  bool loadingMore,  Failure? loadMoreFailure)  success,}) {final _that = this;
switch (_that) {
case TasksInitial():
return initial();case TasksLoading():
return loading(_that.filter);case TasksEmpty():
return empty(_that.filter);case TasksError():
return error(_that.failure,_that.filter);case TasksSuccess():
return success(_that.items,_that.filter,_that.hasMore,_that.refreshing,_that.loadingMore,_that.loadMoreFailure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( TaskFilter filter)?  loading,TResult? Function( TaskFilter filter)?  empty,TResult? Function( Failure failure,  TaskFilter filter)?  error,TResult? Function( List<Task> items,  TaskFilter filter,  bool hasMore,  bool refreshing,  bool loadingMore,  Failure? loadMoreFailure)?  success,}) {final _that = this;
switch (_that) {
case TasksInitial() when initial != null:
return initial();case TasksLoading() when loading != null:
return loading(_that.filter);case TasksEmpty() when empty != null:
return empty(_that.filter);case TasksError() when error != null:
return error(_that.failure,_that.filter);case TasksSuccess() when success != null:
return success(_that.items,_that.filter,_that.hasMore,_that.refreshing,_that.loadingMore,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class TasksInitial implements TasksState {
  const TasksInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TasksState.initial()';
}


}




/// @nodoc


class TasksLoading implements TasksState {
  const TasksLoading({this.filter = const TaskFilter()});
  

@JsonKey() final  TaskFilter filter;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksLoadingCopyWith<TasksLoading> get copyWith => _$TasksLoadingCopyWithImpl<TasksLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksLoading&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,filter);

@override
String toString() {
  return 'TasksState.loading(filter: $filter)';
}


}

/// @nodoc
abstract mixin class $TasksLoadingCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksLoadingCopyWith(TasksLoading value, $Res Function(TasksLoading) _then) = _$TasksLoadingCopyWithImpl;
@useResult
$Res call({
 TaskFilter filter
});




}
/// @nodoc
class _$TasksLoadingCopyWithImpl<$Res>
    implements $TasksLoadingCopyWith<$Res> {
  _$TasksLoadingCopyWithImpl(this._self, this._then);

  final TasksLoading _self;
  final $Res Function(TasksLoading) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filter = null,}) {
  return _then(TasksLoading(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,
  ));
}


}

/// @nodoc


class TasksEmpty implements TasksState {
  const TasksEmpty({this.filter = const TaskFilter()});
  

@JsonKey() final  TaskFilter filter;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksEmptyCopyWith<TasksEmpty> get copyWith => _$TasksEmptyCopyWithImpl<TasksEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksEmpty&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,filter);

@override
String toString() {
  return 'TasksState.empty(filter: $filter)';
}


}

/// @nodoc
abstract mixin class $TasksEmptyCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksEmptyCopyWith(TasksEmpty value, $Res Function(TasksEmpty) _then) = _$TasksEmptyCopyWithImpl;
@useResult
$Res call({
 TaskFilter filter
});




}
/// @nodoc
class _$TasksEmptyCopyWithImpl<$Res>
    implements $TasksEmptyCopyWith<$Res> {
  _$TasksEmptyCopyWithImpl(this._self, this._then);

  final TasksEmpty _self;
  final $Res Function(TasksEmpty) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? filter = null,}) {
  return _then(TasksEmpty(
filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,
  ));
}


}

/// @nodoc


class TasksError implements TasksState {
  const TasksError(this.failure, {this.filter = const TaskFilter()});
  

 final  Failure failure;
@JsonKey() final  TaskFilter filter;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksErrorCopyWith<TasksError> get copyWith => _$TasksErrorCopyWithImpl<TasksError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksError&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode => Object.hash(runtimeType,failure,filter);

@override
String toString() {
  return 'TasksState.error(failure: $failure, filter: $filter)';
}


}

/// @nodoc
abstract mixin class $TasksErrorCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksErrorCopyWith(TasksError value, $Res Function(TasksError) _then) = _$TasksErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure, TaskFilter filter
});




}
/// @nodoc
class _$TasksErrorCopyWithImpl<$Res>
    implements $TasksErrorCopyWith<$Res> {
  _$TasksErrorCopyWithImpl(this._self, this._then);

  final TasksError _self;
  final $Res Function(TasksError) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? filter = null,}) {
  return _then(TasksError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,
  ));
}


}

/// @nodoc


class TasksSuccess implements TasksState {
  const TasksSuccess({required final  List<Task> items, required this.filter, required this.hasMore, this.refreshing = false, this.loadingMore = false, this.loadMoreFailure}): _items = items;
  

 final  List<Task> _items;
 List<Task> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  TaskFilter filter;
 final  bool hasMore;
@JsonKey() final  bool refreshing;
@JsonKey() final  bool loadingMore;
 final  Failure? loadMoreFailure;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasksSuccessCopyWith<TasksSuccess> get copyWith => _$TasksSuccessCopyWithImpl<TasksSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasksSuccess&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),filter,hasMore,refreshing,loadingMore,loadMoreFailure);

@override
String toString() {
  return 'TasksState.success(items: $items, filter: $filter, hasMore: $hasMore, refreshing: $refreshing, loadingMore: $loadingMore, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class $TasksSuccessCopyWith<$Res> implements $TasksStateCopyWith<$Res> {
  factory $TasksSuccessCopyWith(TasksSuccess value, $Res Function(TasksSuccess) _then) = _$TasksSuccessCopyWithImpl;
@useResult
$Res call({
 List<Task> items, TaskFilter filter, bool hasMore, bool refreshing, bool loadingMore, Failure? loadMoreFailure
});




}
/// @nodoc
class _$TasksSuccessCopyWithImpl<$Res>
    implements $TasksSuccessCopyWith<$Res> {
  _$TasksSuccessCopyWithImpl(this._self, this._then);

  final TasksSuccess _self;
  final $Res Function(TasksSuccess) _then;

/// Create a copy of TasksState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? items = null,Object? filter = null,Object? hasMore = null,Object? refreshing = null,Object? loadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(TasksSuccess(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Task>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
