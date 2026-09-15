// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projects_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsState()';
}


}

/// @nodoc
class $ProjectsStateCopyWith<$Res>  {
$ProjectsStateCopyWith(ProjectsState _, $Res Function(ProjectsState) __);
}


/// Adds pattern-matching-related methods to [ProjectsState].
extension ProjectsStatePatterns on ProjectsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProjectsInitial value)?  initial,TResult Function( ProjectsLoading value)?  loading,TResult Function( ProjectsEmpty value)?  empty,TResult Function( ProjectsSuccess value)?  success,TResult Function( ProjectsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProjectsInitial() when initial != null:
return initial(_that);case ProjectsLoading() when loading != null:
return loading(_that);case ProjectsEmpty() when empty != null:
return empty(_that);case ProjectsSuccess() when success != null:
return success(_that);case ProjectsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProjectsInitial value)  initial,required TResult Function( ProjectsLoading value)  loading,required TResult Function( ProjectsEmpty value)  empty,required TResult Function( ProjectsSuccess value)  success,required TResult Function( ProjectsError value)  error,}){
final _that = this;
switch (_that) {
case ProjectsInitial():
return initial(_that);case ProjectsLoading():
return loading(_that);case ProjectsEmpty():
return empty(_that);case ProjectsSuccess():
return success(_that);case ProjectsError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProjectsInitial value)?  initial,TResult? Function( ProjectsLoading value)?  loading,TResult? Function( ProjectsEmpty value)?  empty,TResult? Function( ProjectsSuccess value)?  success,TResult? Function( ProjectsError value)?  error,}){
final _that = this;
switch (_that) {
case ProjectsInitial() when initial != null:
return initial(_that);case ProjectsLoading() when loading != null:
return loading(_that);case ProjectsEmpty() when empty != null:
return empty(_that);case ProjectsSuccess() when success != null:
return success(_that);case ProjectsError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  empty,TResult Function( List<Project> projects,  bool refreshing)?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProjectsInitial() when initial != null:
return initial();case ProjectsLoading() when loading != null:
return loading();case ProjectsEmpty() when empty != null:
return empty();case ProjectsSuccess() when success != null:
return success(_that.projects,_that.refreshing);case ProjectsError() when error != null:
return error(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  empty,required TResult Function( List<Project> projects,  bool refreshing)  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ProjectsInitial():
return initial();case ProjectsLoading():
return loading();case ProjectsEmpty():
return empty();case ProjectsSuccess():
return success(_that.projects,_that.refreshing);case ProjectsError():
return error(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  empty,TResult? Function( List<Project> projects,  bool refreshing)?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ProjectsInitial() when initial != null:
return initial();case ProjectsLoading() when loading != null:
return loading();case ProjectsEmpty() when empty != null:
return empty();case ProjectsSuccess() when success != null:
return success(_that.projects,_that.refreshing);case ProjectsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ProjectsInitial implements ProjectsState {
  const ProjectsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsState.initial()';
}


}




/// @nodoc


class ProjectsLoading implements ProjectsState {
  const ProjectsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsState.loading()';
}


}




/// @nodoc


class ProjectsEmpty implements ProjectsState {
  const ProjectsEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectsState.empty()';
}


}




/// @nodoc


class ProjectsSuccess implements ProjectsState {
  const ProjectsSuccess({required final  List<Project> projects, this.refreshing = false}): _projects = projects;
  

 final  List<Project> _projects;
 List<Project> get projects {
  if (_projects is EqualUnmodifiableListView) return _projects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_projects);
}

@JsonKey() final  bool refreshing;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectsSuccessCopyWith<ProjectsSuccess> get copyWith => _$ProjectsSuccessCopyWithImpl<ProjectsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsSuccess&&const DeepCollectionEquality().equals(other._projects, _projects)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_projects),refreshing);

@override
String toString() {
  return 'ProjectsState.success(projects: $projects, refreshing: $refreshing)';
}


}

/// @nodoc
abstract mixin class $ProjectsSuccessCopyWith<$Res> implements $ProjectsStateCopyWith<$Res> {
  factory $ProjectsSuccessCopyWith(ProjectsSuccess value, $Res Function(ProjectsSuccess) _then) = _$ProjectsSuccessCopyWithImpl;
@useResult
$Res call({
 List<Project> projects, bool refreshing
});




}
/// @nodoc
class _$ProjectsSuccessCopyWithImpl<$Res>
    implements $ProjectsSuccessCopyWith<$Res> {
  _$ProjectsSuccessCopyWithImpl(this._self, this._then);

  final ProjectsSuccess _self;
  final $Res Function(ProjectsSuccess) _then;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? projects = null,Object? refreshing = null,}) {
  return _then(ProjectsSuccess(
projects: null == projects ? _self._projects : projects // ignore: cast_nullable_to_non_nullable
as List<Project>,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ProjectsError implements ProjectsState {
  const ProjectsError(this.failure);
  

 final  Failure failure;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectsErrorCopyWith<ProjectsError> get copyWith => _$ProjectsErrorCopyWithImpl<ProjectsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ProjectsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProjectsErrorCopyWith<$Res> implements $ProjectsStateCopyWith<$Res> {
  factory $ProjectsErrorCopyWith(ProjectsError value, $Res Function(ProjectsError) _then) = _$ProjectsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ProjectsErrorCopyWithImpl<$Res>
    implements $ProjectsErrorCopyWith<$Res> {
  _$ProjectsErrorCopyWithImpl(this._self, this._then);

  final ProjectsError _self;
  final $Res Function(ProjectsError) _then;

/// Create a copy of ProjectsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ProjectsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
