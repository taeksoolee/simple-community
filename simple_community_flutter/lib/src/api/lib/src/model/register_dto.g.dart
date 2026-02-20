// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterDto extends RegisterDto {
  @override
  final String emailAddress;
  @override
  final String password;

  factory _$RegisterDto([void Function(RegisterDtoBuilder)? updates]) =>
      (RegisterDtoBuilder()..update(updates))._build();

  _$RegisterDto._({required this.emailAddress, required this.password})
      : super._();
  @override
  RegisterDto rebuild(void Function(RegisterDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterDtoBuilder toBuilder() => RegisterDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterDto &&
        emailAddress == other.emailAddress &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, emailAddress.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterDto')
          ..add('emailAddress', emailAddress)
          ..add('password', password))
        .toString();
  }
}

class RegisterDtoBuilder implements Builder<RegisterDto, RegisterDtoBuilder> {
  _$RegisterDto? _$v;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  RegisterDtoBuilder() {
    RegisterDto._defaults(this);
  }

  RegisterDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _emailAddress = $v.emailAddress;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterDto other) {
    _$v = other as _$RegisterDto;
  }

  @override
  void update(void Function(RegisterDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterDto build() => _build();

  _$RegisterDto _build() {
    final _$result = _$v ??
        _$RegisterDto._(
          emailAddress: BuiltValueNullFieldError.checkNotNull(
              emailAddress, r'RegisterDto', 'emailAddress'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'RegisterDto', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
