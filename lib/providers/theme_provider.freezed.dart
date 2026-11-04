// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MyTheme {
  bool get isDark => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyThemeCopyWith<MyTheme> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyThemeCopyWith<$Res> {
  factory $MyThemeCopyWith(MyTheme value, $Res Function(MyTheme) then) =
      _$MyThemeCopyWithImpl<$Res, MyTheme>;
  @useResult
  $Res call({bool isDark});
}

/// @nodoc
class _$MyThemeCopyWithImpl<$Res, $Val extends MyTheme>
    implements $MyThemeCopyWith<$Res> {
  _$MyThemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
  }) {
    return _then(_value.copyWith(
      isDark: null == isDark
          ? _value.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyThemeImplCopyWith<$Res> implements $MyThemeCopyWith<$Res> {
  factory _$$MyThemeImplCopyWith(
          _$MyThemeImpl value, $Res Function(_$MyThemeImpl) then) =
      __$$MyThemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDark});
}

/// @nodoc
class __$$MyThemeImplCopyWithImpl<$Res>
    extends _$MyThemeCopyWithImpl<$Res, _$MyThemeImpl>
    implements _$$MyThemeImplCopyWith<$Res> {
  __$$MyThemeImplCopyWithImpl(
      _$MyThemeImpl _value, $Res Function(_$MyThemeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
  }) {
    return _then(_$MyThemeImpl(
      isDark: null == isDark
          ? _value.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MyThemeImpl implements _MyTheme {
  _$MyThemeImpl({required this.isDark});

  @override
  final bool isDark;

  @override
  String toString() {
    return 'MyTheme(isDark: $isDark)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyThemeImpl &&
            (identical(other.isDark, isDark) || other.isDark == isDark));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDark);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyThemeImplCopyWith<_$MyThemeImpl> get copyWith =>
      __$$MyThemeImplCopyWithImpl<_$MyThemeImpl>(this, _$identity);
}

abstract class _MyTheme implements MyTheme {
  factory _MyTheme({required final bool isDark}) = _$MyThemeImpl;

  @override
  bool get isDark;
  @override
  @JsonKey(ignore: true)
  _$$MyThemeImplCopyWith<_$MyThemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
