// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_details_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectDetailsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectDetailsState()';
}


}

/// @nodoc
class $ProjectDetailsStateCopyWith<$Res>  {
$ProjectDetailsStateCopyWith(ProjectDetailsState _, $Res Function(ProjectDetailsState) __);
}


/// Adds pattern-matching-related methods to [ProjectDetailsState].
extension ProjectDetailsStatePatterns on ProjectDetailsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProjectDetailsInitial value)?  initial,TResult Function( ProjectDetailsLoading value)?  loading,TResult Function( ProjectDetailsSuccess value)?  success,TResult Function( ProjectDetailsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProjectDetailsInitial() when initial != null:
return initial(_that);case ProjectDetailsLoading() when loading != null:
return loading(_that);case ProjectDetailsSuccess() when success != null:
return success(_that);case ProjectDetailsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProjectDetailsInitial value)  initial,required TResult Function( ProjectDetailsLoading value)  loading,required TResult Function( ProjectDetailsSuccess value)  success,required TResult Function( ProjectDetailsError value)  error,}){
final _that = this;
switch (_that) {
case ProjectDetailsInitial():
return initial(_that);case ProjectDetailsLoading():
return loading(_that);case ProjectDetailsSuccess():
return success(_that);case ProjectDetailsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProjectDetailsInitial value)?  initial,TResult? Function( ProjectDetailsLoading value)?  loading,TResult? Function( ProjectDetailsSuccess value)?  success,TResult? Function( ProjectDetailsError value)?  error,}){
final _that = this;
switch (_that) {
case ProjectDetailsInitial() when initial != null:
return initial(_that);case ProjectDetailsLoading() when loading != null:
return loading(_that);case ProjectDetailsSuccess() when success != null:
return success(_that);case ProjectDetailsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Project project)?  success,TResult Function( Failure failure)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProjectDetailsInitial() when initial != null:
return initial();case ProjectDetailsLoading() when loading != null:
return loading();case ProjectDetailsSuccess() when success != null:
return success(_that.project);case ProjectDetailsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Project project)  success,required TResult Function( Failure failure)  error,}) {final _that = this;
switch (_that) {
case ProjectDetailsInitial():
return initial();case ProjectDetailsLoading():
return loading();case ProjectDetailsSuccess():
return success(_that.project);case ProjectDetailsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Project project)?  success,TResult? Function( Failure failure)?  error,}) {final _that = this;
switch (_that) {
case ProjectDetailsInitial() when initial != null:
return initial();case ProjectDetailsLoading() when loading != null:
return loading();case ProjectDetailsSuccess() when success != null:
return success(_that.project);case ProjectDetailsError() when error != null:
return error(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class ProjectDetailsInitial implements ProjectDetailsState {
  const ProjectDetailsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectDetailsState.initial()';
}


}




/// @nodoc


class ProjectDetailsLoading implements ProjectDetailsState {
  const ProjectDetailsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProjectDetailsState.loading()';
}


}




/// @nodoc


class ProjectDetailsSuccess implements ProjectDetailsState {
  const ProjectDetailsSuccess(this.project);
  

 final  Project project;

/// Create a copy of ProjectDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDetailsSuccessCopyWith<ProjectDetailsSuccess> get copyWith => _$ProjectDetailsSuccessCopyWithImpl<ProjectDetailsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailsSuccess&&(identical(other.project, project) || other.project == project));
}


@override
int get hashCode => Object.hash(runtimeType,project);

@override
String toString() {
  return 'ProjectDetailsState.success(project: $project)';
}


}

/// @nodoc
abstract mixin class $ProjectDetailsSuccessCopyWith<$Res> implements $ProjectDetailsStateCopyWith<$Res> {
  factory $ProjectDetailsSuccessCopyWith(ProjectDetailsSuccess value, $Res Function(ProjectDetailsSuccess) _then) = _$ProjectDetailsSuccessCopyWithImpl;
@useResult
$Res call({
 Project project
});




}
/// @nodoc
class _$ProjectDetailsSuccessCopyWithImpl<$Res>
    implements $ProjectDetailsSuccessCopyWith<$Res> {
  _$ProjectDetailsSuccessCopyWithImpl(this._self, this._then);

  final ProjectDetailsSuccess _self;
  final $Res Function(ProjectDetailsSuccess) _then;

/// Create a copy of ProjectDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? project = null,}) {
  return _then(ProjectDetailsSuccess(
null == project ? _self.project : project // ignore: cast_nullable_to_non_nullable
as Project,
  ));
}


}

/// @nodoc


class ProjectDetailsError implements ProjectDetailsState {
  const ProjectDetailsError(this.failure);
  

 final  Failure failure;

/// Create a copy of ProjectDetailsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDetailsErrorCopyWith<ProjectDetailsError> get copyWith => _$ProjectDetailsErrorCopyWithImpl<ProjectDetailsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetailsError&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ProjectDetailsState.error(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProjectDetailsErrorCopyWith<$Res> implements $ProjectDetailsStateCopyWith<$Res> {
  factory $ProjectDetailsErrorCopyWith(ProjectDetailsError value, $Res Function(ProjectDetailsError) _then) = _$ProjectDetailsErrorCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$ProjectDetailsErrorCopyWithImpl<$Res>
    implements $ProjectDetailsErrorCopyWith<$Res> {
  _$ProjectDetailsErrorCopyWithImpl(this._self, this._then);

  final ProjectDetailsError _self;
  final $Res Function(ProjectDetailsError) _then;

/// Create a copy of ProjectDetailsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ProjectDetailsError(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
