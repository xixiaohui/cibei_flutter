// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'path_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PathStep _$PathStepFromJson(Map<String, dynamic> json) {
  return _PathStep.fromJson(json);
}

/// @nodoc
mixin _$PathStep {
  String get id => throw _privateConstructorUsedError;
  String get pathId => throw _privateConstructorUsedError;
  int get stepNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get guidance => throw _privateConstructorUsedError;
  List<String> get relatedSutraSlugs => throw _privateConstructorUsedError;
  List<String> get relatedTermSlugs => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PathStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PathStepCopyWith<PathStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathStepCopyWith<$Res> {
  factory $PathStepCopyWith(PathStep value, $Res Function(PathStep) then) =
      _$PathStepCopyWithImpl<$Res, PathStep>;
  @useResult
  $Res call(
      {String id,
      String pathId,
      int stepNumber,
      String title,
      String? description,
      String? guidance,
      List<String> relatedSutraSlugs,
      List<String> relatedTermSlugs,
      String createdAt});
}

/// @nodoc
class _$PathStepCopyWithImpl<$Res, $Val extends PathStep>
    implements $PathStepCopyWith<$Res> {
  _$PathStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pathId = null,
    Object? stepNumber = null,
    Object? title = null,
    Object? description = freezed,
    Object? guidance = freezed,
    Object? relatedSutraSlugs = null,
    Object? relatedTermSlugs = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      guidance: freezed == guidance
          ? _value.guidance
          : guidance // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSutraSlugs: null == relatedSutraSlugs
          ? _value.relatedSutraSlugs
          : relatedSutraSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedTermSlugs: null == relatedTermSlugs
          ? _value.relatedTermSlugs
          : relatedTermSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PathStepImplCopyWith<$Res>
    implements $PathStepCopyWith<$Res> {
  factory _$$PathStepImplCopyWith(
          _$PathStepImpl value, $Res Function(_$PathStepImpl) then) =
      __$$PathStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String pathId,
      int stepNumber,
      String title,
      String? description,
      String? guidance,
      List<String> relatedSutraSlugs,
      List<String> relatedTermSlugs,
      String createdAt});
}

/// @nodoc
class __$$PathStepImplCopyWithImpl<$Res>
    extends _$PathStepCopyWithImpl<$Res, _$PathStepImpl>
    implements _$$PathStepImplCopyWith<$Res> {
  __$$PathStepImplCopyWithImpl(
      _$PathStepImpl _value, $Res Function(_$PathStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pathId = null,
    Object? stepNumber = null,
    Object? title = null,
    Object? description = freezed,
    Object? guidance = freezed,
    Object? relatedSutraSlugs = null,
    Object? relatedTermSlugs = null,
    Object? createdAt = null,
  }) {
    return _then(_$PathStepImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      pathId: null == pathId
          ? _value.pathId
          : pathId // ignore: cast_nullable_to_non_nullable
              as String,
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      guidance: freezed == guidance
          ? _value.guidance
          : guidance // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedSutraSlugs: null == relatedSutraSlugs
          ? _value._relatedSutraSlugs
          : relatedSutraSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedTermSlugs: null == relatedTermSlugs
          ? _value._relatedTermSlugs
          : relatedTermSlugs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PathStepImpl implements _PathStep {
  const _$PathStepImpl(
      {required this.id,
      required this.pathId,
      required this.stepNumber,
      required this.title,
      this.description,
      this.guidance,
      final List<String> relatedSutraSlugs = const [],
      final List<String> relatedTermSlugs = const [],
      required this.createdAt})
      : _relatedSutraSlugs = relatedSutraSlugs,
        _relatedTermSlugs = relatedTermSlugs;

  factory _$PathStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$PathStepImplFromJson(json);

  @override
  final String id;
  @override
  final String pathId;
  @override
  final int stepNumber;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? guidance;
  final List<String> _relatedSutraSlugs;
  @override
  @JsonKey()
  List<String> get relatedSutraSlugs {
    if (_relatedSutraSlugs is EqualUnmodifiableListView)
      return _relatedSutraSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedSutraSlugs);
  }

  final List<String> _relatedTermSlugs;
  @override
  @JsonKey()
  List<String> get relatedTermSlugs {
    if (_relatedTermSlugs is EqualUnmodifiableListView)
      return _relatedTermSlugs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedTermSlugs);
  }

  @override
  final String createdAt;

  @override
  String toString() {
    return 'PathStep(id: $id, pathId: $pathId, stepNumber: $stepNumber, title: $title, description: $description, guidance: $guidance, relatedSutraSlugs: $relatedSutraSlugs, relatedTermSlugs: $relatedTermSlugs, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pathId, pathId) || other.pathId == pathId) &&
            (identical(other.stepNumber, stepNumber) ||
                other.stepNumber == stepNumber) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.guidance, guidance) ||
                other.guidance == guidance) &&
            const DeepCollectionEquality()
                .equals(other._relatedSutraSlugs, _relatedSutraSlugs) &&
            const DeepCollectionEquality()
                .equals(other._relatedTermSlugs, _relatedTermSlugs) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      pathId,
      stepNumber,
      title,
      description,
      guidance,
      const DeepCollectionEquality().hash(_relatedSutraSlugs),
      const DeepCollectionEquality().hash(_relatedTermSlugs),
      createdAt);

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PathStepImplCopyWith<_$PathStepImpl> get copyWith =>
      __$$PathStepImplCopyWithImpl<_$PathStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PathStepImplToJson(
      this,
    );
  }
}

abstract class _PathStep implements PathStep {
  const factory _PathStep(
      {required final String id,
      required final String pathId,
      required final int stepNumber,
      required final String title,
      final String? description,
      final String? guidance,
      final List<String> relatedSutraSlugs,
      final List<String> relatedTermSlugs,
      required final String createdAt}) = _$PathStepImpl;

  factory _PathStep.fromJson(Map<String, dynamic> json) =
      _$PathStepImpl.fromJson;

  @override
  String get id;
  @override
  String get pathId;
  @override
  int get stepNumber;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get guidance;
  @override
  List<String> get relatedSutraSlugs;
  @override
  List<String> get relatedTermSlugs;
  @override
  String get createdAt;

  /// Create a copy of PathStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PathStepImplCopyWith<_$PathStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
