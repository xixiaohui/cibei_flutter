// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encyclopedia_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EncyclopediaEntry _$EncyclopediaEntryFromJson(Map<String, dynamic> json) {
  return _EncyclopediaEntry.fromJson(json);
}

/// @nodoc
mixin _$EncyclopediaEntry {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this EncyclopediaEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EncyclopediaEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EncyclopediaEntryCopyWith<EncyclopediaEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncyclopediaEntryCopyWith<$Res> {
  factory $EncyclopediaEntryCopyWith(
          EncyclopediaEntry value, $Res Function(EncyclopediaEntry) then) =
      _$EncyclopediaEntryCopyWithImpl<$Res, EncyclopediaEntry>;
  @useResult
  $Res call(
      {String id,
      String slug,
      String title,
      String? category,
      String content,
      String createdAt});
}

/// @nodoc
class _$EncyclopediaEntryCopyWithImpl<$Res, $Val extends EncyclopediaEntry>
    implements $EncyclopediaEntryCopyWith<$Res> {
  _$EncyclopediaEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EncyclopediaEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? title = null,
    Object? category = freezed,
    Object? content = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EncyclopediaEntryImplCopyWith<$Res>
    implements $EncyclopediaEntryCopyWith<$Res> {
  factory _$$EncyclopediaEntryImplCopyWith(_$EncyclopediaEntryImpl value,
          $Res Function(_$EncyclopediaEntryImpl) then) =
      __$$EncyclopediaEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String slug,
      String title,
      String? category,
      String content,
      String createdAt});
}

/// @nodoc
class __$$EncyclopediaEntryImplCopyWithImpl<$Res>
    extends _$EncyclopediaEntryCopyWithImpl<$Res, _$EncyclopediaEntryImpl>
    implements _$$EncyclopediaEntryImplCopyWith<$Res> {
  __$$EncyclopediaEntryImplCopyWithImpl(_$EncyclopediaEntryImpl _value,
      $Res Function(_$EncyclopediaEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of EncyclopediaEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? title = null,
    Object? category = freezed,
    Object? content = null,
    Object? createdAt = null,
  }) {
    return _then(_$EncyclopediaEntryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EncyclopediaEntryImpl implements _EncyclopediaEntry {
  const _$EncyclopediaEntryImpl(
      {required this.id,
      required this.slug,
      required this.title,
      this.category,
      required this.content,
      required this.createdAt});

  factory _$EncyclopediaEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EncyclopediaEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String slug;
  @override
  final String title;
  @override
  final String? category;
  @override
  final String content;
  @override
  final String createdAt;

  @override
  String toString() {
    return 'EncyclopediaEntry(id: $id, slug: $slug, title: $title, category: $category, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncyclopediaEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, slug, title, category, content, createdAt);

  /// Create a copy of EncyclopediaEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EncyclopediaEntryImplCopyWith<_$EncyclopediaEntryImpl> get copyWith =>
      __$$EncyclopediaEntryImplCopyWithImpl<_$EncyclopediaEntryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EncyclopediaEntryImplToJson(
      this,
    );
  }
}

abstract class _EncyclopediaEntry implements EncyclopediaEntry {
  const factory _EncyclopediaEntry(
      {required final String id,
      required final String slug,
      required final String title,
      final String? category,
      required final String content,
      required final String createdAt}) = _$EncyclopediaEntryImpl;

  factory _EncyclopediaEntry.fromJson(Map<String, dynamic> json) =
      _$EncyclopediaEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get title;
  @override
  String? get category;
  @override
  String get content;
  @override
  String get createdAt;

  /// Create a copy of EncyclopediaEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EncyclopediaEntryImplCopyWith<_$EncyclopediaEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
