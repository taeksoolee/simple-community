// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreatePostDto extends CreatePostDto {
  @override
  final String title;
  @override
  final String body;

  factory _$CreatePostDto([void Function(CreatePostDtoBuilder)? updates]) =>
      (CreatePostDtoBuilder()..update(updates))._build();

  _$CreatePostDto._({required this.title, required this.body}) : super._();
  @override
  CreatePostDto rebuild(void Function(CreatePostDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreatePostDtoBuilder toBuilder() => CreatePostDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreatePostDto && title == other.title && body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreatePostDto')
          ..add('title', title)
          ..add('body', body))
        .toString();
  }
}

class CreatePostDtoBuilder
    implements Builder<CreatePostDto, CreatePostDtoBuilder> {
  _$CreatePostDto? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  CreatePostDtoBuilder() {
    CreatePostDto._defaults(this);
  }

  CreatePostDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreatePostDto other) {
    _$v = other as _$CreatePostDto;
  }

  @override
  void update(void Function(CreatePostDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreatePostDto build() => _build();

  _$CreatePostDto _build() {
    final _$result = _$v ??
        _$CreatePostDto._(
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'CreatePostDto', 'title'),
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'CreatePostDto', 'body'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
