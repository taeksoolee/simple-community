// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginDto extends LoginDto {
  @override
  final String emailAddress;
  @override
  final String password;

  factory _$LoginDto([void Function(LoginDtoBuilder)? updates]) =>
      (LoginDtoBuilder()..update(updates))._build();

  _$LoginDto._({required this.emailAddress, required this.password})
      : super._();
  @override
  LoginDto rebuild(void Function(LoginDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginDtoBuilder toBuilder() => LoginDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginDto &&
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
    return (newBuiltValueToStringHelper(r'LoginDto')
          ..add('emailAddress', emailAddress)
          ..add('password', password))
        .toString();
  }
}

class LoginDtoBuilder implements Builder<LoginDto, LoginDtoBuilder> {
  _$LoginDto? _$v;

  String? _emailAddress;
  String? get emailAddress => _$this._emailAddress;
  set emailAddress(String? emailAddress) => _$this._emailAddress = emailAddress;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  LoginDtoBuilder() {
    LoginDto._defaults(this);
  }

  LoginDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _emailAddress = $v.emailAddress;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginDto other) {
    _$v = other as _$LoginDto;
  }

  @override
  void update(void Function(LoginDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginDto build() => _build();

  _$LoginDto _build() {
    final _$result = _$v ??
        _$LoginDto._(
          emailAddress: BuiltValueNullFieldError.checkNotNull(
              emailAddress, r'LoginDto', 'emailAddress'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'LoginDto', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
