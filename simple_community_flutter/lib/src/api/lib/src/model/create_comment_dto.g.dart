// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateCommentDto extends CreateCommentDto {
  @override
  final String body;
  @override
  final num? parentId;

  factory _$CreateCommentDto(
          [void Function(CreateCommentDtoBuilder)? updates]) =>
      (CreateCommentDtoBuilder()..update(updates))._build();

  _$CreateCommentDto._({required this.body, this.parentId}) : super._();
  @override
  CreateCommentDto rebuild(void Function(CreateCommentDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateCommentDtoBuilder toBuilder() =>
      CreateCommentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateCommentDto &&
        body == other.body &&
        parentId == other.parentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateCommentDto')
          ..add('body', body)
          ..add('parentId', parentId))
        .toString();
  }
}

class CreateCommentDtoBuilder
    implements Builder<CreateCommentDto, CreateCommentDtoBuilder> {
  _$CreateCommentDto? _$v;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  num? _parentId;
  num? get parentId => _$this._parentId;
  set parentId(num? parentId) => _$this._parentId = parentId;

  CreateCommentDtoBuilder() {
    CreateCommentDto._defaults(this);
  }

  CreateCommentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _body = $v.body;
      _parentId = $v.parentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateCommentDto other) {
    _$v = other as _$CreateCommentDto;
  }

  @override
  void update(void Function(CreateCommentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateCommentDto build() => _build();

  _$CreateCommentDto _build() {
    final _$result = _$v ??
        _$CreateCommentDto._(
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'CreateCommentDto', 'body'),
          parentId: parentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
