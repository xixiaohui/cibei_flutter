// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'glossary_term.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GlossaryTerm _$GlossaryTermFromJson(Map<String, dynamic> json) {
  return _GlossaryTerm.fromJson(json);
}

/// @nodoc
mixin _$GlossaryTerm {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get term => throw _privateConstructorUsedError;
  String? get termEn => throw _privateConstructorUsedError;
  String? get termSanskrit => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;
  List<String> get relatedTerms => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GlossaryTerm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlossaryTermCopyWith<GlossaryTerm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlossaryTermCopyWith<$Res> {
  factory $GlossaryTermCopyWith(
          GlossaryTerm value, $Res Function(GlossaryTerm) then) =
      _$GlossaryTermCopyWithImpl<$Res, GlossaryTerm>;
  @useResult
  $Res call(
      {String id,
      String slug,
      String term,
      String? termEn,
      String? termSanskrit,
      String definition,
      List<String> relatedTerms,
      String createdAt});
}

/// @nodoc
class _$GlossaryTermCopyWithImpl<$Res, $Val extends GlossaryTerm>
    implements $GlossaryTermCopyWith<$Res> {
  _$GlossaryTermCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? term = null,
    Object? termEn = freezed,
    Object? termSanskrit = freezed,
    Object? definition = null,
    Object? relatedTerms = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      term: null == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as String,
      termEn: freezed == termEn
          ? _value.termEn
          : termEn // ignore: cast_nullable_to_non_nullable
              as String?,
      termSanskrit: freezed == termSanskrit
          ? _value.termSanskrit
          : termSanskrit // ignore: cast_nullable_to_non_nullable
              as String?,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      relatedTerms: null == relatedTerms
          ? _value.relatedTerms
          : relatedTerms // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlossaryTermImplCopyWith<$Res>
    implements $GlossaryTermCopyWith<$Res> {
  factory _$$GlossaryTermImplCopyWith(
          _$GlossaryTermImpl value, $Res Function(_$GlossaryTermImpl) then) =
      __$$GlossaryTermImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String slug,
      String term,
      String? termEn,
      String? termSanskrit,
      String definition,
      List<String> relatedTerms,
      String createdAt});
}

/// @nodoc
class __$$GlossaryTermImplCopyWithImpl<$Res>
    extends _$GlossaryTermCopyWithImpl<$Res, _$GlossaryTermImpl>
    implements _$$GlossaryTermImplCopyWith<$Res> {
  __$$GlossaryTermImplCopyWithImpl(
      _$GlossaryTermImpl _value, $Res Function(_$GlossaryTermImpl) _then)
      : super(_value, _then);

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? term = null,
    Object? termEn = freezed,
    Object? termSanskrit = freezed,
    Object? definition = null,
    Object? relatedTerms = null,
    Object? createdAt = null,
  }) {
    return _then(_$GlossaryTermImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      term: null == term
          ? _value.term
          : term // ignore: cast_nullable_to_non_nullable
              as String,
      termEn: freezed == termEn
          ? _value.termEn
          : termEn // ignore: cast_nullable_to_non_nullable
              as String?,
      termSanskrit: freezed == termSanskrit
          ? _value.termSanskrit
          : termSanskrit // ignore: cast_nullable_to_non_nullable
              as String?,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      relatedTerms: null == relatedTerms
          ? _value._relatedTerms
          : relatedTerms // ignore: cast_nullable_to_non_nullable
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
class _$GlossaryTermImpl implements _GlossaryTerm {
  const _$GlossaryTermImpl(
      {required this.id,
      required this.slug,
      required this.term,
      this.termEn,
      this.termSanskrit,
      required this.definition,
      final List<String> relatedTerms = const [],
      required this.createdAt})
      : _relatedTerms = relatedTerms;

  factory _$GlossaryTermImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlossaryTermImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String term;
  @override
  final String? termEn;
  @override
  final String? termSanskrit;
  @override
  final String definition;
  final List<String> _relatedTerms;
  @override
  @JsonKey()
  List<String> get relatedTerms {
    if (_relatedTerms is EqualUnmodifiableListView) return _relatedTerms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedTerms);
  }

  @override
  final String createdAt;

  @override
  String toString() {
    return 'GlossaryTerm(id: $id, slug: $slug, term: $term, termEn: $termEn, termSanskrit: $termSanskrit, definition: $definition, relatedTerms: $relatedTerms, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlossaryTermImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.term, term) || other.term == term) &&
            (identical(other.termEn, termEn) || other.termEn == termEn) &&
            (identical(other.termSanskrit, termSanskrit) ||
                other.termSanskrit == termSanskrit) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            const DeepCollectionEquality()
                .equals(other._relatedTerms, _relatedTerms) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      slug,
      term,
      termEn,
      termSanskrit,
      definition,
      const DeepCollectionEquality().hash(_relatedTerms),
      createdAt);

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      __$$GlossaryTermImplCopyWithImpl<_$GlossaryTermImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlossaryTermImplToJson(
      this,
    );
  }
}

abstract class _GlossaryTerm implements GlossaryTerm {
  const factory _GlossaryTerm(
      {required final String id,
      required final String slug,
      required final String term,
      final String? termEn,
      final String? termSanskrit,
      required final String definition,
      final List<String> relatedTerms,
      required final String createdAt}) = _$GlossaryTermImpl;

  factory _GlossaryTerm.fromJson(Map<String, dynamic> json) =
      _$GlossaryTermImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get term;
  @override
  String? get termEn;
  @override
  String? get termSanskrit;
  @override
  String get definition;
  @override
  List<String> get relatedTerms;
  @override
  String get createdAt;

  /// Create a copy of GlossaryTerm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlossaryTermImplCopyWith<_$GlossaryTermImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
