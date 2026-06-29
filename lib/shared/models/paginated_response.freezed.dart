// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaginatedResponse _$PaginatedResponseFromJson(Map<String, dynamic> json) {
  return _PaginatedResponse.fromJson(json);
}

/// @nodoc
mixin _$PaginatedResponse {
  List<dynamic> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this PaginatedResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedResponseCopyWith<PaginatedResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedResponseCopyWith<$Res> {
  factory $PaginatedResponseCopyWith(
          PaginatedResponse value, $Res Function(PaginatedResponse) then) =
      _$PaginatedResponseCopyWithImpl<$Res, PaginatedResponse>;
  @useResult
  $Res call(
      {List<dynamic> items, int total, int page, int pageSize, int totalPages});
}

/// @nodoc
class _$PaginatedResponseCopyWithImpl<$Res, $Val extends PaginatedResponse>
    implements $PaginatedResponseCopyWith<$Res> {
  _$PaginatedResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedResponseImplCopyWith<$Res>
    implements $PaginatedResponseCopyWith<$Res> {
  factory _$$PaginatedResponseImplCopyWith(_$PaginatedResponseImpl value,
          $Res Function(_$PaginatedResponseImpl) then) =
      __$$PaginatedResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<dynamic> items, int total, int page, int pageSize, int totalPages});
}

/// @nodoc
class __$$PaginatedResponseImplCopyWithImpl<$Res>
    extends _$PaginatedResponseCopyWithImpl<$Res, _$PaginatedResponseImpl>
    implements _$$PaginatedResponseImplCopyWith<$Res> {
  __$$PaginatedResponseImplCopyWithImpl(_$PaginatedResponseImpl _value,
      $Res Function(_$PaginatedResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? pageSize = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginatedResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedResponseImpl implements _PaginatedResponse {
  const _$PaginatedResponseImpl(
      {final List<dynamic> items = const [],
      required this.total,
      required this.page,
      required this.pageSize,
      required this.totalPages})
      : _items = items;

  factory _$PaginatedResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedResponseImplFromJson(json);

  final List<dynamic> _items;
  @override
  @JsonKey()
  List<dynamic> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PaginatedResponse(items: $items, total: $total, page: $page, pageSize: $pageSize, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      total,
      page,
      pageSize,
      totalPages);

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedResponseImplCopyWith<_$PaginatedResponseImpl> get copyWith =>
      __$$PaginatedResponseImplCopyWithImpl<_$PaginatedResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedResponseImplToJson(
      this,
    );
  }
}

abstract class _PaginatedResponse implements PaginatedResponse {
  const factory _PaginatedResponse(
      {final List<dynamic> items,
      required final int total,
      required final int page,
      required final int pageSize,
      required final int totalPages}) = _$PaginatedResponseImpl;

  factory _PaginatedResponse.fromJson(Map<String, dynamic> json) =
      _$PaginatedResponseImpl.fromJson;

  @override
  List<dynamic> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  int get totalPages;

  /// Create a copy of PaginatedResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedResponseImplCopyWith<_$PaginatedResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
